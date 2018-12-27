//
//  downView.h
//  TableViewScaleHeader
//
//  Created by coolerting on 2018/8/28.
//  Copyright © 2018年 coolerting. All rights reserved.
//

#import <UIKit/UIKit.h>

@class downView;
@protocol downViewDelegate <NSObject>
@optional
/**
 点击某一行回调

 @param downView downView
 @param indexPath indexPath
 */
- (void)downView:(downView *)downView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
/**
 控件开始隐藏

 @param downView downView
 */
- (void)beginHideDownView:(downView *)downView;
@end

typedef NS_ENUM(NSUInteger, downViewType) {
    downViewLight,
    downViewDark,
};

@interface downView : UIView
/**
 代理
 */
@property (nonatomic, weak) id<downViewDelegate> delegate;

/**
 设置控件宽度
 在初始化前调用

 @param newWidth 宽度
 */
+ (void)setListWidth:(CGFloat)newWidth;
/**
 设置行高
 在初始化前调用

 @param newHeight 高度
 */
+ (void)setRowHeight:(CGFloat)newHeight;
/**
 设置标题对齐方式
 在初始化前调用

 @param alignment 对齐方式
 */
+ (void)setTextAlignment:(NSTextAlignment)alignment;
/**
 设置标题字体
 在初始化前调用

 @param newfont 字体
 */
+ (void)setTextFont:(UIFont *)newfont;
/**
 设置控件样式
 在初始化前调用

 @param newType 样式
 */
+ (void)setDownViewType:(downViewType)newType;
/**
 控件初始化方法

 @param point 弹出坐标点
 @param superview 父视图
 @param titleArray 标题数组
 @param imageArray 图标数组
 @return downView
 */
+ (instancetype)showWithPoint:(CGPoint)point superView:(nullable UIView *)superview delegate:(id)controller titleArray:(nonnull NSArray *)titleArray imageArray:(nullable NSArray *)imageArray;
@end
