//
//  GalleryController.m
//  PhotoGallery
//
//  Created by Gennady Berezovsky on 25.11.14.
//  Copyright (c) 2014 aiwo. All rights reserved.
//

#import "GalleryController.h"
#import "ZoomableImageView.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa.h>
#import <UIView+TKGeometry.h>
#import "UIFont+MeduzaFonts.h"
#import <SDWebImage/SDWebImagePrefetcher.h>
#import "MyScrollView.h"

NSString *const kDeviceWillChangeOrientatoinNotification = @"kDeviceWillChangeOrientatoinNotification";

@interface GalleryController () <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet MyScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *photoIndexLabel;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) NSNumber *currentPhotoIndex;
@property (strong, nonatomic) NSArray *imageViews;
@property (assign, nonatomic) BOOL rotating;

@end

@implementation GalleryController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photoIndexLabel.font = [UIFont fontWithStyle:MeduzaFontStyleRegular40pt];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    NSMutableArray *array = [NSMutableArray new];
    [self.photos enumerateObjectsUsingBlock:^(NSString *photoUrlString, NSUInteger idx, BOOL *stop) {
        ZoomableImageView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZoomableImageView class]) owner:0 options:0][0];
        [self.scrollView addSubview:view];
        if (idx == 0) {
            view.photoUrl = self.photos[idx];
        }
        [array addObject:view];
    }];
    self.imageViews = array;
    
    [self updateConstraints];
    [self configureSignals];
}

- (void)configureSignals
{
    __weak typeof(self) weakSelf = self;
    [[RACObserve(self, scrollView.contentOffset) throttle:0.01f] subscribeNext:^(NSValue *offset) {
        CGPoint contentOffset = offset.CGPointValue;
        NSInteger index = MIN(contentOffset.x / self.scrollView.width, self.photos.count - 1);
        weakSelf.currentPhotoIndex = @(index);
        
        NSInteger nextIndex = weakSelf.currentPhotoIndex.integerValue + 1;
        if (nextIndex < weakSelf.imageViews.count) {
            ZoomableImageView *imageView = weakSelf.imageViews[nextIndex];
            if (!imageView.photoUrl) {
                imageView.photoUrl = [NSURL URLWithString:self.photos[nextIndex]];
            }
        }
    }];
    
    RAC(self, photoIndexLabel.text) = [RACObserve(self, currentPhotoIndex) map:^id(NSNumber *value) {
        return [NSString stringWithFormat:@"%i/%i", value.integerValue + 1, weakSelf.photos.count];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"START");
    [[NSNotificationCenter defaultCenter] postNotificationName:kDeviceWillChangeOrientatoinNotification object:@(duration)];
    
    [self.scrollView setContentOffset:CGPointMake(self.currentPhotoIndex.integerValue * self.scrollView.height, 0) animated:YES];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    NSLog(@"END");
}

- (void)updateConstraints
{
    __block UIView *lastView = nil;
    [self.imageViews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.left.equalTo(lastView.mas_right);
            } else {
                make.left.equalTo(self.scrollView.mas_left);
            }
            
            make.top.equalTo(self.scrollView.mas_top);
            make.height.equalTo(self.scrollView.mas_height);
            make.bottom.equalTo(self.scrollView.mas_bottom);
            make.width.equalTo(self.scrollView.mas_width);
            
            if (idx == self.photos.count - 1) {
                make.right.equalTo(self.scrollView.mas_right);
            }
        }];
        lastView = view;
        [view updateConstraints];
    }];
}

#pragma mark - Button Actions

- (IBAction)shareButtonPressed:(id)sender {
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[self.photos[self.currentPhotoIndex.integerValue]] applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)closeButtonPressed:(id)sender {
    if (self.navigationController.topViewController == self) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
