//
//  HomeViewController.h
//  SimpleWeather
//
//  Created by My Mac on 4/6/19.
//  Copyright © 2019 Ryan Nystrom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>

#import "StringConstants.h"
#import "DataCell.h"

#import "SettingVC.h"

//THIRD PART FOR CHOOSE PHOTO, SELECT COLR AND NEWORK CHECK
#import "UIViewController+YMSPhotoHelper.h"
#import "MSColorSelectionViewController.h"
#import "Reachability.h"

//VIEW IMPORT IN CELL FOR DISPLAY DATA
#import "FirstView.h"
#import "SecoundView.h"
#import "ThirdView.h"
#import "FourthView.h"
#import "FifthView.h"
#import "SixthView.h"
#import "SevnthView.h"
#import "EightView.h"
#import "NineView.h"
#import "TenView.h"
#import "ElevenView.h"
#import "TwelveView.h"

@interface HomeViewController : BaseViewController<CLLocationManagerDelegate,YMSPhotoPickerViewControllerDelegate,UIPopoverPresentationControllerDelegate,MSColorSelectionViewControllerDelegate>
{
    CLLocationManager *locationManager;
    BOOL isLocationGot;
    
    NSIndexPath *currentIndexPath;
}

@property (nonatomic, strong)UIColor *color_select;
@property (nonatomic, strong)UIImage *img_send;

@property (weak, nonatomic) IBOutlet UIView *snapView;
@property (weak, nonatomic) IBOutlet UICollectionView *collection_data;

- (IBAction)onClickSetting:(id)sender;


@end
