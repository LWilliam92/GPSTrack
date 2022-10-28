//  StringConstants.h
//  Diet Achiever
//  Created by great summit an on 5/24/16.
//  Copyright © 2016 summit. All rights reserved


#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "BaseViewController.h"
#import "AppDelegate.h"

@import FBAudienceNetwork;

//SCREEN CONDTION
#define    SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define    SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width

#define    WIDTH_TRIANGLE   SCREEN_WIDTH/320
#define    HEIGHT_TRIANGLE  SCREEN_HEIGHT/568

#define    APP_DEL  ((AppDelegate *)[[UIApplication sharedApplication]delegate])

//THIS IS FACEBOOK ADS ID
#define FB_INSERTIAL_ID           @"IMG_16_9_APP_INSTALL#414547849378995_414548322712281"
#define FB_BANNER_ID              @"IMG_16_9_APP_INSTALL#414547849378995_414549009378879"
