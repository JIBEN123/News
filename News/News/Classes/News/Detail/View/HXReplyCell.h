//
//  HXReplyCell.h
//  News
//
//  Created by XXX on 15/9/18.
//  Copyright (c) 2015年 huangx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXReplyModel;

@interface HXReplyCell : UITableViewCell

@property(nonatomic,strong) HXReplyModel *replyModel;
/** 用户的发言 */
@property (weak, nonatomic) IBOutlet UILabel *sayLabel;

@end
