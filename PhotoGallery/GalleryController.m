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

@interface GalleryController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation GalleryController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    __block UIView *lastView = nil;
    [self.photos enumerateObjectsUsingBlock:^(NSString *photoUrlString, NSUInteger idx, BOOL *stop) {
        ZoomableImageView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZoomableImageView class]) owner:0 options:0][0];
        view.photoUrl = [NSURL URLWithString:photoUrlString];
        [self.scrollView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.left.equalTo(lastView.mas_right);
            } else {
                make.left.equalTo(@(0));
            }
            
            make.top.equalTo(@(0));
            make.height.equalTo(self.view.mas_height);
            make.bottom.equalTo(self.scrollView.mas_bottom);
            make.width.equalTo(self.view.mas_width);
            
            if (idx == self.photos.count - 1) {
                make.right.equalTo(self.scrollView.mas_right);
            }
        }];
        lastView = view;
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (ZoomableImageView *)imageViewForIndex:(NSInteger)index
{
    return 0;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    __block UIView *lastView = nil;
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.left.equalTo(lastView.mas_right);
            } else {
                make.left.equalTo(@(0));
            }
            
            make.top.equalTo(@(0));
            make.height.equalTo(self.view.mas_height);
            make.bottom.equalTo(self.scrollView.mas_bottom);
            make.width.equalTo(self.view.mas_width);
            
            if (idx == self.photos.count - 1) {
                make.right.equalTo(self.scrollView.mas_right);
            }
        }];
        lastView = view;
        [view updateConstraints];
    }];
}


@end
