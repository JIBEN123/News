//
//  JLWeatherBgM.h
//  81 - 网易新闻
//
//  Created by dongshangxian on 15/9/20.
//  Copyright (c) 2015年 Junlin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JLWeatherBgM : NSObject

@property(nonatomic,copy)NSString *nbg1;

/** 这个是真正的背景图*/
@property(nonatomic,copy)NSString *nbg2;

@property(nonatomic,copy)NSString *aqi;

@property(nonatomic,copy)NSString *pm2_5;

@end
