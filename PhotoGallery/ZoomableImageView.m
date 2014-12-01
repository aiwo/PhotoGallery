//
//  ZoomableImageView.m
//  PhotoGallery
//
//  Created by Gennady Berezovsky on 26.11.14.
//  Copyright (c) 2014 aiwo. All rights reserved.
//

#import "ZoomableImageView.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>
#import <ReactiveCocoa.h>
#import <UIView+TKGeometry.h>
#import "GalleryController.h"

@interface ZoomableImageView () <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@end

@implementation ZoomableImageView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.scrollView.delegate = self;
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.scrollView addGestureRecognizer:pinchRecognizer];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kDeviceWillChangeOrientatoinNotification object:0] subscribeNext:^(NSNotification *notification) {
        CGFloat duration = [notification.object floatValue];
        [UIView animateWithDuration:duration animations:^{
            self.scrollView.zoomScale = 1.f;
        }];
    }];
}

- (void)setPhotoUrl:(NSURL *)photoUrl
{
    _photoUrl = photoUrl;
    self.imageView.alpha = 0;
    [self.imageView sd_setImageWithURL:photoUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView animateWithDuration:0.3f animations:^{
            self.imageView.alpha = 1;
        }];
    }];
}

- (void)updateConstraints
{
    [super updateConstraints];
    [self updateCustomConstraints];
}

- (void)updateCustomConstraints
{
    [self.scrollView removeConstraints:self.scrollView.constraints];
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
}


#pragma mark - Handle Gestures

static CGFloat maxZoomScale = 3.f;

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{   CGFloat zoomScale = self.scrollView.zoomScale > 1.f ? 1 : maxZoomScale;

    CGPoint center = [recognizer locationInView:self];
    if (zoomScale <= 1.f) {
        center = self.center;
    }
    
    self.scrollView.scrollEnabled = YES;
    CGSize scrollViewSize = self.bounds.size;
    
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
