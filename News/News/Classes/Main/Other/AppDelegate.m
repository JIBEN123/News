//
//  AppDelegate.m
//  News
//
//  Created by XXX on 15/9/14.
//  Copyright (c) 2015年 huangx. All rights reserved.
//

#import "AppDelegate.h"
#import "HXNavigationController.h"
#import "HXMainViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    HXMainViewController *mainVc = [[HXMainViewController alloc] init];
    HXNavigationController *nav = [[HXNavigationController alloc] initWithRootViewController:mainVc];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}



@end
