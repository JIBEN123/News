//
//  HXTableViewController.m
//  News
//
//  Created by XXX on 15/9/18.
//  Copyright (c) 2015年 huangx. All rights reserved.
//

#import "HXTableViewController.h"
#import "HXDetailController.h"
#import "HXPhotoSetController.h"
#import "HXNewsCell.h"
#import "HXNewsModel.h"
#import "HXNetworkTool.h"
#import "MJRefresh.h"

#import "MJExtension.h"

@interface HXTableViewController ()

@property(nonatomic, strong) NSMutableArray *arrayList;
@property(nonatomic, assign) BOOL update;

@end

@implementation HXTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.update = YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

//- (void)setUrlString:(NSString *)urlString
//{
//    _urlString = urlString;
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    NSLog(@"bbbb");
    if (self.update == YES) {
        [self.tableView.header beginRefreshing];
        self.update = NO;
    }
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"contentStart" object:nil]];
}

#pragma mark - /************************* 刷新数据 ***************************/
// ------下拉刷新
- (void)loadData
{
    // http://c.m.163.com//nc/article/headline/T1348647853363/0-30.html
    NSString *allUrlstring = [NSString stringWithFormat:@"/nc/article/%@/0-20.html",self.urlString];
    [self loadDataForType:1 withURL:allUrlstring];
}

// ------上拉加载
- (void)loadMoreData
{
    NSString *allUrlstring = [NSString stringWithFormat:@"/nc/article/%@/%ld-20.html",self.urlString,(self.arrayList.count - self.arrayList.count%10)];
    
    [self loadDataForType:2 withURL:allUrlstring];
}

// ------公共方法
- (void)loadDataForType:(int)type withURL:(NSString *)allUrlstring
{
    [[[HXNetworkTool sharedNetworkTools]GET:allUrlstring parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        NSLog(@"%@",allUrlstring);
        NSString *key = [responseObject.keyEnumerator nextObject];
        
        NSArray *temArray = responseObject[key];
        
        NSMutableArray *arrayM = [HXNewsModel objectArrayWithKeyValuesArray:temArray];
        
        if (type == 1) {
            self.arrayList = arrayM;
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
        }else if(type == 2){
            [self.arrayList addObjectsFromArray:arrayM];
            
            [self.tableView.footer endRefreshing];
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }] resume];
}// ------想把这里改成block来着

#pragma mark - /************************* tbv数据源方法 ***************************/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXNewsModel *newsModel = self.arrayList[indexPath.row];
    
    NSString *ID = [HXNewsCell idForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        ID = @"NewsCell";
    }
    
    HXNewsCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.NewsModel = newsModel;
    
    return cell;
    
}

#pragma mark - /************************* tbv代理方法 ***************************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HXNewsModel *newsModel = self.arrayList[indexPath.row];
    
    CGFloat rowHeight = [HXNewsCell heightForRow:newsModel];
    
    if ((indexPath.row%20 == 0)&&(indexPath.row != 0)) {
        rowHeight = 80;
    }
    
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 刚选中又马上取消选中，格子不变色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor yellowColor];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[HXDetailController class]]) {
        
        NSInteger x = self.tableView.indexPathForSelectedRow.row;
        HXDetailController *dc = segue.destinationViewController;
        dc.newsModel = self.arrayList[x];
        dc.index = self.index;
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }else{
        NSInteger x = self.tableView.indexPathForSelectedRow.row;
        HXPhotoSetController *pc = segue.destinationViewController;
        pc.newsModel = self.arrayList[x];
    }

}


@end
