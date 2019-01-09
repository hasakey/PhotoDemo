//
//  PhotoManager.m
//  PhotoDemo
//
//  Created by 喂！ on 2019/1/8.
//  Copyright © 2019年 well. All rights reserved.
//

#define thumbImageViewWidth 55

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

#import "PhotoManager.h"

static CGFloat ScreenScale;         //缩放比例

static CGSize assetGridThumbnailSize; //预览照片的大小

static PhotoManager *manager;

@implementation PhotoManager
// 单例
+ (instancetype)shareManager
{
    manager = [[self alloc] init];
    return manager;
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:zone] init];
        manager.cachingImageManager = [[PHCachingImageManager alloc] init];
        manager.cachingImageManager.allowsCachingHighQualityImages = YES;
        // 测试发现，如果scale在plus真机上取到3.0，内存会增大特别多。故这里写死成
        ScreenScale = 2;
        if (ScreenWidth > 700)
        {
            ScreenScale = 1.5;
        }
        manager.photoPreviewMaxWidth = 6000;
    });
    return manager;
}
- (id)copyWithZone:(NSZone *)zone
{
    return manager;
}
- (id)mutableCopyWithZone:(NSZone *)zone
{
    return manager;
}

#pragma mark  获取所有的照片信息
- (void)getAllAlbumsContentImage:(BOOL)contentImage contentVideo:(BOOL)contentVideo completion:(void (^)(NSArray<AlbumModel *> *models))completion
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *albumArr = [NSMutableArray array];
        PHFetchOptions *option = [[PHFetchOptions alloc] init];
        if (!contentVideo)
        {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
        }
        if (!contentImage)
        {
            option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
        }
        if (!self.sortAscendingByModificationDate)
        {
            option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:self.sortAscendingByModificationDate]];
        }
        // 用户照片
        PHFetchResult<PHAssetCollection *> *myPhotoStreamAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil]; //用户的 iCloud 照片流
        PHFetchResult<PHCollection *> *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        PHFetchResult<PHAssetCollection *> *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
        PHFetchResult<PHAssetCollection *> *sharedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil]; //用户使用 iCloud 共享的相册
        // 智能相册
        PHFetchResult<PHAssetCollection *> *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        
        NSArray *allAlbums = @[myPhotoStreamAlbum, smartAlbums, topLevelUserCollections, syncedAlbums, sharedAlbums];
        for (PHFetchResult *fetchResult in allAlbums)
        {
            for (PHAssetCollection *collection in fetchResult)
            {
                // 有可能是PHCollectionList类的的对象，过滤掉
                if (![collection isKindOfClass:[PHAssetCollection class]])
                {
                    continue;
                }
                PHFetchResult<PHAsset *> *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:option];
                if (fetchResult.count < 1)
                {
                    continue; // 过滤无照片的相册
                }
                if ([collection.localizedTitle containsString:@"Deleted"] || [collection.localizedTitle isEqualToString:@"最近删除"]|| [collection.localizedTitle isEqualToString:@"已隐藏"]|| [collection.localizedTitle isEqualToString:@"Hidden"])
                {
                    continue;
                }
                if ([self isCameraRollAlbum:collection.localizedTitle]) // 相机胶卷
                {
                    [albumArr insertObject:[self modelWithResult:fetchResult name:collection.localizedTitle] atIndex:0];
                }
                else // 非相机胶卷
                {
                    [albumArr addObject:[self modelWithResult:fetchResult name:collection.localizedTitle]];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion && albumArr.count > 0)
            {
                completion(albumArr);
            }
        });
    });
}

