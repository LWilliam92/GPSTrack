//
//  DateFormateVC.h
//  GPS Camera
//
//  Created by My Mac on 4/6/19.
//  Copyright © 2019 My Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringConstants.h"

@interface DateFormateVC : BaseViewController<FBAdViewDelegate,FBInterstitialAdDelegate>

@property (nonatomic, strong) FBAdView *adView;
@property (nonatomic, strong) FBInterstitialAd *interstitialAd;

- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickDone:(id)sender;

- (IBAction)onClickDate1:(id)sender;
- (IBAction)onClickDate2:(id)sender;
- (IBAction)onClickDate3:(id)sender;

- (IBAction)onClickTime1:(id)sender;
- (IBAction)onClickTime2:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *img_1;
@property (weak, nonatomic) IBOutlet UIImageView *img_2;
@property (weak, nonatomic) IBOutlet UIImageView *img_3;
@property (weak, nonatomic) IBOutlet UIImageView *img_4;
@property (weak, nonatomic) IBOutlet UIImageView *img_5;

@end
