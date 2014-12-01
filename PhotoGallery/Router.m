//
//  Router.m
//  PhotoGallery
//
//  Created by Gennady Berezovsky on 25.11.14.
//  Copyright (c) 2014 aiwo. All rights reserved.
//

#import "Router.h"
#import "PageViewController.h"

#define MainStoryboard [UIStoryboard storyboardWithName:@"Main" bundle:nil]

@implementation Router

+ (UIViewController *)instantiateControllerOfClass:(Class)class
{
    return [MainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass(class)];
}

+ (UIViewController *)instantiateGalleryControllerWithPhotos:(NSArray *)photos
{
    PageViewController *controller = (PageViewController *)[self instantiateControllerOfClass:[PageViewController class]];
    controller.photos = photos;
    return controller;
}

@end
