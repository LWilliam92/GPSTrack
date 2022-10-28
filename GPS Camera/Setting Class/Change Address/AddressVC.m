//
//  AddressVC.m
//  GPS Camera
//
//  Created by My Mac on 4/6/19.
//  Copyright © 2019 My Mac. All rights reserved.
//

#import "AddressVC.h"

@interface AddressVC ()

@end

@implementation AddressVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.txt_name.text = [APP_DEL.dic_address objectForKey:@"Name"];
    self.txt_locality.text = [APP_DEL.dic_address objectForKey:@"SubLocality"];
    self.txt_city.text = [APP_DEL.dic_address objectForKey:@"City"];
    self.txt_state.text = [APP_DEL.dic_address objectForKey:@"State"];
    self.txt_country.text = [APP_DEL.dic_address objectForKey:@"Country"];
    self.txt_zip.text = [APP_DEL.dic_address objectForKey:@"ZIP"];
    
    [self chnageTextField:self.txt_name];
    [self chnageTextField:self.txt_locality];
    [self chnageTextField:self.txt_city];
    [self chnageTextField:self.txt_state];
    [self chnageTextField:self.txt_country];
    [self chnageTextField:self.txt_zip];
    
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
    NSLog(@"Ad was loaded and ready to be displayed");
    [self showBanner];
}

- (void)showBanner
{
    if (self.adView && self.adView.isAdValid) {
        [self.mainBackView addSubview:self.adView];
    }
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

#pragma mark - BUTTON CLICK EVENT

- (IBAction)onClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onClickDone:(id)sender {
    
    //SAVE AND CHANGE DATA
    [APP_DEL.dic_address setObject:self.txt_name.text forKey:@"Name"];
    [APP_DEL.dic_address setObject:self.txt_locality.text forKey:@"SubLocality"];
    [APP_DEL.dic_address setObject:self.txt_city.text forKey:@"City"];
    [APP_DEL.dic_address setObject:self.txt_state.text forKey:@"State"];
    [APP_DEL.dic_address setObject:self.txt_country.text forKey:@"Country"];
    [APP_DEL.dic_address setObject:self.txt_zip.text forKey:@"ZIP"];

    [self.navigationController popViewControllerAnimated:YES];
}


@end
