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
#import "JLWeatherView.h"
#import "JLWeatherDetailVC.h"
#import "HXHTTPManager.h"
#import "JLWeatherModel.h"
#import "MJExtension.h"




@interface HXMainViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *smallScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *bigScrollView;

@property(nonatomic, strong) HXTitleLabel *oldTitleLable;
@property (nonatomic, assign) CGFloat beginOffsetX;


/** 新闻接口的数组 */
@property(nonatomic, strong) NSArray *arrayLists;
@property(nonatomic, assign, getter=isWeatherShow) BOOL weatherShow;
@property(nonatomic, strong) JLWeatherView *weatherView;
@property(nonatomic, strong) UIImageView *tran;
@property(nonatomic, strong) JLWeatherModel *weatherModel;

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
    
#pragma mark - 天气
//    UIButton *rightItem = [[UIButton alloc]init];
//    self.rightItem = rightItem;
//    rightItem.width = 20;
//    rightItem.height = 45;
//    [rightItem addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
//    NSLog(@"%@",NSStringFromCGRect(rightItem.frame));
//    [rightItem setImage:[UIImage imageNamed:@"top_navigation_square"] forState:UIControlStateNormal];
//
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightItem];
    
    UIButton *rightItem = [[UIButton alloc]init];
    self.rightItem = rightItem;
    UIWindow *win = [UIApplication sharedApplication].windows.firstObject;
    [win addSubview:rightItem];
    rightItem.y = 20;
    rightItem.width = 45;
    rightItem.height = 45;
    [rightItem addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    rightItem.x = [UIScreen mainScreen].bounds.size.width - rightItem.width;
    NSLog(@"%@",NSStringFromCGRect(rightItem.frame));
    [rightItem setImage:[UIImage imageNamed:@"top_navigation_square"] forState:UIControlStateNormal];
    
    [self sendWeatherRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.rightItem) {
        
        self.rightItem.hidden = NO;
        [self.rightItem setImage:[UIImage imageNamed:@"top_navigation_square"] forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.rightItem.hidden = YES;
}

- (void)rightItemClick{
    
    if (self.isWeatherShow) {
        
        
        self.weatherView.hidden = YES;
        self.tran.hidden = YES;
        [UIView animateWithDuration:0.1 animations:^{
            self.rightItem.transform = CGAffineTransformRotate(self.rightItem.transform, M_1_PI * 5);
            
        } completion:^(BOOL finished) {
            [self.rightItem setImage:[UIImage imageNamed:@"top_navigation_square"] forState:UIControlStateNormal];
        }];
    }else{
        
        [self.rightItem setImage:[UIImage imageNamed:@"223"] forState:UIControlStateNormal];
        self.weatherView.hidden = NO;
        self.tran.hidden = NO;
        [self.weatherView addAnimate];
        [UIView animateWithDuration:0.2 animations:^{
            self.rightItem.transform = CGAffineTransformRotate(self.rightItem.transform, -M_1_PI * 6);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                self.rightItem.transform = CGAffineTransformRotate(self.rightItem.transform, M_1_PI );
            }];
        }];
    }
    self.weatherShow = !self.isWeatherShow;
}

- (void)sendWeatherRequest
{
    NSString *url = @"http://c.3g.163.com/nc/weather/5bm%2F6KW%2FfOahguaelw%3D%3D.html";
    [[HXHTTPManager manager]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        JLWeatherModel *weatherModel = [JLWeatherModel objectWithKeyValues:responseObject];
        self.weatherModel = weatherModel;
        [self addWeather];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure %@",error);
    }];
}

- (void)addWeather{
    JLWeatherView *weatherView = [JLWeatherView view];
    weatherView.weatherModel = self.weatherModel;
    self.weatherView = weatherView;
    weatherView.alpha = 0.9;
    UIWindow *win = [UIApplication sharedApplication].windows.firstObject;
    [win addSubview:weatherView];
    
    UIImageView *tran = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"224"]];
    self.tran = tran;
    tran.width = 7;
    tran.height = 7;
    tran.y = 57;
    tran.x = [UIScreen mainScreen].bounds.size.width - 33;
    [win addSubview:tran];
    
    weatherView.frame = [UIScreen mainScreen].bounds;
    weatherView.y = 64;
    weatherView.height -= 64;
    self.weatherView.hidden = YES;
    self.tran.hidden = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushWeatherDetail) name:@"pushWeatherDetail" object:nil];
}

// 点击天气图片会跳转到相应的详情页面
- (void)pushWeatherDetail
{
    self.weatherShow = NO;
    JLWeatherDetailVC *wdvc = [[JLWeatherDetailVC alloc]init];
    wdvc.weatherModel = self.weatherModel;
    [self.navigationController pushViewController:wdvc animated:YES];
    [UIView animateWithDuration:0.1 animations:^{
        self.weatherView.alpha = 0;
    } completion:^(BOOL finished) {
        self.weatherView.alpha = 0.9;
        self.weatherView.hidden = YES;
        self.tran.hidden = YES;
    }];
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
