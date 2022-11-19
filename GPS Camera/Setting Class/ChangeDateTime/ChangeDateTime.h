//
//  ChangeDateTime.h
//  GPS Camera
//
//  Created by My Mac on 4/6/19.
//  Copyright © 2019 My Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringConstants.h"

@interface ChangeDateTime : BaseViewController<FBAdViewDelegate,FBInterstitialAdDelegate>

- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickDone:(id)sender;

@property (nonatomic, strong) FBAdView *adView;
@property (nonatomic, strong) FBInterstitialAd *interstitialAd;

@property (weak, nonatomic) IBOutlet UIDatePicker *myDatePicker;

@end
