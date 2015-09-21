//
//  HXDetailModel.h
//  News
//
//  Created by XXX on 15/9/18.
//  Copyright (c) 2015年 huangx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXDetailModel : NSObject

/** 新闻标题 */
@property (nonatomic, copy) NSString *title;
/** 新闻发布时间 */
@property (nonatomic, copy) NSString *ptime;
/** 新闻内容 */
@property (nonatomic, copy) NSString *body;
/** 新闻配图(希望这个数组中以后放HMNewsDetailImg模型) */
@property (nonatomic, strong) NSArray *img;

+ (instancetype)detailWithDict:(NSDictionary *)dict;

@end
