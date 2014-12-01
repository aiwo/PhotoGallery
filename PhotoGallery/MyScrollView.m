//
//  MyScrollView.m
//  PhotoGallery
//
//  Created by Gennady Berezovsky on 30.11.14.
//  Copyright (c) 2014 aiwo. All rights reserved.
//

#import "MyScrollView.h"

@implementation MyScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated
{
    [super setContentOffset:contentOffset animated:animated];
    NSLog(@"Content offset animated: %f", contentOffset.x);
}

- (void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    NSLog(@"Content offset: %f", contentOffset.x);
}

- (void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
    NSLog(@"Content size: %f/%f", contentSize.width, contentSize.height);
}

@end
