//
//  HXPhotosDetail.m
//  News
//
//  Created by XXX on 15/9/18.
//  Copyright (c) 2015年 huangx. All rights reserved.
//

#import "HXPhotosDetail.h"

@implementation HXPhotosDetail

+ (instancetype)photoDetailWithDict:(NSDictionary *)dict
{
    HXPhotosDetail *photoDetail = [[HXPhotosDetail alloc]init];
    [photoDetail setValuesForKeysWithDictionary:dict];
    
    return photoDetail;
}

@end
