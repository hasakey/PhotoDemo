//
//  PhotoNav.m
//  PhotoDemo
//
//  Created by 喂！ on 2019/1/8.
//  Copyright © 2019年 well. All rights reserved.
//

#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)

#import "PhotoNav.h"

#import "PhotoVC.h"
#import "AlbumPickVC.h"


@interface PhotoNav ()

@end

@implementation PhotoNav

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBarButtonItemAppearance];
    [self setupDefaultData];
}

/// 设置默认的数据
-(void)setupDefaultData
{
//    self.photoWidth = 828.0;
//    self.photoPreviewMaxWidth = 750; // 图片预览器默认的宽度
//    // 默认准许用户选择原图和视频, 你也可以在这个方法后置为NO
//    _allowPickingOriginalPhoto = NO;
    self.allowPickingVideo = YES;
    self.allowPickingImage = YES;
//    _isHiddenEdit = NO;
//    _sortAscendingByModificationDate = YES; //时间排序
//    _networkAccessAllowed = NO;
//    _hiddenOriginalButton = YES;
}


///  设置导航条左右两边的按钮
- (void)configBarButtonItemAppearance
{
//    self.navigationBar.barTintColor = [UIColor colorWithRed:(34 / 255.0) green:(34 / 255.0) blue:(34 / 255.0) alpha:1.0];
    self.navigationBar.barTintColor = [UIColor whiteColor];
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    self.navigationBar.titleTextAttributes = textAttrs;
    
    UIBarButtonItem *barItem;
        if (@available(iOS 9.0, *)) {
            barItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[PhotoNav class]]];
        } else {
            // Fallback on earlier versions
            barItem = [UIBarButtonItem appearanceWhenContainedIn:[PhotoNav class], nil];
        }

    NSMutableDictionary *barItemTextAttrs = [NSMutableDictionary dictionary];
    barItemTextAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    barItemTextAttrs[NSFontAttributeName] =[UIFont systemFontOfSize:17];
    [barItem setTitleTextAttributes:barItemTextAttrs forState:UIControlStateNormal];
}

@end
