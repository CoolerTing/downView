//
//  ViewController.m
//  downViewDemo
//
//  Created by coolerting on 2018/10/10.
//  Copyright © 2018年 coolerting. All rights reserved.
//

#import "ViewController.h"
#import "downView.h"

@interface ViewController ()<downViewDelegate, UIGestureRecognizerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = UIColor.whiteColor;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (void)click:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self.view];
    
    [downView setDownViewType:downViewDark];
    [downView setTextFont:[UIFont systemFontOfSize:20]];
    [downView setRowHeight:45];
    [downView setListWidth:UIScreen.mainScreen.bounds.size.width - 10];
    [downView setTextAlignment:NSTextAlignmentCenter];
    
    [downView showWithPoint:point superView:self.view delegate:self titleArray:@[@"测试1",@"测试2",@"测试3"] imageArray:@[@"more", @"more"]];
}

- (void)downView:(downView *)downView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"*****%ld*****",indexPath.row);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //防止手势冲突
    if (touch.view == self.view) {
        return YES;
    }
    return NO;
}


@end
