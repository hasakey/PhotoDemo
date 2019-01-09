//
//  LodingView.m
//  PhotoDemo
//
//  Created by 喂！ on 2019/1/8.
//  Copyright © 2019年 well. All rights reserved.
//

#import "LodingView.h"

@implementation LodingView

///  添加lodingView
+ (instancetype)showLodingViewAddedTo:(UIView *)view title:(NSString *)title
{
    LodingView *lodingView = [[LodingView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    lodingView.layer.borderWidth = 1;
    lodingView.layer.cornerRadius = 10;
    lodingView.layer.masksToBounds = YES;
    
    lodingView.backgroundColor = [UIColor colorWithRed:41 / 256.0 green:25 / 256.0 blue:10 / 256.0 alpha:1];
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    indicatorView.frame = CGRectMake(0, 0, 100, 80);
    indicatorView.color = [UIColor whiteColor];
    [indicatorView startAnimating];
    [lodingView addSubview:indicatorView];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 100, 20)];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [lodingView addSubview:titleLabel];
    [view addSubview:lodingView];
    lodingView.center = lodingView.superview.center;
    [view bringSubviewToFront:lodingView];
    return lodingView;
}

@end
