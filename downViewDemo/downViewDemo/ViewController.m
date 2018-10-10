//
//  ViewController.m
//  downViewDemo
//
//  Created by coolerting on 2018/10/10.
//  Copyright © 2018年 coolerting. All rights reserved.
//

#import "ViewController.h"
#import "downView.h"

@interface ViewController ()<downViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
    [self.view addGestureRecognizer:tap];
}

- (void)click:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:self.view];
    downView *view = [downView initWithPoint:point superView:self.view titleArray:@[@"测试1",@"测试2",@"测试3"] imageArray:nil];
    view.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downView:(downView *)downView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"*****%ld*****",indexPath.row);
}


@end
