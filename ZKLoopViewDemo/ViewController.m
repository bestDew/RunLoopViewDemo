//
//  ViewController.m
//  ZKLoopViewDemo
//
//  Created by 张日奎 on 16/6/29.
//  Copyright © 2016年 张日奎. All rights reserved.
//

#import "ViewController.h"
#import "ZKLoopView.h"

@interface ViewController ()
{
    NSMutableArray *_images;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    _images = [[NSMutableArray alloc] init];
    
    for (int i = 1; i < 7; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i]];
        [_images addObject:image];
    }

    ZKLoopView *loopView = [[ZKLoopView alloc] initWithFrame:self.view.bounds];
    loopView.images = _images;
    loopView.titles = @[@"我是第一个", @"我是第二个", @"我是第三个", @"我是第四个", @"我是第五个", @"我是第六个"];
    [self.view addSubview:loopView];
    
    loopView.tapActionBlock = ^(NSInteger index) {
        NSLog(@"点击了:%ld", (long)index);
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
