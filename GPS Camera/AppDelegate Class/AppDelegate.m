//
//  AppDelegate.m
//  GPS Camera
//
//  Created by My Mac on 4/6/19.
//  Copyright © 2019 My Mac. All rights reserved.
//

#import "AppDelegate.h"
@import IQKeyboardManagerSwift;
@import FBAudienceNetwork;
@import UIKit;


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {


    [FBAudienceNetworkAds initializeWithSettings:nil completionHandler:nil];

    // Pass user's consent after acquiring it. For sample app purposes, this is set to YES.
    [FBAdSettings setAdvertiserTrackingEnabled:YES];

    [[IQKeyboardManager shared] setEnable:YES];
    //THIS IS DEFAULT FORMATE OF DATE
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"dateFormate"] == nil) {
        [[NSUserDefaults standardUserDefaults]setObject:@"dd-mm-yyyy" forKey:@"dateFormate"];
        [[NSUserDefaults standardUserDefaults]setObject:@"12Hour" forKey:@"timeFormate"];
    }
    
    //FACEBOOK ADS DISPLAY SETTING 
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"adscount"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSInteger appcount=[[NSUserDefaults standardUserDefaults] integerForKey:@"appcount"];
    appcount++;
    [[NSUserDefaults standardUserDefaults] setInteger:appcount forKey:@"appcount"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    return YES;
}

#pragma mark - Facebook


- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