#pragma mark 判断是否是相机胶卷
- (BOOL)isCameraRollAlbum:(NSString *)albumName
{
    NSString *versionStr = [[UIDevice currentDevice].systemVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (versionStr.length <= 1)
    {
        versionStr = [versionStr stringByAppendingString:@"00"];
    }
    else if (versionStr.length <= 2)
    {
        versionStr = [versionStr stringByAppendingString:@"0"];
    }
    CGFloat version = versionStr.floatValue;
    // 目前已知8.0.0 - 8.0.2系统，拍照后的图片会保存在最近添加中
    if (version >= 800 && version <= 802)
    {
        return [albumName isEqualToString:@"最近添加"] || [albumName isEqualToString:@"Recently Added"];
    }
    else
    {
        return [albumName isEqualToString:@"Camera Roll"] || [albumName isEqualToString:@"相机胶卷"] || [albumName isEqualToString:@"所有照片"] || [albumName isEqualToString:@"All Photos"];
    }
}

#pragma mark 设置相册目录model参数
- (AlbumModel *)modelWithResult:(id)result name:(NSString *)name
{
    AlbumModel *model = [[AlbumModel alloc] init];
    model.result = result; // 结果数据
    model.name = name;     // 名字
    if ([result isKindOfClass:[PHFetchResult class]])
    {
        PHFetchResult *fetchResult = (PHFetchResult *) result;
        model.count = fetchResult.count; //总数
    }
    return model;
}


/*-----------------------------------获取封面-------------------------------------------------------*/
#pragma mark 通过模型解析相册资源获取封面照片
- (PHImageRequestID)getPostImageWithAlbumModel:(AlbumModel *)model completion:(void (^)(UIImage *postImage))completion
{
    id asset = [model.result lastObject];
    if (!self.sortAscendingByModificationDate) //非时间排序
    {
        asset = [model.result firstObject];
    }
    PHImageRequestID imageRequestID = [[PhotoManager shareManager] getPhotoWithAsset:asset photoWidth:thumbImageViewWidth completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if (completion)
        {
            completion(photo);
        }
    }];
    return imageRequestID;
}

/*-----------------------------------获取照片-------------------------------------------------------*/
#pragma mark 解析相册资源
/// 无进度条
- (PHImageRequestID)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo, NSDictionary *info, BOOL isDegraded))completion
{
    return [[PhotoManager shareManager] getPhotoWithAsset:asset photoWidth:photoWidth completion:completion progressHandler:nil networkAccessAllowed:YES];
}

// 获取照片总接口
- (PHImageRequestID)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo, NSDictionary *info, BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed
{
    CGSize imageSize;
    if (photoWidth < ScreenWidth && photoWidth < _photoPreviewMaxWidth)
    {
        imageSize = assetGridThumbnailSize;
    }
    else
    {
        PHAsset *phAsset = (PHAsset *) asset;
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat) phAsset.pixelHeight;
        CGFloat pixelWidth = photoWidth * ScreenScale;
        // 超宽图片
        if (aspectRatio > 1)
        {
            pixelWidth = pixelWidth * aspectRatio;
        }
        // 超高图片
        if (aspectRatio < 0.2)
        {
            pixelWidth = pixelWidth * 0.5;
        }
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        imageSize = CGSizeMake(pixelWidth, pixelHeight);
    }
    
    [self startCachingImagesFormAssets:@[asset] targetSize:imageSize];
    return [self _requestImageForAsset:asset targetSize:imageSize completion:completion progressHandler:progressHandler networkAccessAllowed:networkAccessAllowed];
}

