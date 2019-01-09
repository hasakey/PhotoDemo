//
//  AlbumModel.h
//  PhotoDemo
//
//  Created by 喂！ on 2019/1/8.
//  Copyright © 2019年 well. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlbumModel : NSObject

@property (nonatomic, strong) NSString *name;  /// 相册的名字
@property (nonatomic, assign) NSInteger count; ///<  相册的个数 / 或者相机胶卷资源的个数
@property (nonatomic, strong) PHFetchResult<PHAsset *> *result;       ///< PHFetchResult<PHAsset *>,请求回来的相册

@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) NSArray *selectedModels;
@property (nonatomic, assign) NSUInteger selectedCount;

@end

NS_ASSUME_NONNULL_END
