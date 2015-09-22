//
//  MJExtensionConfig.m
//  81 - 网易新闻
//
//  Created by dongshangxian on 15/8/10.
//  Copyright (c) 2015年 ShangxianDante. All rights reserved.
//

#import "MJExtensionConfig.h"
#import "MJExtension.h"
#import "JLWeatherModel.h"
#import "HXPhotoSet.h"

@implementation MJExtensionConfig

+ (void)load
{

    [JLWeatherModel setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"detailArray" : @"JLWeatherDetailM"
                 };
    }];
    
    [JLWeatherModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"detailArray" : @"广西|桂林"
                 };
    }];
    
    [HXPhotoSet setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"photos":@"HXPhotosDetail"
                 };
    }];
}
@end
