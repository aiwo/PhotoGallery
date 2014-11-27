//
//  ZoomableScrollView.m
//  PhotoGallery
//
//  Created by Gennady Berezovsky on 26.11.14.
//  Copyright (c) 2014 aiwo. All rights reserved.
//

#import "ZoomableScrollView.h"
#import "ZoomableImageView.h"

#ifndef kFSImageViewerZoomScale
#define kFSImageViewerZoomScale 2.5
#endif

@implementation ZoomableScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
        self.scrollEnabled = NO;
        self.pagingEnabled = NO;
        self.clipsToBounds = NO;
        self.maximumZoomScale = 3.0f;
        self.minimumZoomScale = 1.0f;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bounces = YES;
        self.alwaysBounceVertical = NO;
        self.alwaysBounceHorizontal = NO;
        self.bouncesZoom = YES;
        self.scrollsToTop = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
    }
    return self;
}

- (void)zoomRectWithCenter:(CGPoint)center{
    
    CGFloat zoomScale = self.zoomScale > 1.f ? 1 : kFSImageViewerZoomScale;
    if (zoomScale <= 1.f) {
        center = self.center;
    }
    
    self.scrollEnabled = YES;
    CGSize scrollViewSize = self.bounds.size;
    
    CGFloat w = scrollViewSize.width / zoomScale;
    CGFloat h = scrollViewSize.height / zoomScale;
    CGFloat x = center.x - (w / 2.0f);
    CGFloat y = center.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [self zoomToRect:rectToZoomTo animated:YES];
    return;
}

#pragma mark - Touches

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    
    if (touch.tapCount == 2) {
        [self zoomRectWithCenter:[[touches anyObject] locationInView:self]];
    }
}



@end
