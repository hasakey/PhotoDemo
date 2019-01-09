//
//  AlbumPickCell.h
//  PhotoDemo
//
//  Created by 喂！ on 2019/1/8.
//  Copyright © 2019年 well. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumModel.h"
#import "PhotoManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface AlbumPickCell : UITableViewCell

/* 缩略图 */
@property (nonatomic, weak) UIImageView *thumbImageView;
/* 标题 */
@property (nonatomic, weak) UILabel *titleLable;
/* 总是 */
@property (nonatomic, weak) UILabel *numberLabel;
/* 右边箭头 */
@property (nonatomic, weak) UIImageView *arrowImage;

/* 展示数据 */
@property (nonatomic, weak) AlbumModel *models;




@end

NS_ASSUME_NONNULL_END
