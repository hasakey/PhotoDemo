//
//  AlbumPickCell.m
//  PhotoDemo
//
//  Created by 喂！ on 2019/1/8.
//  Copyright © 2019年 well. All rights reserved.
//

// 相册界面的常量
#define thumbImageMarginTop 2
#define thumbImageMarginleft 2
#define thumbImageViewWidth 55
#define thumbImageViewHeight 55
#define titleFontSize 17
#define titleMarginLeft 10
#define titleMarginTop 20
#define titleHeight 20
#define numberWidth 50
#define numberHeight 20
#define arrowImageWidth 10
#define arrowImageHeight 10
#define arrowImageMarginTop 20
#define arrowImageMarginRight 20
#define ScreenW [[UIScreen mainScreen] bounds].size.width

#import "AlbumPickCell.h"

@implementation AlbumPickCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setupSubviews];
    }
    return self;
}

#pragma mark 私有方法
- (void)setupSubviews
{
    // 缩略图
    UIImageView *thumbImageView = [UIImageView new];
    thumbImageView.backgroundColor = [UIColor whiteColor];
    thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
    thumbImageView.clipsToBounds = YES;
    [self.contentView addSubview:thumbImageView];
    self.thumbImageView = thumbImageView;
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:titleLabel];
    self.titleLable = titleLabel;
    // 数据
    UILabel *numberLabel = [UILabel new];
    [self.contentView addSubview:numberLabel];
    self.numberLabel = numberLabel;
    // 右边箭头
    UIImageView *arrowImage = [UIImageView new];
    arrowImage.image = [UIImage imageNamed:@"rightArrow"];
    [self.contentView addSubview:arrowImage];
    self.arrowImage = arrowImage;
    self.arrowImage.autoresizesSubviews = NO;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(2, 0, ScreenW - 4, 0.3)];
    line.backgroundColor = [UIColor colorWithRed:203 / 255.0 green:203 / 255.0 blue:203 / 255.0 alpha:1];
    [self.contentView addSubview:line];
}
- (void)layoutSubviews
{
    self.thumbImageView.frame = CGRectMake(thumbImageMarginTop, thumbImageMarginleft, thumbImageViewWidth, thumbImageViewHeight);
    NSDictionary *attrs = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:titleFontSize]};
    CGSize size = [self.titleLable.text sizeWithAttributes:attrs];
    [self.titleLable setFrame:CGRectMake(thumbImageMarginleft + thumbImageViewWidth + titleMarginLeft, titleMarginTop, size.width, titleHeight)];
    self.numberLabel.frame = CGRectMake(self.titleLable.frame.origin.x + self.titleLable.frame.size.width + titleMarginLeft, titleMarginTop, numberWidth, numberHeight);
    self.arrowImage.frame = CGRectMake(self.frame.size.width - arrowImageMarginRight, arrowImageMarginTop, arrowImageWidth, arrowImageHeight);
}

#pragma mark se方法数据

// 设置参数
- (void)setModels:(AlbumModel *)models
{
    _models = models;
    _titleLable.text = models.name;
    _numberLabel.text = [NSString stringWithFormat:@"(%ld)", (long) models.count];
    // 请求封面的照片
    __weak typeof(self) weakSelf = self;
    [[PhotoManager shareManager] getPostImageWithAlbumModel:models completion:^(UIImage *postImage) {
        weakSelf.thumbImageView.image = postImage;
    }];
}




@end
