//
//  HXPhotoSet.m
//  News
//
//  Created by XXX on 15/9/18.
//  Copyright (c) 2015年 huangx. All rights reserved.
//

#import "HXPhotoSet.h"
#import "HXPhotosDetail.h"

@implementation HXPhotoSet

+ (instancetype)photoSetWith:(NSDictionary *)dict
{
    HXPhotoSet *photoSet = [[HXPhotoSet alloc]init];
    [photoSet setValuesForKeysWithDictionary:dict];
    
    NSArray *photoArray = photoSet.photos;
    NSMutableArray *temArray = [NSMutableArray arrayWithCapacity:photoArray.count];
    
    for (NSDictionary *dict in photoArray) {
        HXPhotosDetail *photoModel = [HXPhotosDetail photoDetailWithDict:dict];
        [temArray addObject:photoModel];
    }
    photoSet.photos = temArray;
    
    return photoSet;
}

@end
