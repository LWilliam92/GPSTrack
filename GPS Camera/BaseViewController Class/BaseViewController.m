//
//  BaseViewController.m
//  GIF Master
//
//  Created by My Mac on 3/9/19.
//  Copyright © 2019 My Mac. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController


//STATUS BAR COLOR WHITE
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //THIS IS FOR IHONE X SERIES SETTING - SPACE BOTTOM AND TOP
    if (SCREEN_HEIGHT == 812 || SCREEN_HEIGHT == 896) {
        self.mainBackView.frame=CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        
        UIView *view_header = [[UIView alloc]init];
        view_header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
        view_header.backgroundColor = [UIColor colorWithRed:33.0/255.0 green:33.0/255.0 blue:33.0/255.0 alpha:1.0];
        [self.view addSubview:view_header];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
