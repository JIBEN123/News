//
//  HXNavigationController.m
//  News
//
//  Created by XXX on 15/9/17.
//  Copyright (c) 2015年 huangx. All rights reserved.
//

#import "HXNavigationController.h"

@interface HXNavigationController ()

@end

@implementation HXNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationBar.barTintColor = [UIColor colorWithRed:0 / 255.0 green:160 / 255.0 blue:239 / 255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
