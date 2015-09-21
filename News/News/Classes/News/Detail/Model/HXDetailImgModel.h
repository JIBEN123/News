//
//  HXDetailImgModel.h
//  News
//
//  Created by XXX on 15/9/18.
//  Copyright (c) 2015年 huangx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXDetailImgModel : NSObject

@property (nonatomic, copy) NSString *src;
/** 图片尺寸 */
@property (nonatomic, copy) NSString *pixel;
/** 图片所处的位置 */
@property (nonatomic, copy) NSString *ref;

+ (instancetype)detailImgWithDict:(NSDictionary *)dict;

@end
