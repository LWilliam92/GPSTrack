//
//  CombineImageVC.h
//  SimpleWeather
//
//  Created by My Mac on 4/6/19.
//  Copyright © 2019 Ryan Nystrom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringConstants.h"

@interface CombineImageVC : BaseViewController<FBAdViewDelegate,FBInterstitialAdDelegate>

//PROPERTY OF CombineImageVC
@property (weak, nonatomic) IBOutlet UIImageView *img_snap;
@property (weak, nonatomic) IBOutlet UIButton *btn_save;
@property (weak, nonatomic) IBOutlet UIButton *btn_share;

//ACTION METHOD
- (IBAction)onClickBack:(id)sender;

//FACEBOOK ID
@property (nonatomic, strong) FBAdView *adView;
@property (nonatomic, strong) FBInterstitialAd *interstitialAd;

@property (nonatomic, strong) UIView *view_data;
@property (nonatomic, strong) UIImage *img_original;

@end
