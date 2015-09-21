//
//  JLWeatherDetailM.h
//  81 - 网易新闻
//
//  Created by dongshangxian on 15/9/20.
//  Copyright (c) 2015年 Junlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLWeatherDetailM : NSObject

/** 什么风*/
@property(nonatomic,copy)NSString *wind;
/** 农历*/
@property(nonatomic,copy)NSString *nongli;
/** 日期*/
@property(nonatomic,copy)NSString *date;
/** 天气*/
@property(nonatomic,copy)NSString *climate;
/** 温度*/
@property(nonatomic,copy)NSString *temperature;
/** 星期几*/
@property(nonatomic,copy)NSString *week;

@end
