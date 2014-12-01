//
//  ZoomableImageViewController.h
//  PhotoGallery
//
//  Created by Gennady Berezovsky on 30.11.14.
//  Copyright (c) 2014 aiwo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomableImageViewController : UIViewController

@property (nonatomic, strong) NSURL *photoUrl;
@property (nonatomic, assign) NSInteger index;

@end
