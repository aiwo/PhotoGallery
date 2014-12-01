//
//  ViewController.m
//  PhotoGallery
//
//  Created by Gennady Berezovsky on 25.11.14.
//  Copyright (c) 2014 aiwo. All rights reserved.
//

#import "ViewController.h"
#import "Router.h"
#import "UIFont+MeduzaFonts.h"
#import "PageViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openGalleryButtonPressed:(id)sender {
    NSArray *photos = @[@"http://sakha.gov.ru/sites/default/files/story/img/2013_02/99/_%D0%97%D0%98%D0%9C%D0%9E%D0%99.jpg",
                        @"http://friends.kz/uploads/posts/2011-10/1320076437_animals_006.jpg",
                        @"http://www.motorfoto.ru/0/6/98/69809.jpg",
                        @"http://img.kudika.ro/comunitate/photos/7/4/3/6873471.jpg",
                        @"http://friends.kz/uploads/posts/2011-10/1320076623_animals_022.jpg",
                        @"http://img.xcitefun.net/users/2011/06/255682,xcitefun-a-cute-hq-23.jpg",
                        @"http://www.aegmaha.ee/files/200807/images/large/vJxzYlmhSsa.jpg"];
    
    UIViewController *controller = [Router instantiateGalleryControllerWithPhotos:photos];
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

@end
