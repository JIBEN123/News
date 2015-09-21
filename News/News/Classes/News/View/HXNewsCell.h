//
//  HXNewsCell.h
//  News
//
//  Created by XXX on 15/9/18.
//  Copyright (c) 2015年 huangx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXNewsModel;

@interface HXNewsCell : UITableViewCell

@property(nonatomic,strong) HXNewsModel *NewsModel;
/**
 *  类方法返回可重用的id
 */
+ (NSString *)idForRow:(HXNewsModel *)NewsModel;

/**
 *  类方法返回行高
 */
+ (CGFloat)heightForRow:(HXNewsModel *)NewsModel;

@end
