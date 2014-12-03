//
//  PageViewController.m
//  PhotoGallery
//
//  Created by Gennady Berezovsky on 30.11.14.
//  Copyright (c) 2014 aiwo. All rights reserved.
//

#import "PageViewController.h"
#import "ZoomableImageViewController.h"
#import "UIFont+MeduzaFonts.h"
#import <ReactiveCocoa.h>

@interface PageViewController () <UIPageViewControllerDataSource>

@property (strong, nonatomic) IBOutlet UILabel *photoIndexLabel;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *photoURLs;
@property (nonatomic, strong) NSNumber *currentPhotoIndex;
@property (nonatomic, assign) BOOL buttonsHidden;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoIndexLabel.font = [UIFont fontWithStyle:MeduzaFontStyleRegular40pt];
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:nil];
    
    self.pageViewController.dataSource = self;
    
    self.pageViewController.view.frame = self.view.frame;
    
    UIViewController *controller = [self viewControllerForIndex:0];
    [self.pageViewController setViewControllers:@[controller] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
    }];
    
    [self addChildViewController:self.pageViewController];
    [self.view insertSubview:self.pageViewController.view atIndex:0];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self configureSignals];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

#pragma marl - RAC

- (void)configureSignals
{
    __weak typeof(self) weakSelf = self;
    
    RAC(self, photoIndexLabel.text) = [RACObserve(self, currentPhotoIndex) map:^id(NSNumber *value) {
        return [NSString stringWithFormat:@"%i/%lu", value.integerValue + 1, (unsigned long)weakSelf.photos.count];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIDeviceOrientationDidChangeNotification object:0] subscribeNext:^(id x) {
        BOOL hideButtons = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation);
        [self setButtonsHidden:hideButtons];
    }];
}

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    NSMutableArray *array = [NSMutableArray new];
    for (NSString *photo in photos) {
        NSURL *url = [NSURL URLWithString:photo];
        [array addObject:url];
    }
    self.photoURLs = array;
}

- (void)setButtonsHidden:(BOOL)buttonsHidden
{
    _buttonsHidden = buttonsHidden;
    
    [UIView animateWithDuration:0.15f animations:^{
        self.closeButton.alpha =
        self.shareButton.alpha =
        self.photoIndexLabel.alpha = !buttonsHidden;
    }];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(ZoomableImageViewController *)viewController
{
    NSInteger index = [self indexOfViewController:viewController];
    index++;
    return [self viewControllerForIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(ZoomableImageViewController *)viewController
{
    NSInteger index = [self indexOfViewController:viewController];
    index--;
    return [self viewControllerForIndex:index];
}

- (UIViewController *)viewControllerForIndex:(NSInteger)index
{
    if (index < 0 || index >= self.photos.count)
        return nil;
    
    NSURL *url = self.photoURLs[index];
    ZoomableImageViewController *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:NSStringFromClass([ZoomableImageViewController class])];
    controller.photoUrl = url;
    controller.singleTapHandler = ^() {
        self.buttonsHidden = !self.buttonsHidden;
    };
    
    return controller;
}

- (NSUInteger)indexOfViewController:(ZoomableImageViewController *)viewController
{
    NSUInteger index = [self.photoURLs indexOfObject:viewController.photoUrl];
    self.currentPhotoIndex = @(index);
    return index;
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

#pragma mark - Interface Orientation

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscape;
}

@end
