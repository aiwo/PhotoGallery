//
//  NavigationController.m
//  PhotoGallery
//
//  Created by Gennady Berezovsky on 25.11.14.
//  Copyright (c) 2014 aiwo. All rights reserved.
//

#import "NavigationController.h"

@implementation NavigationController

- (void)awakeFromNib
{
    [self setNavigationBarHidden:YES];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
