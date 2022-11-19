//
//  ChangeGPSData.m
//  GPS Camera
//
//  Created by My Mac on 4/6/19.
//  Copyright © 2019 My Mac. All rights reserved.
//

#import "ChangeGPSData.h"

@interface ChangeGPSData ()

@end

@implementation ChangeGPSData

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //TEXT IN TEXTFIELD
    self.txt_latitude.text = [APP_DEL.dic_temprature objectForKey:@"latitude"];
    self.txt_longitude.text = [APP_DEL.dic_temprature objectForKey:@"longitude"];
    self.txt_celsius.text = [APP_DEL.dic_temprature objectForKey:@"temprature"];
    
    //CHANGE TEXTFIELD UI
    [self chnageTextField:self.txt_latitude];
    [self chnageTextField:self.txt_longitude];
    [self chnageTextField:self.txt_celsius];
    
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


#pragma mark - CHANGE TEXT FIELD CORNER RADIUS

- (void)chnageTextField:(UITextField *)textField
{
    textField.layer.borderWidth = 1.0;
    textField.layer.borderColor = [UIColor whiteColor].CGColor;
    textField.layer.cornerRadius = textField.frame.size.height/2;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, textField.frame.size.height)];
    
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
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
    [APP_DEL.dic_temprature setObject:self.txt_latitude.text forKey:@"latitude"];
    [APP_DEL.dic_temprature setObject:self.txt_longitude.text forKey:@"longitude"];
    [APP_DEL.dic_temprature setObject:self.txt_celsius.text forKey:@"temprature"];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
