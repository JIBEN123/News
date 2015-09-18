//
//  HXMainViewController.m
//  News
//
//  Created by XXX on 15/9/17.
//  Copyright (c) 2015年 huangx. All rights reserved.
//

#import "HXMainViewController.h"
#import "HXTitleLabel.h"
#import "UIView+Extension.h"
#import "HXTableViewController.h"

@interface HXMainViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *smallScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *bigScrollView;

@property(nonatomic, strong) HXTitleLabel *oldTitleLable;
@property (nonatomic, assign) CGFloat beginOffsetX;

/** 新闻接口的数组 */
@property(nonatomic, strong) NSArray *arrayLists;
@property(nonatomic, assign, getter=isWeatherShow) BOOL weatherShow;
//@property(nonatomic, strong) SXWeatherView *weatherView;
@property(nonatomic, strong) UIImageView *tran;
//@property(nonatomic, strong) SXWeatherModel *weatherModel;

@property(nonatomic,strong)UIButton *rightItem;

@end

@implementation HXMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"头条";
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.smallScrollView.showsHorizontalScrollIndicator = NO;
    self.smallScrollView.showsVerticalScrollIndicator = NO;
    self.bigScrollView.delegate = self;
    
    [self addController];
    [self addLable];
    
    CGFloat contentX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    self.bigScrollView.contentSize = CGSizeMake(contentX, 0);
    self.bigScrollView.pagingEnabled = YES;
    
    // 添加默认控制器
    UIViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.bigScrollView.bounds;
    [self.bigScrollView addSubview:vc.view];
    HXTitleLabel *lable = [self.smallScrollView.subviews firstObject];
    lable.scale = 1.0;
    self.bigScrollView.showsHorizontalScrollIndicator = NO;
    
#warning 天气
    UIButton *rightItem = [[UIButton alloc]init];
    self.rightItem = rightItem;
//    UIWindow *win = [UIApplication sharedApplication].windows.firstObject;
//    [win addSubview:rightItem];
//    rightItem.y = 20;
    rightItem.width = 20;
    rightItem.height = 45;
    [rightItem addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
//    rightItem.x = [UIScreen mainScreen].bounds.size.width - rightItem.width;
    NSLog(@"%@",NSStringFromCGRect(rightItem.frame));
    [rightItem setImage:[UIImage imageNamed:@"top_navigation_square"] forState:UIControlStateNormal];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
//    [self sendWeatherRequest];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark -  懒加载

- (NSArray *)arrayLists
{
    if (_arrayLists == nil) {
        _arrayLists = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"NewsURLs.plist" ofType:nil]];
    }
    return _arrayLists;
}

#pragma mark - 私有方法

/** 添加子控制器 */
- (void)addController
{
    for (int i=0 ; i<self.arrayLists.count ;i++){
        
        HXTableViewController *vc1 = [[UIStoryboard storyboardWithName:@"News" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        vc1.title = self.arrayLists[i][@"title"];
        vc1.urlString = self.arrayLists[i][@"urlString"];
        [self addChildViewController:vc1];
    }
}

/** 添加标题栏 */
- (void)addLable
{
    for (int i = 0; i < 8; i++) {
        CGFloat lblW = 70;
        CGFloat lblH = 40;
        CGFloat lblY = 0;
        CGFloat lblX = i * lblW;
        HXTitleLabel *lbl1 = [[HXTitleLabel alloc]init];
        UIViewController *vc = self.childViewControllers[i];
        lbl1.text =vc.title;
        lbl1.frame = CGRectMake(lblX, lblY, lblW, lblH);
        lbl1.font = [UIFont fontWithName:@"HYQiHei" size:19];
        [self.smallScrollView addSubview:lbl1];
        lbl1.tag = i;
        lbl1.userInteractionEnabled = YES;
        
        [lbl1 addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lblClick:)]];
    }
    self.smallScrollView.contentSize = CGSizeMake(70 * 8, 0);
    
}

/** 标题栏label的点击事件 */
- (void)lblClick:(UITapGestureRecognizer *)recognizer
{
    HXTitleLabel *titlelable = (HXTitleLabel *)recognizer.view;
    self.title = titlelable.text;
    CGFloat offsetX = titlelable.tag * self.bigScrollView.frame.size.width;
    
    CGFloat offsetY = self.bigScrollView.contentOffset.y;
    CGPoint offset = CGPointMake(offsetX, offsetY);
    
    [self.bigScrollView setContentOffset:offset animated:YES];
    
    
}

#pragma mark - scrollView代理方法

/** 滚动结束后调用（代码导致） */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.bigScrollView.frame.size.width;
    
    // 滚动标题栏
    HXTitleLabel *titleLable = (HXTitleLabel *)self.smallScrollView.subviews[index];
    self.title = titleLable.text;
    CGFloat offsetx = titleLable.center.x - self.smallScrollView.frame.size.width * 0.5;
    
    CGFloat offsetMax = self.smallScrollView.contentSize.width - self.smallScrollView.frame.size.width;
    if (offsetx < 0) {
        offsetx = 0;
    }else if (offsetx > offsetMax){
        offsetx = offsetMax;
    }
    
    CGPoint offset = CGPointMake(offsetx, self.smallScrollView.contentOffset.y);
    [self.smallScrollView setContentOffset:offset animated:YES];
    // 添加控制器
    HXTableViewController *newsVc = self.childViewControllers[index];
    newsVc.index = index;
    
    [self.smallScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != index) {
            HXTitleLabel *temlabel = self.smallScrollView.subviews[idx];
            temlabel.scale = 0.0;
        }
    }];
    
    if (newsVc.view.superview) return;
    
    newsVc.view.frame = scrollView.bounds;
    [self.bigScrollView addSubview:newsVc.view];
}

/** 滚动结束（手势导致） */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/** 正在滚动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 取出绝对值 避免最左边往右拉时形变超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    NSUInteger rightIndex = leftIndex + 1;
    CGFloat scaleRight = value - leftIndex;
    CGFloat scaleLeft = 1 - scaleRight;
    HXTitleLabel *labelLeft = self.smallScrollView.subviews[leftIndex];
    labelLeft.scale = scaleLeft;
    // 考虑到最后一个板块，如果右边已经没有板块了 就不在下面赋值scale了
    if (rightIndex < self.smallScrollView.subviews.count) {
        HXTitleLabel *labelRight = self.smallScrollView.subviews[rightIndex];
        labelRight.scale = scaleRight;
    }
    
}


@end
