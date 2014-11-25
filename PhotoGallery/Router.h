//
//  Router.h
//  PhotoGallery
//
//  Created by Gennady Berezovsky on 25.11.14.
//  Copyright (c) 2014 aiwo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Router : NSObject

+ (UIViewController *)instantiateGalleryControllerWithPhotos:(NSArray *)photos;

@end
