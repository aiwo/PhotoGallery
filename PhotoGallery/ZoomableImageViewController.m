//
//  ZoomableImageViewController.m
//  PhotoGallery
//
//  Created by Gennady Berezovsky on 30.11.14.
//  Copyright (c) 2014 aiwo. All rights reserved.
//

#import "ZoomableImageViewController.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>
#import <ReactiveCocoa.h>

@interface ZoomableImageViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;
@property (nonatomic) CGFloat lastZoomScale;

@end

@implementation ZoomableImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.delegate = self;
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];
    [self.scrollView addGestureRecognizer:singleTapRecognizer];
    
    self.imageView.alpha = 0;
    [self.imageView sd_setImageWithURL:self.photoUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:0.3f animations:^{
            self.imageView.alpha = 1;
        }];
        [self updateZoom];
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale];
}

#pragma marl - Rotation Handling

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    UIInterfaceOrientation currentOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    BOOL differentOrientation = currentOrientation != toInterfaceOrientation;
    differentOrientation ^= UIDeviceOrientationIsLandscape(currentOrientation) && UIDeviceOrientationIsLandscape(toInterfaceOrientation);
    [self updateZoom];
}

- (void) scrollViewDidZoom:(UIScrollView *)scrollView {
    [self updateConstraints];
}

- (void) updateConstraints {
    float imageWidth = self.imageView.image.size.width;
    float imageHeight = self.imageView.image.size.height;
    
    float viewWidth = self.view.bounds.size.width;
    float viewHeight = self.view.bounds.size.height;
    
    float hPadding = (viewWidth - self.scrollView.zoomScale * imageWidth) / 2;
    if (hPadding < 0) hPadding = 0;
    
    float vPadding = (viewHeight - self.scrollView.zoomScale * imageHeight) / 2;
    if (vPadding < 0) vPadding = 0;
    
    self.constraintLeft.constant = hPadding;
    self.constraintRight.constant = hPadding;
    
    self.constraintTop.constant = vPadding;
    self.constraintBottom.constant = vPadding;
    
    [self.view layoutIfNeeded];
}

- (void) updateZoom {
    float minZoom = MIN(self.view.bounds.size.width / self.imageView.image.size.width,
                        self.view.bounds.size.height / self.imageView.image.size.height);
    
    if (minZoom > 1) minZoom = 1;
    
    self.scrollView.minimumZoomScale = minZoom;
    self.scrollView.maximumZoomScale = minZoom * maximumZoomMultiplier;
    
    if (minZoom == self.lastZoomScale) minZoom += 0.000001;
    
    self.lastZoomScale = self.scrollView.zoomScale = minZoom;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

#pragma mark - Gesture Handling

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    if (self.singleTapHandler)
        self.singleTapHandler();
}

static CGFloat maximumZoomMultiplier = 4.f;

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    CGFloat minZoomScale = self.scrollView.minimumZoomScale;
    CGFloat zoomScale = self.scrollView.zoomScale > minZoomScale ? minZoomScale : minZoomScale * maximumZoomMultiplier;
    
    CGPoint center = [recognizer locationInView:self.imageView];
    if (zoomScale <= 1.f) {
        center = self.view.center;
    }
    
    self.scrollView.scrollEnabled = YES;
    CGSize scrollViewSize = self.view.bounds.size;
    
    CGFloat w = scrollViewSize.width / zoomScale;
    CGFloat h = scrollViewSize.height / zoomScale;
    CGFloat x = center.x - (w / 2.0f);
    CGFloat y = center.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
}

@end
