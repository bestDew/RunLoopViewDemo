//
//  ZKLoopView.m
//  ZKLoopViewDemo
//
//  Created by 张日奎 on 16/6/29.
//  Copyright © 2016年 张日奎. All rights reserved.
//

#import "ZKLoopView.h"

#define W(obj) (!obj?0:(obj).frame.size.width)
#define H(obj) (!obj?0:(obj).frame.size.height)
#define Margin 10

@interface ZKLoopView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) CATransition *transition;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger index;

@end

@implementation ZKLoopView

#pragma mark -- setter/getter
- (UIImageView *)imageView
{
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTapAction:)];
        tapGesture.numberOfTapsRequired = 1;
        [_imageView addGestureRecognizer:tapGesture];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, H(self) - Margin * 5, W(self), 30)];
        _titleLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _titleLabel;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = [UIColor greenColor];
        _pageControl.numberOfPages = self.images.count;
        self.pagePosition = PositionBottomCenter;
    }
    return _pageControl;
}

- (CATransition *)transition
{
    if (!_transition) {
        
        _transition = [CATransition animation];
        _transition.type = kCATransitionPush;
        _transition.duration = 0.3;
    }
    return _transition;
}

- (void)setImages:(NSArray *)images
{
    if (images.count != 0) {
        self.imageView.image = images[0];
    }
    
    if (images.count > 1) {
        _images = images;
        
        [self insertSubview:self.pageControl aboveSubview:self.imageView];
        [self addTimer];
        [self addSwipeGesture];
    }
}

- (void)setTitles:(NSArray *)titles
{
    if (titles.count > 0) {
        
        self.titleLabel.text = titles[0];
        
        if (titles.count > 1) {
            _titles = titles;
            
            // 防止title与image不相等造成数组越界
            if (titles.count < self.images.count) {
                NSMutableArray *array = [NSMutableArray arrayWithArray:titles];
                for (NSInteger i = titles.count; i < self.images.count; i++) {
                    [array addObject:@""];
                }
                _titles = array;
            }
            
            [self.imageView addSubview:self.titleLabel];
        }
    }else{
        self.titleLabel.hidden = YES;
    }
}

- (void)setPagePosition:(PageControlPosition)pagePosition
{
    _pagePosition = pagePosition;
    
    CGSize size = [self.pageControl sizeForNumberOfPages:self.pageControl.numberOfPages];
    
    switch (pagePosition) {
        case PositionHide:
            self.pageControl.hidden = YES;
            break;
        case PositionBottomCenter:
            self.pageControl.center = CGPointMake(W(self)/2, H(self) -  Margin);
            break;
        case PositionBottomLeft:
            self.pageControl.frame = CGRectMake(Margin, H(self) - Margin * 3, size.width, size.height);
            break;
        case PositionBottomRight:
            self.pageControl.frame = CGRectMake(W(self) - Margin - size.width, H(self) - Margin * 3, size.width, size.height);
            break;
        case PositionTopCenter:
            self.pageControl.center = CGPointMake(W(self)/2, Margin);
            break;
            
        default:
            break;
    }
}

#pragma mark -- Tap Action
- (void)changeDisplayImage:(UISwipeGestureRecognizer *)sender
{
    [self removeTimer];
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        self.index ++;
        if (self.index == self.images.count) {
            self.index = 0;
        }
        self.transition.subtype = kCATransitionFromRight;
        
    }else if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        
        self.index --;
        if (self.index < 0) {
            self.index = self.images.count - 1;
        }
        self.transition.subtype = kCATransitionFromLeft;
    }
    
    [self loadData];
}

- (void)imageViewTapAction:(UITapGestureRecognizer *)sender
{
    if (self.tapActionBlock) {
        self.tapActionBlock(self.index);
    }
}

#pragma mark -- private
// 添加滑动手势
- (void)addSwipeGesture
{
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeDisplayImage:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.imageView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeDisplayImage:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.imageView addGestureRecognizer:swipeRight];
}

// 添加定时器
- (void)addTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(automaticChangeImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

// 移除定时器
- (void)removeTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

// 自动轮播图片
- (void)automaticChangeImage
{
    self.index ++;
    if (self.index == self.images.count) {
        self.index = 0;
    }
    self.transition.subtype = kCATransitionFromRight;
    
    [self loadData];
}

// 加载图片和描述
- (void)loadData
{
    self.pageControl.currentPage = self.index;
    self.imageView.image = self.images[self.index];
    self.titleLabel.text = self.titles[self.index];
    [self.imageView.layer addAnimation:self.transition forKey:@"transition"];
    if (!_timer) {
        [self addTimer];
    }
}

@end
