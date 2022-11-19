//
//  CombineImageVC.m
//  SimpleWeather
//
//  Created by My Mac on 4/6/19.
//  Copyright © 2019 Ryan Nystrom. All rights reserved.
//

#import "CombineImageVC.h"

@interface CombineImageVC ()


@end

@implementation CombineImageVC



- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    //FIRST GET IMAGEVIEW FRAME
    self.img_snap.image = self.img_original;
    [self frameImageView:self.img_original];
    
    //ADS SUB IMAGE ON MAIN IMAGE
    self.view_data.frame = CGRectMake(0, self.img_snap.frame.size.height-self.view_data.frame.size.height, self.view_data.frame.size.width, self.view_data.frame.size.height);
    [self.img_snap addSubview:self.view_data];

    //COMBINE BOTH IMAGE AND DISPLAY IT IN IMAGEVIEW
    self.img_snap.image = [self createImage:self.img_snap];
    
    //BUTTON BORDER COLOR AND CORNER RADIUS
    self.btn_save.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btn_save.layer.borderWidth = 1.0;
    self.btn_save.layer.cornerRadius = 5.0;

    self.btn_share.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btn_share.layer.borderWidth = 1.0;
    self.btn_share.layer.cornerRadius = 5.0;
    
    //FACEBOOK BANNER ADS
    self.adView = [[FBAdView alloc] initWithPlacementID:FB_BANNER_ID adSize:kFBAdSizeHeight50Banner rootViewController:self];
    self.adView.delegate = self;
    [self.adView loadAd];
    self.adView.hidden = YES;
    
    //FACEBOOK INTERSTITAL ADS
    [self createAndLoadInterstitial];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.adView.hidden = NO;
    self.adView.frame = CGRectMake(0, self.mainBackView.frame.size.height-50, self.mainBackView.frame.size.width, 50);
}


#pragma mark - CREATE IMAGE
//COMBINE TWO IMAGE
-(UIImage *)createImage:(UIImageView *)imgeview
{
    UIGraphicsBeginImageContextWithOptions(imgeview.bounds.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [imgeview.layer renderInContext:context];
    UIImage *imgs = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imgs;
}

//GET MAIN IMAGEVIEW FRAME
- (void)frameImageView:(UIImage *)image
{
    CGSize kMaxImageViewSize = {.width = SCREEN_WIDTH-16, .height = SCREEN_WIDTH-16};
    CGSize imageSize = image.size;
    CGFloat aspectRatio = imageSize.width / imageSize.height;
    CGRect frame = self.img_snap.frame;
    if (kMaxImageViewSize.width / aspectRatio <= kMaxImageViewSize.height)
    {
        frame.size.width = kMaxImageViewSize.width;
        frame.size.height = frame.size.width / aspectRatio;
    }
    else
    {
        frame.size.height = kMaxImageViewSize.height;
        frame.size.width = frame.size.height * aspectRatio;
    }
    
    self.img_snap.frame = CGRectMake((SCREEN_WIDTH/2)-(frame.size.width/2), 77*WIDTH_TRIANGLE, frame.size.width, frame.size.height);
}




#pragma mark - FACEBOOK ADS DELEGATE METHOD

//SHOW FACEBOOK ADS
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

//SHOW BANNER
- (void)showBanner
{
    if (self.adView && self.adView.isAdValid) {
        [self.mainBackView addSubview:self.adView];
    }
}


#pragma mark - SAVE AND SHARE IMAGE

- (IBAction)onClickSave:(id)sender {
    
    UIImageWriteToSavedPhotosAlbum(self.img_snap.image, nil, nil, nil);

    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Success"
                                 message:@"Photo Saved in photo album."
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                  [self createAndLoadInterstitial];
                                }];
    
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}


- (IBAction)onClickShare:(id)sender {
    NSArray *activityItems = @[self.img_snap.image];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:nil];
    [self createAndLoadInterstitial];
}

#pragma mark - BACK

- (IBAction)onClickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
