//
//  AlbumPickVC.h
//  PhotoDemo
//
//  Created by 喂！ on 2019/1/8.
//  Copyright © 2019年 well. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoManager.h"
#import "AlbumPickCell.h"
#import "LodingView.h"
#import "PhotoNav.h"
#import "PhotoVC.h"


NS_ASSUME_NONNULL_BEGIN

@interface AlbumPickVC : UIViewController<UITableViewDelegate, UITableViewDataSource>


/* 照片列表参数 */
@property (nonatomic, strong) NSArray *albumListArr;

/* tableview */
@property (nonatomic, weak) UITableView *tableView;

/* 列数 */
@property (nonatomic, assign) NSInteger columnNumber;

@property(nonatomic,copy) void(^cancelHandler)(void);  // 取消选择的属性

@property(nonatomic,copy) void(^selectedHandler)(NSArray<UIImage *> *photos, NSArray *avPlayers, NSArray *assets, NSArray<NSDictionary *> *infos, IJSPExportSourceType sourceType,NSError *error);  // 数据回调



@end

NS_ASSUME_NONNULL_END
