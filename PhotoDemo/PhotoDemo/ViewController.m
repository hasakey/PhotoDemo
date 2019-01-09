//
//  ViewController.m
//  PhotoDemo
//
//  Created by 喂！ on 2019/1/8.
//  Copyright © 2019年 well. All rights reserved.
//

#import "ViewController.h"
#import "PhotoNav.h"
#import "AlbumPickVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton new];
    [button setTitle:@"选取照片" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
}

-(void)selectPhoto
{
    AlbumPickVC *albumPickVC = [AlbumPickVC new];
    PhotoNav *Nav = [[PhotoNav alloc] initWithRootViewController:albumPickVC];
    [self presentViewController:Nav animated:YES completion:nil];
}

@end
