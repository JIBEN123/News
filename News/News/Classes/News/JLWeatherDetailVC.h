//
//  JLWeatherDetailVC.h
//  81 - 网易新闻
//
//  Created by dongshangxian on 15/9/20.
//  Copyright (c) 2015年 Junlin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JLWeatherModel;

@interface JLWeatherDetailVC : UIViewController

@property(nonatomic,strong)JLWeatherModel *weatherModel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@end
