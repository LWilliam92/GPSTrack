//
//  ChangeDateTime.m
//  GPS Camera
//
//  Created by My Mac on 4/6/19.
//  Copyright © 2019 My Mac. All rights reserved.
//

#import "ChangeDateTime.h"

@interface ChangeDateTime ()

@end

@implementation ChangeDateTime

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //FACEBOOK BANNER ADS
    self.adView = [[FBAdView alloc] initWithPlacementID:FB_BANNER_ID adSize:kFBAdSizeHeight50Banner rootViewController:self];
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


#pragma mark - FACEBOOK DELEGATE METHOD

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

#pragma mark - BUTTON CLICK EVENT

- (IBAction)onClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickDone:(id)sender {
    //SAVE AND CHANGE DATA
    [self changeTime];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CHANGE TIME

- (void)changeTime
{
    NSDate *currentDate = [self.myDatePicker date];
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    
    [dateformater setDateFormat:@"yyyy"];
    [APP_DEL.dic_time setObject:[dateformater stringFromDate:currentDate] forKey:@"currentYear"];
    
    [dateformater setDateFormat:@"MM"];
    [APP_DEL.dic_time setObject:[dateformater stringFromDate:currentDate] forKey:@"currentMonth"];
    
    [dateformater setDateFormat:@"dd"];
    [APP_DEL.dic_time setObject:[dateformater stringFromDate:currentDate] forKey:@"currentDate"];
    
    [dateformater setDateFormat:@"EEE"];
    [APP_DEL.dic_time setObject:[dateformater stringFromDate:currentDate] forKey:@"currentShortWeekName"];
    
    [dateformater setDateFormat:@"EEEE"];
    [APP_DEL.dic_time setObject:[dateformater stringFromDate:currentDate] forKey:@"currentFullWeekName"];
    
    [dateformater setDateFormat:@"MMM"];
    [APP_DEL.dic_time setObject:[dateformater stringFromDate:currentDate] forKey:@"currentShortMonthName"];
    
    [dateformater setDateFormat:@"MMMM"];
    [APP_DEL.dic_time setObject:[dateformater stringFromDate:currentDate] forKey:@"currentFullMonthName"];
    
    [dateformater setDateFormat:@"HH"];
    [APP_DEL.dic_time setObject:[dateformater stringFromDate:currentDate] forKey:@"current24Hour"];
    
    [dateformater setDateFormat:@"hh"];
    [APP_DEL.dic_time setObject:[dateformater stringFromDate:currentDate] forKey:@"current12Hour"];
    
    [dateformater setDateFormat:@"mm"];
    [APP_DEL.dic_time setObject:[dateformater stringFromDate:currentDate] forKey:@"currentMinuit"];
    
    [dateformater setDateFormat:@"ss"];
    [APP_DEL.dic_time setObject:[dateformater stringFromDate:currentDate] forKey:@"currentSecound"];
    
    [dateformater setDateFormat:@"a"];
    [APP_DEL.dic_time setObject:[dateformater stringFromDate:currentDate] forKey:@"currentFormate"];

   // NSLog(@"Dic Name : %@",APP_DEL.dic_time);
}

@end
