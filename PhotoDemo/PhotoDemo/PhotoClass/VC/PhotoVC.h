//
//  PhotoVC.h
//  PhotoDemo
//
//  Created by 喂！ on 2019/1/8.
//  Copyright © 2019年 well. All rights reserved.
//  具体照片界面

#import <UIKit/UIKit.h>
#import "AlbumModel.h"
#import "PhotoNav.h"

NS_ASSUME_NONNULL_BEGIN

@interface PhotoVC : UIViewController

/* 列数 */
@property (nonatomic, assign) NSInteger columnNumber;

/* 数据模型 */
@property (nonatomic, strong) AlbumModel *albumModel;

@property(nonatomic,copy) void(^cancelHandler)(void);  // 取消选择的属性

@property(nonatomic,copy) void(^selectedHandler)(NSArray<UIImage *> *photos, NSArray *avPlayers, NSArray *assets, NSArray<NSDictionary *> *infos, IJSPExportSourceType sourceType,NSError *error);  // 数据回调
@end

NS_ASSUME_NONNULL_END
