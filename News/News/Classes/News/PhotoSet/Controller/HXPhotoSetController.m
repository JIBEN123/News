//
//  HXPhotoSetController.m
//  News
//
//  Created by XXX on 15/9/18.
//  Copyright (c) 2015年 huangx. All rights reserved.
//

#import "HXPhotoSetController.h"
#import "HXPhotoSet.h"
#import "HXReplyModel.h"
#import "HXNewsModel.h"
#import "HXHTTPManager.h"
#import "UIView+Extension.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "HXPhotosDetail.h"
#import "HXReplyViewController.h"

@interface HXPhotoSetController ()

@property (weak, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentText;
@property (weak, nonatomic) IBOutlet UIButton *replayBtn;

@property(nonatomic,strong) HXPhotoSet *photoSet;

@property(nonatomic,strong) HXReplyModel *replyModel;
@property(nonatomic,strong) NSMutableArray *replyModels;

@property(nonatomic,strong) NSArray *news;

@end

@implementation HXPhotoSetController

- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (NSMutableArray *)replyModels
{
    if (_replyModels == nil) {
        _replyModels = [NSMutableArray array];
    }
    return _replyModels;
}

- (NSArray *)news
{
    if (_news == nil) {
        _news = [NSArray array];
        _news = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NewsURLs.plist" ofType:nil]];
    }
    return _replyModels;
}

#pragma mark - ******************** 首次加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor yellowColor];
    
    // 取出关键字
    NSString *one  = self.newsModel.photosetID;
    NSString *two = [one substringFromIndex:4];
    NSArray *three = [two componentsSeparatedByString:@"|"];
    
    CGFloat count =  [self.newsModel.replyCount intValue];
    NSString *displayCount;
    if (count > 10000) {
        displayCount = [NSString stringWithFormat:@"%.1f万跟帖",count/10000];
    }else{
        displayCount = [NSString stringWithFormat:@"%.0f跟帖",count];
    }
    
    [self.replayBtn setTitle:displayCount forState:UIControlStateNormal];
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/photo/api/set/%@/%@.json",[three firstObject],[three lastObject]];
    // 发请求
    [self sendRequestWithUrl:url];
    
    NSString *url2 = @"http://comment.api.163.com/api/json/post/list/new/hot/photoview_bbs/PHOT1ODB009654GK/0/10/10/2/2";
    [self sendRequestWithUrl2:url2];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - ******************** 发请求
- (void)sendRequestWithUrl:(NSString *)url
{
    [[HXHTTPManager manager]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        HXPhotoSet *photoSet = [HXPhotoSet objectWithKeyValues:responseObject];
        self.photoSet = photoSet;
        
        [self setLabelWithModel:photoSet];
        
        [self setImageViewWithModel:photoSet];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure %@",error);
    }];
    
}

/** 提前把评论的请求也发出去 得到评论的信息 */
- (void)sendRequestWithUrl2:(NSString *)url
{
    [[HXHTTPManager manager]GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        NSArray *dictarray = responseObject[@"hotPosts"];
        //        NSLog(@"%ld",dictarray.count);
        for (int i = 0; i < dictarray.count; i++) {
            NSDictionary *dict = dictarray[i][@"1"];
            HXReplyModel *replyModel = [[HXReplyModel alloc]init];
            replyModel.name = dict[@"n"];
            if (replyModel.name == nil) {
                replyModel.name = @"火星网友";
            }
            replyModel.address = dict[@"f"];
            replyModel.say = dict[@"b"];
            replyModel.suppose = dict[@"v"];
            [self.replyModels addObject:replyModel];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failure %@",error);
    }];
}

#pragma mark - ******************** 设置页面的文字和图片

/** 设置页面文字 */
- (void)setLabelWithModel:(HXPhotoSet *)photoSet
{
    self.titleLabel.text = photoSet.setname;
    
    // 设置新闻内容
    [self setContentWithIndex:0];
    
    NSString *countNum = [NSString stringWithFormat:@"1/%ld",photoSet.photos.count];
    self.countLabel.attributedText = [self attrStringWithCount:countNum currentCount:1];
}

/** 设置页面imgView */
- (void)setImageViewWithModel:(HXPhotoSet *)photoSet
{
    NSUInteger count = self.photoSet.photos.count;
    
    for (int i = 0; i < count; i++) {
        UIImageView *photoImgView = [[UIImageView alloc]init];
        photoImgView.height = self.photoScrollView.height;
        photoImgView.width = self.photoScrollView.width;
        photoImgView.y = -64;
        photoImgView.x = i * photoImgView.width;
        
        // 图片的显示格式为合适大小
        photoImgView.contentMode= UIViewContentModeCenter;
        photoImgView.contentMode= UIViewContentModeScaleAspectFit;
        
        [self.photoScrollView addSubview:photoImgView];
        
    }
    
    // 因为scroll尼玛默认就有两个子控件好吧
    [self setImgWithIndex:0];
    
    self.photoScrollView.contentOffset = CGPointZero;
    self.photoScrollView.contentSize = CGSizeMake(self.photoScrollView.width * count, 0);
    self.photoScrollView.showsHorizontalScrollIndicator = NO;
    self.photoScrollView.showsVerticalScrollIndicator = NO;
    self.photoScrollView.pagingEnabled = YES;
}

/** 滚动完毕时调用 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = self.photoScrollView.contentOffset.x / self.photoScrollView.width;
    
    // 添加图片
    [self setImgWithIndex:index];
    
    // 添加文字
    NSString *countNum = [NSString stringWithFormat:@"%d/%ld",index+1,self.photoSet.photos.count];
    
    
    self.countLabel.attributedText = [self attrStringWithCount:countNum currentCount:index + 1];
    
    // 添加内容
    [self setContentWithIndex:index];
}

- (NSAttributedString *)attrStringWithCount:(NSString *)countNum currentCount:(int)index
{
    NSUInteger len = 1;
    if (index > 9) {
        len = 2;
    }
    NSRange range = NSMakeRange(0, len);
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:countNum];
    [attrStr setAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18]} range:range];
    
    return attrStr;
}

/** 添加内容 */
- (void)setContentWithIndex:(int)index
{
    HXPhotosDetail *photo = self.photoSet.photos[index];
    NSString *content = photo.note;
    NSString *contentTitle = photo.imgtitle;
    if (content.length != 0) {
        self.contentText.text = content;
    }else{
        self.contentText.text = contentTitle;
    }
}

/** 懒加载添加图片！这里才是设置图片 */
- (void)setImgWithIndex:(int)i
{
    
    UIImageView *photoImgView = nil;
    if (i == 0) {
        photoImgView = self.photoScrollView.subviews[i+2];
    }else{
        photoImgView = self.photoScrollView.subviews[i];
    }
    
    NSURL *purl = [NSURL URLWithString:[self.photoSet.photos[i] imgurl]];
    
    // 如果这个相框里还没有照片才添加
    if (photoImgView.image == nil) {
        [photoImgView sd_setImageWithURL:purl placeholderImage:[UIImage imageNamed:@"photoview_image_default_white"]];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    HXReplyViewController *replyvc = segue.destinationViewController;
    replyvc.replys = self.replyModels;
}




@end
