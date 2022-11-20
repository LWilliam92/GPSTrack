//
//  PrivacyPolicyVC.m
//  GPS Photo Maker
//
//  Created by Kar Wai Ng on 20/11/2022.
//  Copyright © 2022 My Mac. All rights reserved.
//

#import "PrivacyPolicyVC.h"

@interface PrivacyPolicyVC ()
{
}
@end

@implementation PrivacyPolicyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.privacyPolicyLbl.text = @"This app respects and protects the privacy of all users who use the service. In order to provide you with more accurate and personalized services, this app will use and disclose your personal information in accordance with this Privacy Policy. However, this application will treat this information with a high degree of diligence and prudence. Except as otherwise provided in this Privacy Policy, this application will not disclose or provide this information to third parties without your prior permission. This app will update this privacy policy from time to time. By agreeing to this Application Services Use Agreement, you are deemed to have agreed to the entire content of this Privacy Policy. This Privacy Policy is an integral part of this Application Service Agreement.\n\n1. Scope of application\n\n(a) the personal registration information you provide in accordance with the requirements of this application when you register for this application account;\n\n(b) The information on your browser and computer that the application automatically receives and records when you use the App Network Service or access the App Platform webpage, including but not limited to your IP address, browser type, Data such as language used, date and time of access, hardware and software feature information, and web page records you need;\n\n(c) User personal data obtained by the application from a business partner through legal means.\n\nYou understand and agree that the following information does not apply to this Privacy Policy:\n\n(a) the keyword information you entered when using the search service provided by the app;\n\n(b) Relevant information collected by you in this application, including but not limited to participation activities, transaction information and evaluation details;\n\n(c) Violation of the law or violation of this Code of Conduct and the actions that this application has taken against you.\n\n2. Information use\n\n(a) This application does not provide, sell, rent, share or trade your personal information to any unrelated third party, unless you have obtained your permission in advance, or the third party and the application (including the application affiliate) are separate or common. To provide you with services, and after the service is over, it will be banned from accessing all of this material that it has previously been able to access.\n\n(b) This application also does not permit any third party to collect, edit, sell or distribute your personal information by any means. Any user of this application platform who engages in the above activities, once found, the application has the right to immediately terminate the service agreement with the user.\n\n(c) For the purpose of serving the User, the App may use the information you use to provide you with information of interest to you, including but not limited to, sending you product and service information, or sharing information with the App Partner so that they may Send you information about its products and services (the latter requires your prior consent).\n\n3. Information disclosure\n\nIn the following circumstances, this application will disclose your personal information in whole or in part according to your personal wishes or the law:\n\n(a) disclose to third parties with your prior consent;\n\n(b) To provide the products and services you request, you must share your personal information with third parties;\n\n(c) Disclosure to third parties or administrative or judicial authorities in accordance with the relevant provisions of the law, or at the request of the administrative or judicial authorities;\n\n(d) If you have violated relevant Chinese laws, regulations or this application service agreement or related rules, you need to disclose it to third parties;\n\n(e) If you are a qualified IP Complainant and have filed a complaint, it should be disclosed to the Respondent at the request of the Complainant so that both parties can handle possible rights disputes;\n\n> Logan Howlett:\n\n(f) In a transaction created on this application platform, if any party to the transaction performs or partially fulfills the transaction obligation and requests for information disclosure, the application has the right to decide to provide the user with the contact information of the counterparty, etc. Information to facilitate the completion of a transaction or the resolution of a dispute.\n\n(g) Other disclosures that this application considers appropriate in accordance with laws, regulations or website policies.\n\n4. Information storage and exchange\n\nThe information and materials collected by you in this application will be stored on the application and/or the servers of its affiliates, which may be transmitted to your country, region or the location where the application collects information and materials. It is accessed, stored and displayed outside the country.\n\n5. Use of cookies\n\n(a) In the event that you do not refuse to accept cookies, the App will set or access cookies on your computer so that you can log in or use cookies-based services or features that rely on cookies. This app uses cookies to provide you with more thoughtful and personalized services, including promotional services.\n\n(b) You have the right to accept or reject the acceptance of cookies. You can refuse to accept cookies by modifying your browser settings. However, if you choose to refuse to accept cookies, you may not be able to log in or use this application web service or feature that relies on cookies.\n\n(c) This policy will apply to information obtained through the cookies provided in this application.\n\n6. Information security\n\n(a) This application account has security protection. Please keep your username and password information safe. This application will ensure that your information is not lost, not abused or altered, by security measures such as encrypting user passwords. Despite the aforementioned security measures, please also note that there are no “perfect security measures” on the information network.\n\n(b) When using this application web service for online transactions, you will inevitably have to deal with the counterparty or potential transaction pair\n\n7. Changes to this Privacy Policy\n\n(a) If we decide to change our Privacy Policy, we will post those changes in this Policy, on our website, and in such locations as we deem appropriate, so that you can understand how we collect and use your personal information and who can access it. And under what circumstances we will disclose this information.\n\n(b) The company reserves the right to modify this policy at any time, so please check it frequently. In the event of a material change to this policy, the Company will notify you by notice on the website.\n\nThe party discloses its personal information, such as contact information or postal address. Please protect your personal information and provide it to others only when necessary. If you find that your personal information is leaked, especially if the application username and password are leaked, please contact this application customer service immediately so that the application can take corresponding measures.";

    
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
}
@end
