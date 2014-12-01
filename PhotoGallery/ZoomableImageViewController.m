//
//  ZoomableImageViewController.m
//  PhotoGallery
//
//  Created by Gennady Berezovsky on 30.11.14.
//  Copyright (c) 2014 aiwo. All rights reserved.
//

#import "ZoomableImageViewController.h"
#import "ZoomableImageView.h"

@interface ZoomableImageViewController ()

@end

@implementation ZoomableImageViewController

- (void)setPhotoUrl:(NSURL *)photoUrl
{
    _photoUrl = photoUrl;
    [(ZoomableImageView *)self.view setPhotoUrl:photoUrl];
}

@end
