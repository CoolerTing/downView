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
- (void)downView:(downView *)downView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface downView : UIView
@property (nonatomic, weak) id<downViewDelegate> delegate;

+ (instancetype)initWithPoint:(CGPoint)point superView:(UIView *)superview titleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray;
@end
