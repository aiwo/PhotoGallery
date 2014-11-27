//
//  ZoomableImageView.m
//  PhotoGallery
//
//  Created by Gennady Berezovsky on 26.11.14.
//  Copyright (c) 2014 aiwo. All rights reserved.
//

#import "ZoomableImageView.h"
#import "ZoomableScrollView.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface ZoomableImageView ()

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@end

@implementation ZoomableImageView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (id)initWithPhotoUrl:(NSURL *)photoUrl
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setPhotoUrl:(NSURL *)photoUrl
{
    _photoUrl = photoUrl;
    [self.imageView sd_setImageWithURL:photoUrl completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.scrollView.mas_right);
            make.bottom.equalTo(self.scrollView.mas_bottom);
            make.left.equalTo(self.scrollView.mas_left);
            make.top.equalTo(self.scrollView.mas_top);
        }];
    }];
}

- (void)updateConstraints
{
    [super updateConstraints];
    [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.scrollView.mas_right);
        make.bottom.equalTo(self.scrollView.mas_bottom);
        make.left.equalTo(self.scrollView.mas_left);
        make.top.equalTo(self.scrollView.mas_top);
    }];
}

@end
