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
     //相当于在StatusResult.m中实现了+objectClassInArray方法
    
     //Student中的ID属性对应着字典中的id
     //....
    [JLWeatherModel setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"detailArray" : @"广西|桂林"
                 };
    }];
    // 相当于在Student.m中实现了+replacedKeyFromPropertyName方法
    
    [HXPhotoSet setupObjectClassInArray:^NSDictionary *{
        return @{
                 @"photos":@"HXPhotosDetail"
                 };
    }];
}
@end
