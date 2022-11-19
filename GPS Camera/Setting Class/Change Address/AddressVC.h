//
//  AddressVC.h
//  GPS Camera
//
//  Created by My Mac on 4/6/19.
//  Copyright © 2019 My Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StringConstants.h"

@interface AddressVC : BaseViewController<FBAdViewDelegate,FBInterstitialAdDelegate>

@property (nonatomic, strong) FBAdView *adView;
@property (nonatomic, strong) FBInterstitialAd *interstitialAd;

- (IBAction)onClickBack:(id)sender;
- (IBAction)onClickDone:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *txt_name;
@property (weak, nonatomic) IBOutlet UITextField *txt_locality;
@property (weak, nonatomic) IBOutlet UITextField *txt_city;
@property (weak, nonatomic) IBOutlet UITextField *txt_state;
@property (weak, nonatomic) IBOutlet UITextField *txt_country;
@property (weak, nonatomic) IBOutlet UITextField *txt_zip;



@end
