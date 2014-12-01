//
//  UIFont+MeduzaFonts.m
//  PhotoGallery
//
//  Created by Gennady Berezovsky on 25.11.14.
//  Copyright (c) 2014 aiwo. All rights reserved.
//

#import "UIFont+MeduzaFonts.h"

@implementation UIFont (MeduzaFonts)

+ (UIFont *)fontWithStyle:(MeduzaFontStyle)style
{
    static NSDictionary *map;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = @{@(MeduzaFontStyleRegular40pt)   :   [UIFont fontWithName:@"PFRegalTextPro-RegularB" size:20.]
                };
    });
    
    return map[@(style)];
}

@end
