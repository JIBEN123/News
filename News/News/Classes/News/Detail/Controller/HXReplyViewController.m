//
//  HXReplyViewController.m
//  News
//
//  Created by XXX on 15/9/18.
//  Copyright (c) 2015年 huangx. All rights reserved.
//

#import "HXReplyViewController.h"
#import "HXReplyCell.h"
#import "HXReplyModel.h"
#import "HXReplyHeader.h"

@interface HXReplyViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation HXReplyViewController

static NSString *ID = @"replyCell";

#pragma mark - ******************** 返回按钮
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - ******************** tbv数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.replys.count == 0) {
        return 1;
    }
    
    if (section == 0) {
        return self.replys.count;
    }else{
        return self.replys.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HXReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[HXReplyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    if (self.replys.count == 0) {
        UITableViewCell *cell2 = [[UITableViewCell alloc]init];
        cell2.textLabel.text = @"     暂无跟帖数据";
        return cell2;
    }else{
        HXReplyModel *model = self.replys[indexPath.row];
        cell.replyModel = model;
    }
    
    return cell;
}
/** 返回一个view来当tbv的header */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [HXReplyHeader replyViewFirst];
    }else{
        return [HXReplyHeader replyViewLast];
    }
}

/** 通过提前计算来返回行高 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.replys.count == 0){
        return 40;
    }else{
        HXReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        HXReplyModel *model = self.replys[indexPath.row];
        
        cell.replyModel = model;
        
        [cell layoutIfNeeded];
        CGSize size = [cell.sayLabel systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        return cell.sayLabel.frame.origin.y + size.height + 10;
    }
}

/** 预估行高，这个方法可以减少上面方法的调用次数，提高性能 */
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 130;
}


@end
