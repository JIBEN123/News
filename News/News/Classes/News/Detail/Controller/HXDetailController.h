//
//  HXDetailController.h
//  News
//
//  Created by XXX on 15/9/18.
//  Copyright (c) 2015年 huangx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXNewsModel;

@interface HXDetailController : UIViewController

@property(nonatomic,strong) HXNewsModel *newsModel;

@property (nonatomic,assign) NSInteger index;

@end
