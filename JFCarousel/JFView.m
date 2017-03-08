//
//  JFView.m
//  JFCarousel
//
//  Created by JFCarousel on 2016/10/7.
//  Copyright © 2016年 JFCarousel. All rights reserved.
//

#import "JFView.h"
#import "UIImageView+WebCache.h"

@interface JFView()<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign)NSInteger playSpeed;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat imageH;
@property (nonatomic, assign) CGFloat imageW;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation JFView

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images playSpeed:(NSInteger)playSpeed
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.frame = frame;
        self.imageH = frame.size.height;
        self.imageW = frame.size.width;
        self.images = images;
        self.playSpeed = playSpeed;
        
        // 2.设置内容尺寸
        UIScrollView *scrView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrView.bounces = NO;
        [self addSubview:scrView];
        _scrollView = scrView;
        
        // view中子控件的创建和逻辑处理
        [self createCarouse];
    }
    return self;
}

// 懒加载pageControl
- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        UIPageControl *tempPager = [[UIPageControl alloc]initWithFrame:CGRectMake((self.imageW - 100) / 2,self.imageH - 30., 100, 30)];
        //[tempPager addTarget:self action:@selector(pagerChange:) forControlEvents:UIControlEventValueChanged];
        tempPager.currentPage = 0;
        tempPager.currentPageIndicatorTintColor = [UIColor redColor];
        tempPager.pageIndicatorTintColor = [UIColor grayColor];
        [self addSubview:tempPager];
        _pageControl = tempPager;
    }
    return _pageControl;
}

- (void) createCarouse
{
    CGFloat imageY = 0;
    NSInteger imageCount = self.images.count;
    //1.添加相应数量图片到scrollview中
    for (int i = 0; i < imageCount; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor blueColor];
        CGFloat imageX = i * self.imageW;
        imageView.frame = CGRectMake(imageX, imageY, self.imageW, self.imageH);
        
        // 设置图片
        NSString *name = self.images[i];
        if ([name containsString:@"http://"])
        {
            [imageView sd_setImageWithURL:[NSURL URLWithString:name] placeholderImage:[UIImage imageNamed:@"hpAdvATimeout"]];
        }
        else
        {
            imageView.image = [UIImage imageNamed:name];
        }
        
        [self.scrollView addSubview:imageView];
    }
    
    CGFloat contentW = imageCount * self.imageW;
    self.scrollView.contentSize = CGSizeMake(contentW, 0);
    
    // 3.隐藏水平滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    // 4.分页
    self.scrollView.pagingEnabled = YES;
    //    self.scrollView.delegate = self;
    
    // 5.设置pageControl的总页数
    self.pageControl.numberOfPages = self.images.count;
    
    // 6.添加定时器(每隔2秒调用一次self 的nextImage方法)
    [self addTimer];
    
    self.scrollView.delegate = self;
}

/**
 *  添加定时器
 */
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.playSpeed target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *  移除定时器
 */
- (void)removeTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)nextImage
{
    // 1.增加pageControl的页码
    int page = 0;
    if (self.pageControl.currentPage == self.images.count - 1) {
        page = 0;
    } else {
        page = self.pageControl.currentPage + 1;
    }
    
    // 2.计算scrollView滚动的位置
    CGFloat offsetX = page * self.imageW;
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - 代理方法
/**
 *  当scrollView正在滚动就会调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 根据scrollView的滚动位置决定pageControl显示第几页
    CGFloat scrollW = scrollView.frame.size.width;
    int page = (scrollView.contentOffset.x + scrollW * 0.5) / scrollW;
    self.pageControl.currentPage = page;
}

/**
 *  开始拖拽的时候调用
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 停止定时器(一旦定时器停止了,就不能再使用)
    [self removeTimer];
}

/**
 *  停止拖拽的时候调用
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    // 开启定时器
    [self addTimer];
}
@end
