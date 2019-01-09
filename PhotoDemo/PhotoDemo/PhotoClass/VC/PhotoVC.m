//
//  PhotoVC.m
//  PhotoDemo
//
//  Created by 喂！ on 2019/1/8.
//  Copyright © 2019年 well. All rights reserved.
//

#import "PhotoVC.h"

@interface PhotoVC ()

@end

@implementation PhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    [self setupBarUI];
}

/*-----------------------------------UI-------------------------------------------------------*/
#pragma mark - UI
// 创建底部的工具视图
- (void)setupBarUI{
    // 右边
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleSelectImage)];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];

    // 左按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(popAction)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:dict forState:UIControlStateNormal];

}

#pragma mark 取消
- (void)cancleSelectImage
{
    __weak typeof (self) weakSelf = self;
    [self dismissViewControllerAnimated:YES completion:^{
        if (weakSelf.cancelHandler)
        {
            weakSelf.cancelHandler();
        }
    }];
}


#pragma mark 清空数据--返回上一级界面
- (void)popAction
{
//    IJSImagePickerController *vc = (IJSImagePickerController *) self.navigationController;
//    vc.selectedModels = nil;
    [self.navigationController popViewControllerAnimated:YES];
}


@end