///  为了定制大小分开
-(PHImageRequestID)_requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize completion:(void (^)(UIImage *photo, NSDictionary *info, BOOL isDegraded))completion progressHandler:(void (^)(double progress, NSError *error, BOOL *stop, NSDictionary *info))progressHandler networkAccessAllowed:(BOOL)networkAccessAllowed
{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    option.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
    
    PHImageRequestID imageRequestID = [[PHImageManager defaultManager] requestImageForAsset:asset
                                                                                 targetSize:targetSize
                                                                                contentMode:PHImageContentModeAspectFill
                                                                                    options:option resultHandler:^(UIImage *result, NSDictionary *info) {
                                                                                        UIImage *image;
                                                                                        if (result)
                                                                                        {
                                                                                            image = result;
                                                                                        }
                                                                                        BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];  //表示已经获取了高清图
                                                                                        if (downloadFinined && result)
                                                                                        {
                                                                                            result = [self fixOrientation:result];
                                                                                            if (completion)
                                                                                            {
                                                                                                completion(result, info, [[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                                                                                            }
                                                                                        }
                                                                                        // Download image from iCloud / 从iCloud下载图片
                                                                                        if ([info objectForKey:PHImageResultIsInCloudKey] && !result && networkAccessAllowed)
                                                                                        {
                                                                                            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                                                                                            options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
                                                                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                    if (progressHandler)
                                                                                                    {
                                                                                                        progressHandler(progress, error, stop, info);
                                                                                                    }
                                                                                                });
                                                                                            };
                                                                                            options.networkAccessAllowed = YES;
                                                                                            options.resizeMode = PHImageRequestOptionsResizeModeFast;
                                                                                            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:options resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                                                                                                UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
                                                                                                resultImage = [self scaleImage:resultImage toSize:targetSize];
                                                                                                if (!resultImage)
                                                                                                {
                                                                                                    resultImage = image;
                                                                                                }
                                                                                                resultImage = [self fixOrientation:resultImage];
                                                                                                if (completion)
                                                                                                {
                                                                                                    completion(resultImage, info, NO);
                                                                                                }
                                                                                            }];
                                                                                        }
                                                                                    }];
    return imageRequestID;
}

- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size
{
    if (image.size.width > size.width)
    {
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    }
    else
    {
        return image;
    }
}

/// 修正图片转向
- (UIImage *)fixOrientation:(UIImage *)aImage
{
    if (!self.shouldFixOrientation)
    {
        return aImage;
    }
    if (aImage.imageOrientation == UIImageOrientationUp)
    {
        return aImage;
    }
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
        {
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        }
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        {
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        }
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
        {
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        }
        default:
            break;
    }
    
    switch (aImage.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
        {
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        }
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
        {
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        }
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
        {
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.height, aImage.size.width), aImage.CGImage);
            break;
        }
        default:
        {
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height), aImage.CGImage);
            break;
        }
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    
    if (ctx)
    {
        CGContextRelease(ctx);
    }
    if (cgimg)
    {
        CGImageRelease(cgimg);
    }
    return img;
}

/*-------------------------------------------------------------------------缓存-------------------------------*/
#pragma mark 缓存
-(void)startCachingImagesFormAssets:(NSArray<PHAsset *> *)assets targetSize:(CGSize)targetSize
{
    [self.cachingImageManager startCachingImagesForAssets:assets
                                               targetSize:targetSize
                                              contentMode:PHImageContentModeAspectFill
                                                  options:nil];
}

/*-----------------------------------授权-------------------------------------------------------*/
#pragma mark 授权
// 授权状态
+ (NSInteger)authorizationStatus
{
    return [PHPhotoLibrary authorizationStatus];
}


#pragma mark 弹出系统授权的窗口
- (BOOL)authorizationStatusAuthorized
{
    NSInteger status = [self.class authorizationStatus];
    if (status == 0)
    {
        /**
         * 当某些情况下AuthorizationStatus == AuthorizationStatusNotDetermined时，无法弹出系统首次使用的授权alertView，系统应用设置里亦没有相册的设置，此时将无法使用，故作以下操作，弹出系统首次使用的授权alertView
         */
        [self requestAuthorizationWithCompletion:nil];
    }
    return status == 3;
}
#pragma mark 私有方法
//AuthorizationStatus == AuthorizationStatusNotDetermined 时询问授权弹出系统授权alertView

- (void)requestAuthorizationWithCompletion:(void (^)(void))completion
{
    void (^callCompletionBlock)(void) = ^() {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion)
            {
                completion();
            }
        });
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (callCompletionBlock)
            {
                callCompletionBlock();
            }
        }];
    });
}


/*-------------------------------------------------------------------------set-------------------------------*/
#pragma mark get  set 方法
// 设置预览图的宽高
- (void)setColumnNumber:(NSInteger)columnNumber
{
    _columnNumber = columnNumber;
    CGFloat margin = 4;
    CGFloat itemWH = (ScreenWidth - 2 * margin - 4) / columnNumber - margin;
    assetGridThumbnailSize = CGSizeMake(itemWH * ScreenScale, itemWH * ScreenScale);
}


@end
