//
//  HXReplyHeader.m
//  News
//
//  Created by XXX on 15/9/18.
//  Copyright (c) 2015年 huangx. All rights reserved.
//

#import "HXReplyHeader.h"

@implementation HXReplyHeader

/** 类方法快速返回热门跟帖的view */
+ (instancetype)replyViewFirst
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HXReplyHeader" owner:nil options:nil];
    return [array firstObject];
}

/** 类方法快速返回最新跟帖的view */
+ (instancetype)replyViewLast
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"HXReplyHeader" owner:nil options:nil];
    return [array lastObject];
}

@end
