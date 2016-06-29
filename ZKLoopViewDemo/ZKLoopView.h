//
//  ZKLoopView.h
//  ZKLoopViewDemo
//
//  Created by 张日奎 on 16/6/29.
//  Copyright © 2016年 张日奎. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    PositionHide,           // 隐藏
    PositionTopCenter,      // 上中
    PositionBottomLeft,     // 下左
    PositionBottomCenter,   // 下中 默认值
    PositionBottomRight     // 下右
    
} PageControlPosition;

@interface ZKLoopView : UIView

@property (nonatomic, strong) NSArray *images; // 本地图片数组
@property (nonatomic, strong) NSArray *titles; // 图片描述数组
@property(nonatomic, copy) void (^tapActionBlock)(NSInteger index); // 点击事件Block回调
@property (nonatomic, strong) UILabel *titleLabel; // 图片描述Label

/**
 *  设置分页控件位置，默认为PositionBottomCenter
 *  只有一张图片时，pageControl隐藏
 */
@property (nonatomic, assign) PageControlPosition pagePosition;

@end
