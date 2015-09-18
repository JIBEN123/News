//
//  HXNewsModel.m
//  News
//
//  Created by XXX on 15/9/18.
//  Copyright (c) 2015年 huangx. All rights reserved.
//

#import "HXNewsModel.h"

@implementation HXNewsModel

+ (instancetype)newsModelWithDict:(NSDictionary *)dict
{
    HXNewsModel *model = [[self alloc]init];
    
    [model setValuesForKeysWithDictionary:dict];
    
    return model;
}

@end
