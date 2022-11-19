//
//  SettingVC.h
//  GPS Camera
//
//  Created by My Mac on 4/6/19.
//  Copyright © 2019 My Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChangeGPSData.h"
#import "AddressVC.h"
#import "DateFormateVC.h"
#import "ChangeDateTime.h"
#import "StringConstants.h"
#import "PrivacyPolicyVC.h"
#import "TermsVC.h"

@interface SettingVC : BaseViewController<FBAdViewDelegate,FBInterstitialAdDelegate>

@property (nonatomic, strong) FBAdView *adView;
@property (nonatomic, strong) FBInterstitialAd *interstitialAd;


- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickGPS:(id)sender;
- (IBAction)onClickDate:(id)sender;
- (IBAction)onClickAddress:(id)sender;
- (IBAction)onClickPrivacy:(id)sender;
- (IBAction)onClickTerms:(id)sender;
- (IBAction)changeDateFormate:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *lbl_lat;
@property (weak, nonatomic) IBOutlet UILabel *lbl_long;
@property (weak, nonatomic) IBOutlet UILabel *lbl_cels;

@property (weak, nonatomic) IBOutlet UILabel *lbl_dateFormate;
@property (weak, nonatomic) IBOutlet UILabel *lbl_timeFormate;

@property (weak, nonatomic) IBOutlet UILabel *lbl_date;
@property (weak, nonatomic) IBOutlet UILabel *lbl_time;

@property (weak, nonatomic) IBOutlet UILabel *lbl_address;

@end
