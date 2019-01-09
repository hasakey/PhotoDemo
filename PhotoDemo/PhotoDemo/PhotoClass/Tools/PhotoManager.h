//
//  PhotoManager.h
//  PhotoDemo
//
//  Created by 喂！ on 2019/1/8.
//  Copyright © 2019年 well. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "AlbumModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface PhotoManager : NSObject
/**
 *  单例
 */
+ (instancetype)shareManager;

/**
 缓存属性
 */
@property (nonatomic, strong) PHCachingImageManager *cachingImageManager;

/* Default is 600px / 默认600像素宽 */
@property (nonatomic, assign) CGFloat photoPreviewMaxWidth;

/* 修正方向 */
@property (nonatomic, assign) BOOL shouldFixOrientation;

/* 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个 */
@property (nonatomic, assign) BOOL sortAscendingByModificationDate;

/*-----------------------------------解析PHAsset返回为具体的图片数据缩-- 略图-------------------------------------------------------*/
// 通过模型解析相册资源获取封面照片
- (PHImageRequestID)getPostImageWithAlbumModel:(AlbumModel *)model completion:(void (^)(UIImage *postImage))completion;

/**
 *  所有的相册,包括用户创建,系统创建等,得到PHAsset对象放到IJSAlbumModel中
 */
- (void)getAllAlbumsContentImage:(BOOL)contentImage contentVideo:(BOOL)contentVideo completion:(void (^)(NSArray<AlbumModel *> *models))completion;

/**
 *  处理特殊情况的无法授权窗口
 */
- (BOOL)authorizationStatusAuthorized;


/*-----------------------------------属性-------------------------------------------------------*/
/* 默认4列, TZPhotoPickerController中的照片collectionView 可以计算获得显示图片的尺寸*/
@property (nonatomic, assign) NSInteger columnNumber;

@end

NS_ASSUME_NONNULL_END
