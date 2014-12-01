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

@end

@implementation ZoomableImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.delegate = self;
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.scrollView addGestureRecognizer:pinchRecognizer];
    
    self.imageView.alpha = 0;
    [self.imageView sd_setImageWithURL:self.photoUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:0.3f animations:^{
            self.imageView.alpha = 1;
        }];
        [self updateConstraintsForOrientation:NO];
    }];
}

#pragma marl - Rotation Handling

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self updateConstraintsForOrientation:YES];
}

- (void)updateConstraintsForOrientation:(BOOL)orientation
{
    [self.scrollView removeConstraints:self.scrollView.constraints];
    [self.imageView removeConstraints:self.imageView.constraints];
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.scrollView);
        CGSize imageSize = self.imageView.image.size;
        CGFloat imageRatio = imageSize.width / imageSize.height;
        CGSize size = self.view.frame.size;
        
        if (orientation) {
            size = CGSizeMake(size.height, size.width);
        }
        
        if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
            make.width.equalTo(self.scrollView);
            make.height.equalTo(@(size.width / imageRatio));
        } else {
            make.width.equalTo(@(size.height * imageRatio));
            make.height.equalTo(self.scrollView);
        }
    }];
}

#pragma mark - Gesture Handling

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{   CGFloat zoomScale = self.scrollView.zoomScale > 1.f ? 1 : self.scrollView.maximumZoomScale;
    
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

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    if ([recognizer state] == UIGestureRecognizerStateBegan) {
        recognizer.scale = self.scrollView.zoomScale;
    }
    
    self.scrollView.zoomScale = recognizer.scale;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
