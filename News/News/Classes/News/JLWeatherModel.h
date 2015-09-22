//
//  JLWeatherModel.h
//  81 - 网易新闻
//
//  Created by dongshangxian on 15/9/20.
//  Copyright (c) 2015年 Junlin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JLWeatherDetailM.h"
#import "JLWeatherBgM.h"

@interface JLWeatherModel : NSObject

/** 数组里面装的是JLWeatherDetailM模型*/
@property(nonatomic,strong)NSArray *detailArray;
@property(nonatomic,strong)JLWeatherBgM *pm2d5;
@property(nonatomic,copy)NSString *dt;
@property(nonatomic,assign)int rt_temperature;

@end
