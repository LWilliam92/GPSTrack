//
//  SettingVC.m
//  GPS Camera
//
//  Created by My Mac on 4/6/19.
//  Copyright © 2019 My Mac. All rights reserved.
//

#import "SettingVC.h"

@interface SettingVC ()

@end

@implementation SettingVC




- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    //FACEBOOK BANNER ADS
    self.adView = [[FBAdView alloc] initWithPlacementID:FB_BANNER_ID  adSize:kFBAdSizeHeight50Banner rootViewController:self];
    self.adView.delegate = self;
    [self.adView loadAd];
    self.adView.hidden = YES;
    
    
    //FACEBOOK INTERSTITIAL ADS
    NSInteger count=[[NSUserDefaults standardUserDefaults] integerForKey:@"adscount"];
    if(count%3==0)
    {
        [self createAndLoadInterstitial];
        count++;
        [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"adscount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        count++;
        [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"adscount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    self.adView.hidden = NO;
    self.adView.frame = CGRectMake(0, self.mainBackView.frame.size.height-50, self.mainBackView.frame.size.width, 50);
}


- (void)viewWillAppear:(BOOL)animated
{
    //CHANGE DATA WHEN BACK
    
    self.lbl_lat.text = [APP_DEL.dic_temprature  objectForKey:@"latitude"];
    self.lbl_long.text = [APP_DEL.dic_temprature  objectForKey:@"longitude"];
    self.lbl_cels.text = [NSString stringWithFormat:@"%@°C",[APP_DEL.dic_temprature  objectForKey:@"temprature"]];

    self.lbl_dateFormate.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"dateFormate"];
    self.lbl_timeFormate.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"timeFormate"];
    
    
    NSString *dateFormate = [[NSUserDefaults standardUserDefaults]objectForKey:@"dateFormate"];
    NSString *timeFormate = [[NSUserDefaults standardUserDefaults]objectForKey:@"timeFormate"];

    
    NSString *str_date;
    NSString *str_time;

     if ([dateFormate isEqualToString:@"dd-mm-yyyy"]) {
        str_date = [NSString stringWithFormat:@"%@/%@/%@",[APP_DEL.dic_time objectForKey:@"currentDate"],[APP_DEL.dic_time objectForKey:@"currentMonth"],[APP_DEL.dic_time objectForKey:@"currentYear"]];
     }
     else if ([dateFormate isEqualToString:@"mm-dd-yyyy"]) {
         str_date = [NSString stringWithFormat:@"%@/%@/%@",[APP_DEL.dic_time objectForKey:@"currentMonth"],[APP_DEL.dic_time objectForKey:@"currentDate"],[APP_DEL.dic_time objectForKey:@"currentYear"]];
     }
     else if ([dateFormate isEqualToString:@"yyyy-mm-dd"]) {
         str_date = [NSString stringWithFormat:@"%@/%@/%@",[APP_DEL.dic_time objectForKey:@"currentYear"],[APP_DEL.dic_time objectForKey:@"currentMonth"],[APP_DEL.dic_time objectForKey:@"currentDate"]];
     }
    
     if ([timeFormate isEqualToString:@"12Hour"]) {
         str_time = [NSString stringWithFormat:@"%@:%@ %@",[APP_DEL.dic_time objectForKey:@"current12Hour"],[APP_DEL.dic_time objectForKey:@"currentMinuit"],[APP_DEL.dic_time objectForKey:@"currentFormate"]];
     }
     else if ([timeFormate isEqualToString:@"24Hour"]) {
         str_time = [NSString stringWithFormat:@"%@:%@ %@",[APP_DEL.dic_time objectForKey:@"current24Hour"],[APP_DEL.dic_time objectForKey:@"currentMinuit"],[APP_DEL.dic_time objectForKey:@"currentFormate"]];
     }

    self.lbl_date.text = str_date;
    self.lbl_time.text = str_time;
    
    NSString *str_address = [NSString stringWithFormat:@"%@, %@, %@, %@, %@ - %@",[APP_DEL.dic_address objectForKey:@"Name"],[APP_DEL.dic_address objectForKey:@"SubLocality"],[APP_DEL.dic_address objectForKey:@"City"],[APP_DEL.dic_address objectForKey:@"State"],[APP_DEL.dic_address objectForKey:@"Country"],[APP_DEL.dic_address objectForKey:@"ZIP"]];

    self.lbl_address.text = str_address;
}

#pragma mark - BUTTON CLICK EVENT

- (IBAction)onClickGPS:(id)sender {
    ChangeGPSData *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeGPSData"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (IBAction)onClickDate:(id)sender {
    ChangeDateTime *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ChangeDateTime"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (IBAction)onClickAddress:(id)sender {
    AddressVC *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AddressVC"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (IBAction)changeDateFormate:(id)sender {
    DateFormateVC *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DateFormateVC"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

- (IBAction)onClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - FACEBOOK ADS DELEGATE METHOD

- (void)createAndLoadInterstitial {
    self.interstitialAd = [[FBInterstitialAd alloc] initWithPlacementID:FB_INSERTIAL_ID];
    self.interstitialAd.delegate = self;
    [self.interstitialAd loadAd];
}

- (void)interstitialAdDidLoad:(FBInterstitialAd *)interstitialAd
{
    [interstitialAd showAdFromRootViewController:self];
}

- (void)adViewDidLoad:(FBAdView *)adView
{
    [self showBanner];
}

- (void)showBanner
{
    if (self.adView && self.adView.isAdValid) {
        [self.mainBackView addSubview:self.adView];
    }
}

@end
