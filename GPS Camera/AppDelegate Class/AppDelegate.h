//
//  AppDelegate.h
//  GPS Camera
//
//  Created by My Mac on 4/6/19.
//  Copyright © 2019 My Mac. All rights reserved.
//0° / 0°

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSMutableDictionary *dic_temprature;
@property (nonatomic, strong) NSMutableDictionary *dic_address;
@property (nonatomic, strong) NSMutableDictionary *dic_time;
@end

