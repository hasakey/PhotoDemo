//
//  PhotoNav.h
//  PhotoDemo
//
//  Created by 喂！ on 2019/1/8.
//  Copyright © 2019年 well. All rights reserved.
//  导航控制器

#import <UIKit/UIKit.h>

/*
 *  导航栏控制器，通过改变该控制器的一些属性来达到你想要的效果,开放的外部接口
 */
typedef NS_ENUM(NSUInteger, IJSPExportSourceType) {
    IJSPImageType,
    IJSPVideoType,
    IJSPVoiceType,
};

NS_ASSUME_NONNULL_BEGIN

@interface PhotoNav : UINavigationController

/* 默认为YES，如果设置为NO,用户将不能选择发送图片 */
@property (nonatomic, assign) BOOL allowPickingImage;

/*默认为YES，如果设置为NO,用户将不能选择视频 */
@property (nonatomic, assign) BOOL allowPickingVideo;

@end

NS_ASSUME_NONNULL_END
