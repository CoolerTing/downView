//
//  downView.m
//  TableViewScaleHeader
//
//  Created by coolerting on 2018/8/28.
//  Copyright © 2018年 coolerting. All rights reserved.
//

#import "downView.h"

@interface downView()<UITableViewDelegate,UITableViewDataSource>
/**
 弹出坐标点
 */
@property (nonatomic, assign) CGPoint point;
/**
 背景遮罩
 */
@property (nonatomic, strong) UIView *backView;
/**
 标题数组
 */
@property (nonatomic, strong) NSArray *titleArray;
/**
 图标数组
 */
@property (nonatomic, strong) NSArray *imageArray;
/**
 是否为向上弹出   是：YES  不是：NO
 */
@property (nonatomic, assign) BOOL isUp;
@end
/*
 控件宽度
 */
static CGFloat width = 150;
/*
 控件高度
 */
static CGFloat height;
/*
 控件一半高度
 */
static CGFloat halfWidth;
/*
 行高
 */
static CGFloat rowHeight = 40;
/*
 间隔
 */
static CGFloat margin = 0;
/*
 箭头高度
 */
static CGFloat arrowHeight = 10;
/*
 箭头距边距最短距离
 */
static CGFloat arrowMargin = 5;
/*
 动画时间
 */
static NSTimeInterval animationTime = 0.15;
/*
 标题对齐方式
 */
static NSTextAlignment textAlignment = NSTextAlignmentLeft;
/*
 标题字体
 */
static UIFont *font;
/*
 控件样式
 */
static downViewType type = downViewDark;

@implementation downView

+ (void)setListWidth:(CGFloat)newWidth {
    width = newWidth;
}

+ (void)setRowHeight:(CGFloat)newHeight {
    rowHeight = newHeight;
}

+ (void)setTextAlignment:(NSTextAlignment)alignment {
    textAlignment = alignment;
}

+ (void)setTextFont:(UIFont *)newfont {
    font = newfont;
}

+ (void)setDownViewType:(downViewType)newType {
    type = newType;
}

+ (instancetype)showWithPoint:(CGPoint)point superView:(UIView *)superview delegate:(id)controller titleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray {
    if (superview == nil) {
        superview = UIApplication.sharedApplication.delegate.window;
    }
    downView *view = [[downView alloc]initWithPoint:point superView:superview titleArray:titleArray imageArray:imageArray];
    view.backgroundColor = UIColor.clearColor;
    view.delegate = controller;
    [superview addSubview:view];
    [view animationShow];
    return view;
}

- (instancetype)initWithPoint:(CGPoint)point superView:(UIView *)superview titleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray {
    self = [super init];
    if (self) {
        
        halfWidth = width / 2.0;
        height = rowHeight * titleArray.count + arrowHeight;
        _point = point;
        _titleArray = titleArray;
        _imageArray = imageArray;
        font = font ? : [UIFont systemFontOfSize:UIFont.systemFontSize];
        
        UIView *backView = [[UIView alloc]init];
        backView.frame = superview.bounds;
        [superview insertSubview:backView belowSubview:self];
        _backView = backView;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(animationHide)];
        [backView addGestureRecognizer:tap];
        
        CGFloat centerX = 0;
        CGFloat centerY = 0;
        CGFloat pointY = 0;
        
        if (superview.frame.size.height > height) {
            if (superview.frame.size.height - (point.y + margin) < height) {
                pointY = point.y - margin - height;
                centerY = 1;
                _isUp = YES;
            } else {
                pointY = point.y + margin;
                centerY = 0;
                _isUp = NO;
            }
        } else {
            pointY = point.y + margin;
            centerY = 0;
            _isUp = NO;
        }
        
        if (superview.frame.size.width > width) {
            if (point.x < halfWidth + arrowMargin) {
                self.frame = CGRectMake(arrowMargin, pointY, width, height);
                centerX = point.x;
            } else if (point.x >= superview.frame.size.width - halfWidth - arrowMargin) {
                self.frame = CGRectMake(superview.frame.size.width - width - arrowMargin, pointY, width, height);
                centerX = point.x - (superview.frame.size.width - width - arrowMargin);
            } else {
                self.frame = CGRectMake(point.x - halfWidth, pointY, width, height);
                centerX = halfWidth;
            }
        } else {
            self.frame = CGRectMake(point.x - halfWidth, pointY, width, height);
            centerX = halfWidth;
        }
        
        [self setAnchorPoint:CGPointMake(centerX / width, centerY)];
        
        CGRect rect;
        if (_isUp) {
            rect = CGRectMake(0, 0, width, height - arrowHeight);
        } else {
            rect = CGRectMake(0, arrowHeight, width, height - arrowHeight);
        }
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.bounces = NO;
        if (type == downViewDark) {
            tableView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
            tableView.separatorColor = UIColor.whiteColor;
        } else {
            tableView.backgroundColor = UIColor.whiteColor;
            tableView.separatorColor = [UIColor colorWithWhite:0.3 alpha:1];
        }
        tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [self addSubview:tableView];
    }
    return self;
}

