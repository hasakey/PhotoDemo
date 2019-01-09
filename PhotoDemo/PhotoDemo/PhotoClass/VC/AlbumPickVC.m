//
//  AlbumPickVC.m
//  PhotoDemo
//
//  Created by 喂！ on 2019/1/8.
//  Copyright © 2019年 well. All rights reserved.
//


#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

#define IJSGiPhoneX (ScreenWidth == 375.f && ScreenHeight == 812.f ? YES : NO)
#define IJSGStatusBarAndNavigationBarHeight (IJSGiPhoneX ? 88.f : 64.f)
#define IJSGTabbarSafeBottomMargin (IJSGiPhoneX ? 34.f : 0.f)



#define albumCellHright 60
#import "AlbumPickVC.h"

static NSString *const cellID = @"cellID";

@interface AlbumPickVC ()

@end

@implementation AlbumPickVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavUI];
    [self getImageData];
}

- (void)setupNavUI
{
    self.title = @"照片";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleAndDisMiss)];
    
    
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftButton.frame = CGRectMake(0, 0, 25, 25);
//    [leftButton setImage:[IJSFImageGet loadImageWithBundle:@"JSPhotoSDK" subFile:nil grandson:nil imageName:@"jiahao@2x" imageType:@"png"] forState:UIControlStateNormal];
//    [leftButton addTarget:self action:@selector(addAppAlbum:) forControlEvents:UIControlEventTouchUpInside];
//    leftButton.contentMode = UIViewContentModeScaleAspectFit;
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}


#pragma mark Tableview 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albumListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumPickCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.models = self.albumListArr[indexPath.row];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoVC *vc = [[PhotoVC alloc] init];
    vc.columnNumber = self.columnNumber; // 传递列数计算展示图的大小
    AlbumModel *model = self.albumListArr[indexPath.row];
    vc.albumModel = model;
    vc.selectedHandler = self.selectedHandler;
    vc.cancelHandler = self.cancelHandler;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark 获取相册列表
- (void)getImageData
{
    if ([[PhotoManager shareManager] authorizationStatusAuthorized])
    {
        __weak typeof(self) weakSelf = self;
        
//        UIView *loadView =  [LodingView showLodingViewAddedTo:self.view title:@"处理中"];
        PhotoNav *vc = (PhotoNav *)self.navigationController;
        [[PhotoManager shareManager] getAllAlbumsContentImage:vc.allowPickingImage contentVideo:vc.allowPickingVideo completion:^(NSArray<AlbumModel *> *models) {
            weakSelf.albumListArr = models;
//            [loadView removeFromSuperview];
            if (!weakSelf.tableView)
            {
                [weakSelf setupTableViewUI];
            }
            [weakSelf.tableView reloadData];
        }];
        [PhotoManager shareManager].columnNumber = 4;
    }
}
- (void)setupTableViewUI
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, IJSGStatusBarAndNavigationBarHeight, ScreenWidth, ScreenHeight - IJSGStatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
    tableView.rowHeight = albumCellHright;
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [UIView new];
    [tableView registerClass:[AlbumPickCell class] forCellReuseIdentifier:cellID];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView = tableView;
}
#pragma mark 点击方法
- (void)cancleAndDisMiss
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.cancelHandler)
        {
            self.cancelHandler();
        }
    }];
}

#pragma mark 懒加载
- (NSArray *)albumListArr
{
    if (!_albumListArr)
    {
        _albumListArr = [NSArray array];
    }
    return _albumListArr;
}

@end
