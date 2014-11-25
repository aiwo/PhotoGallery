//
//  UIFont+MeduzaFonts.h
//  PhotoGallery
//
//  Created by Gennady Berezovsky on 25.11.14.
//  Copyright (c) 2014 aiwo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MeduzaFontStyle)
{
    MeduzaFontStyleRegular40pt
};

@interface UIFont (MeduzaFonts)

+ (UIFont *)fontWithStyle:(MeduzaFontStyle)fontStyle;

@end