- (void)animationShow {
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:animationTime animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)animationHide {
    if ([_delegate respondsToSelector:@selector(beginHideDownView:)]) {
        [_delegate beginHideDownView:self];
    }
    [UIView animateWithDuration:animationTime animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    }completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)setAnchorPoint:(CGPoint)anchorpoint {
    CGRect oldFrame = self.frame;
    self.layer.anchorPoint = anchorpoint;
    self.frame = oldFrame;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        UIImageView *titleImageView = [[UIImageView alloc]init];
        titleImageView.tag = 52985297;
        titleImageView.frame = CGRectMake(0, 0, 20, 20);
        titleImageView.center = CGPointMake(30, rowHeight / 2);
        [cell.contentView addSubview:titleImageView];
        
        UILabel *title = [[UILabel alloc]init];
        title.tag = 183109381;
        if (type == downViewDark) {
            title.textColor = UIColor.whiteColor;
        } else {
            title.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        }
        title.textAlignment = textAlignment;
        title.font = font;
        if (self.imageArray == nil || self.imageArray.count == 0) {
            title.frame = CGRectMake(20, 0, width - 40, rowHeight);
        } else {
            title.frame = CGRectMake(10 + CGRectGetMaxX(titleImageView.frame), 0, width - (20 + 30 + CGRectGetWidth(titleImageView.frame)), rowHeight);
        }
        [cell.contentView addSubview:title];
        
        cell.backgroundColor = UIColor.clearColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UILabel *title = [cell.contentView viewWithTag:183109381];
    title.text = _titleArray[indexPath.row];
    
    if (_imageArray) {
        UIImage *image;
        if (indexPath.row >= _imageArray.count) {
            image = nil;
        } else {
            image = [UIImage imageNamed:_imageArray[indexPath.row]];
        }
        UIImageView *titleImageView = [cell.contentView viewWithTag:52985297];
        titleImageView.image = image;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_delegate && [_delegate respondsToSelector:@selector(downView:didSelectRowAtIndexPath:)]) {
        [_delegate downView:self didSelectRowAtIndexPath:indexPath];
    }
    [self animationHide];
}

- (void)drawRect:(CGRect)rect {
    CGFloat pointX = 0;
    if ((_point.x > halfWidth - arrowMargin) && (_point.x <= self.superview.frame.size.width - halfWidth - arrowMargin)) {
        pointX = halfWidth;
    } else if ((self.superview.frame.size.width - _point.x < halfWidth + arrowMargin) && (self.superview.frame.size.width - _point.x) >= arrowMargin * 3) {
        pointX = width - (self.superview.frame.size.width - _point.x) + arrowMargin;
    } else if ((self.superview.frame.size.width - _point.x) < arrowMargin * 3) {
        pointX = width - arrowMargin * 2;
    } else if (_point.x < arrowMargin * 3) {
        pointX = arrowMargin * 2;
    } else {
        pointX = _point.x - arrowMargin;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (_isUp) {
        CGContextMoveToPoint(context, pointX, height);
        CGContextAddLineToPoint(context, pointX + arrowMargin, height - arrowMargin * 2);
        CGContextAddLineToPoint(context, width, height - arrowMargin * 2);
        CGContextAddLineToPoint(context, width, 0);
        CGContextAddLineToPoint(context, 0, 0);
        CGContextAddLineToPoint(context, 0, height - arrowMargin * 2);
        CGContextAddLineToPoint(context, pointX - arrowMargin, height - arrowMargin * 2);
    } else {
        CGContextMoveToPoint(context, pointX, 0);
        CGContextAddLineToPoint(context, pointX + arrowMargin, arrowMargin * 2);
        CGContextAddLineToPoint(context, width, arrowMargin * 2);
        CGContextAddLineToPoint(context, width, height);
        CGContextAddLineToPoint(context, 0, height);
        CGContextAddLineToPoint(context, 0, arrowMargin * 2);
        CGContextAddLineToPoint(context, pointX - arrowMargin, arrowMargin * 2);
    }
    CGContextClosePath(context);
    if (type == downViewDark) {
        CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.3 alpha:1].CGColor);
    } else {
        CGContextSetFillColorWithColor(context, UIColor.whiteColor.CGColor);
    }
    CGContextFillPath(context);
}

@end
