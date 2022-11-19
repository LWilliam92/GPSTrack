//
//  PrivacyPolicyVC.h
//  GPS Photo Maker
//
//  Created by Kar Wai Ng on 20/11/2022.
//  Copyright © 2022 My Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringConstants.h"

@interface PrivacyPolicyVC : BaseViewController<FBAdViewDelegate,FBInterstitialAdDelegate>

- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickDone:(id)sender;

@property (nonatomic, strong) FBAdView *adView;
@property (nonatomic, strong) FBInterstitialAd *interstitialAd;

@property (weak, nonatomic) IBOutlet UILabel *privacyPolicyLbl;

@end
