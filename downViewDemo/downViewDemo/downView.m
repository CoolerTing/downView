//
//  downView.m
//  TableViewScaleHeader
//
//  Created by coolerting on 2018/8/28.
//  Copyright © 2018年 coolerting. All rights reserved.
//

#import "downView.h"
#import "Masonry.h"

@interface downView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, assign) BOOL isUp;
@end

static CGFloat width = 150;
static CGFloat height;
static CGFloat halfWidth;
static CGFloat rowHeight = 40;
static CGFloat margin = 0;
static CGFloat arrowHeight = 10;
static CGFloat arrowMargin = 5;
static NSTimeInterval animationTime = 0.15;

@implementation downView

+ (instancetype)initWithPoint:(CGPoint)point superView:(UIView *)superview titleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray
{
    downView *view = [[downView alloc]initWithPoint:point superView:superview titleArray:titleArray imageArray:imageArray];
    view.backgroundColor = UIColor.clearColor;
    [superview addSubview:view];
    [view animationShow];
    return view;
}

- (instancetype)initWithPoint:(CGPoint)point superView:(UIView *)superview titleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray
{
    self = [super init];
    if (self) {
        
        halfWidth = width / 2.0;
        height = rowHeight * titleArray.count + arrowHeight;
        _point = point;
        _titleArray = titleArray;
        _imageArray = imageArray;
        
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
            }
            else
            {
                pointY = point.y + margin;
                centerY = 0;
                _isUp = NO;
            }
        }
        else
        {
            pointY = point.y + margin;
            centerY = 0;
            _isUp = NO;
        }
        
        if (superview.frame.size.width > width) {
            if (point.x < halfWidth + arrowMargin)
            {
                self.frame = CGRectMake(arrowMargin, pointY, width, height);
                centerX = point.x;
            }
            else if (point.x >= superview.frame.size.width - halfWidth - arrowMargin)
            {
                self.frame = CGRectMake(superview.frame.size.width - width - arrowMargin, pointY, width, height);
                centerX = point.x - (superview.frame.size.width - width - arrowMargin);
            }
            else
            {
                self.frame = CGRectMake(point.x - halfWidth, pointY, width, height);
                centerX = halfWidth;
            }
        }
        else
        {
            self.frame = CGRectMake(point.x - halfWidth, pointY, width, height);
            centerX = halfWidth;
        }
        
        [self setAnchorPoint:CGPointMake(centerX / width, centerY)];
        
        CGRect rect;
        if (_isUp) {
            rect = CGRectMake(0, 0, width, height - arrowHeight);
        }
        else
        {
            rect = CGRectMake(0, arrowHeight, width, height - arrowHeight);
        }
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
        tableView.bounces = NO;
        tableView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
        tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [self addSubview:tableView];
    }
    return self;
}

- (void)animationShow
{
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:animationTime animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}

- (void)animationHide
{
    [UIView animateWithDuration:animationTime animations:^{
        self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    }completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

- (void)setAnchorPoint:(CGPoint)anchorpoint
{
    CGRect oldFrame = self.frame;
    self.layer.anchorPoint = anchorpoint;
    self.frame = oldFrame;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        UIImageView *titleImageView = [[UIImageView alloc]init];
        titleImageView.tag = 52985297;
        [cell.contentView addSubview:titleImageView];
        [titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(20);
            make.height.width.mas_equalTo(20);
        }];
        
        UILabel *title = [[UILabel alloc]init];
        title.tag = 183109381;
        title.textColor = UIColor.whiteColor;
        [cell.contentView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.mas_equalTo(0);
            if (self.imageArray == nil || self.imageArray.count == 0) {
                make.left.mas_equalTo(20);
            }
            else
            {
                make.left.mas_equalTo(titleImageView.mas_right).offset(10);
            }
        }];
        
        cell.backgroundColor = UIColor.clearColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UILabel *title = [cell.contentView viewWithTag:183109381];
    title.text = _titleArray[indexPath.row];
    
    UIImageView *titleImageView = [cell.contentView viewWithTag:52985297];
    titleImageView.image = [UIImage imageNamed:_imageArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(downView:didSelectRowAtIndexPath:)]) {
        [_delegate downView:self didSelectRowAtIndexPath:indexPath];
    }
    [self animationHide];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat pointX = 0;
    if ((_point.x > halfWidth - arrowMargin) && (_point.x <= self.superview.frame.size.width - halfWidth - arrowMargin)) {
        pointX = halfWidth;
    }
    else if ((self.superview.frame.size.width - _point.x < halfWidth + arrowMargin) && (self.superview.frame.size.width - _point.x) >= arrowMargin * 3)
    {
        pointX = width - (self.superview.frame.size.width - _point.x) + arrowMargin;
    }
    else if ((self.superview.frame.size.width - _point.x) < arrowMargin * 3)
    {
        pointX = width - arrowMargin * 2;
    }
    else if (_point.x < arrowMargin * 3)
    {
        pointX = arrowMargin * 2;
    }
    else
    {
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
    }
    else
    {
        CGContextMoveToPoint(context, pointX, 0);
        CGContextAddLineToPoint(context, pointX + arrowMargin, arrowMargin * 2);
        CGContextAddLineToPoint(context, width, arrowMargin * 2);
        CGContextAddLineToPoint(context, width, height);
        CGContextAddLineToPoint(context, 0, height);
        CGContextAddLineToPoint(context, 0, arrowMargin * 2);
        CGContextAddLineToPoint(context, pointX - arrowMargin, arrowMargin * 2);
    }
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.3 alpha:1].CGColor);
    CGContextFillPath(context);
}

- (void)dealloc
{
    NSLog(@"%@ dealloc",[self class]);
}

@end
