//
//  LodingView.h
//  PhotoDemo
//
//  Created by 喂！ on 2019/1/8.
//  Copyright © 2019年 well. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LodingView : UIView

/**
 * 加载 ,最后 需要remove 这个view
 */
+ (instancetype)showLodingViewAddedTo:(UIView *)view title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
