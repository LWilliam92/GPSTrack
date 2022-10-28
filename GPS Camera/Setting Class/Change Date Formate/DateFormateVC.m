//
//  DateFormateVC.m
//  GPS Camera
//
//  Created by My Mac on 4/6/19.
//  Copyright © 2019 My Mac. All rights reserved.
//

#import "DateFormateVC.h"

@interface DateFormateVC ()
{
    NSString *dateFormate;
    NSString *timeFormate;
}
@end

@implementation DateFormateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //CURRUENT DATE FORMATE AND TIME GET
    dateFormate = [[NSUserDefaults standardUserDefaults]objectForKey:@"dateFormate"];
    timeFormate = [[NSUserDefaults standardUserDefaults]objectForKey:@"timeFormate"];

    
    //SELECT CURRENT DATE FORMATE AND TIME
    self.img_1.image = nil;
    self.img_2.image = nil;
    self.img_3.image = nil;
    self.img_4.image = nil;
    self.img_5.image = nil;
    
    if ([dateFormate isEqualToString:@"dd-mm-yyyy"]) {
        self.img_1.image = [UIImage imageNamed:@"checkmark"];
    }
    else if ([dateFormate isEqualToString:@"mm-dd-yyyy"]) {
        self.img_2.image = [UIImage imageNamed:@"checkmark"];
    }
    else if ([dateFormate isEqualToString:@"yyyy-mm-dd"]) {
        self.img_3.image = [UIImage imageNamed:@"checkmark"];
    }
    
    if ([timeFormate isEqualToString:@"12Hour"]) {
        self.img_4.image = [UIImage imageNamed:@"checkmark"];
    }
    else if ([timeFormate isEqualToString:@"24Hour"]) {
        self.img_5.image = [UIImage imageNamed:@"checkmark"];
    }
    
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
    [[NSUserDefaults standardUserDefaults]setObject:dateFormate forKey:@"dateFormate"];
    [[NSUserDefaults standardUserDefaults]setObject:timeFormate forKey:@"timeFormate"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CHANGE DATE FORMATE BUTTON CLICK EVENT

- (IBAction)onClickDate1:(id)sender {
    dateFormate = @"dd-mm-yyyy";
    self.img_1.image = [UIImage imageNamed:@"checkmark"];
    self.img_2.image = nil;
    self.img_3.image = nil;
}

- (IBAction)onClickDate2:(id)sender {
    dateFormate = @"mm-dd-yyyy";
    self.img_2.image = [UIImage imageNamed:@"checkmark"];
    self.img_1.image = nil;
    self.img_3.image = nil;

}

- (IBAction)onClickDate3:(id)sender {
    dateFormate = @"yyyy-mm-dd";
    self.img_3.image = [UIImage imageNamed:@"checkmark"];
    self.img_1.image = nil;
    self.img_2.image = nil;

}

- (IBAction)onClickTime1:(id)sender{
    timeFormate = @"12Hour";
    self.img_4.image = [UIImage imageNamed:@"checkmark"];
    self.img_5.image = nil;

}

- (IBAction)onClickTime2:(id)sender{
    timeFormate = @"24Hour";
    self.img_5.image = [UIImage imageNamed:@"checkmark"];
    self.img_4.image = nil;
}





@end
