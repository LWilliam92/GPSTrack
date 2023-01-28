//
//  HomeViewController.m
//  SimpleWeather
//
//  Created by My Mac on 4/6/19.
//  Copyright © 2019 Ryan Nystrom. All rights reserved.
//

#import "HomeViewController.h"
#import "CombineImageVC.h"
#import "SettingVC.h"
#import <StoreKit/StoreKit.h>
#import "GPS_Photo_Maker-Swift.h"

@interface HomeViewController ()


@end

@implementation HomeViewController


- (void)viewWillAppear:(BOOL)animated
{
    //RELOAD DATA BECOUSE SETTING ARE CHANGE
    [self.collection_data reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //CHECK INTERNET BEFORE LOAD DATA
    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self showMessage:@"No internet" andMessage:@"Please Connect your device to internet for Better Result"];
    }
    
    [self checkAppSetting];
    
    //DEAFAUL INDEXPATH
    currentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    //GET LOACTION
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];

    
    self.collection_data.frame = CGRectMake(0, 64, SCREEN_WIDTH, self.mainBackView.frame.size.height-64-50);
    [self.collection_data registerNib:[UINib nibWithNibName:@"DataCell" bundle:nil] forCellWithReuseIdentifier:@"DataCell"];

    APP_DEL.dic_temprature = [[NSMutableDictionary alloc]init];
    APP_DEL.dic_address   = [[NSMutableDictionary alloc]init];
    APP_DEL.dic_time     = [[NSMutableDictionary alloc]init];
    
    [self getTimeDic];
    
    //OPEN ALERT EVERY 4 TIME OPEN APP TO GET REVIEW
    NSInteger appcount=[[NSUserDefaults standardUserDefaults] integerForKey:@"appcount"];
    if(appcount%4==3)
    {
        if (@available(iOS 10.3, *)) {
            [SKStoreReviewController requestReview];
        }
        appcount++;
        [[NSUserDefaults standardUserDefaults] setInteger:appcount forKey:@"appcount"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)checkAppSetting {
    NSString *urlString = [NSString stringWithFormat:@"https://qpapi.qhuat888.com/api/GetAppSetting?version=%@",@"1.0"];;
    
    NSURLRequest* requestForWeatherData = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLResponse* response = nil;
    NSError* error = nil; //do it always
    
    NSData* data = [NSURLConnection sendSynchronousRequest:requestForWeatherData returningResponse:&response error:&error]; //for saving all of received data in non-serialized view
    NSMutableDictionary *allData = [ NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error]; //data in serialized view
    
    NSLog(@"%@",allData);
    if ([[allData objectForKey:@"required_masked"] boolValue] == false) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Q" bundle:nil];
        UITabBarController *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [[UIApplication sharedApplication].keyWindow setRootViewController:rootViewController];
    }
}

#pragma mark - CREATE TIME DICTIONARY
- (void)getTimeDic
{
    NSDate *currentDate = [NSDate date];
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

#pragma mark - LOCATION DELEGATE METHOD

- (CLLocationCoordinate2D) getLocation{
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    return coordinate;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [locationManager stopUpdatingLocation];
    if (!isLocationGot) {
        isLocationGot=YES;
        
        if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
        {
            [self showMessage:@"No internet" andMessage:@"Please Connect your device to internet for Better Result"];
        }
        else
        {
            [self getAllDetail];
        }
        
        if (newLocation != nil) {
            [self getCityName:newLocation];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self showMessage:@"No internet" andMessage:@"Please Connect your device to internet for Better Result"];
    }
    else
    {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"INFO"
                                     message:@"You must enable \"Location\" under the setting menu of your device in order to recive location for add into photo"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Setting"
                                    style:UIAlertActionStyleDestructive
                                    handler:^(UIAlertAction * action)
                                    {
                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                    }];
        
        UIAlertAction* cancelButton = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action)
                                       {
                                           
                                       }];
        
        [alert addAction:cancelButton];
        [alert addAction:yesButton];
        
        [self presentViewController:alert animated:YES completion:nil];

        //GET DETAIL FOR TEMPERATURE
        [self getAllDetail];
    }
}


#pragma mark - GET ADDRESS
//GET ADDRESS FOR ADD INTO PHOTO
- (void)getCityName:(CLLocation *)location
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!placemarks) {
             // handle error
         }
         
         if(placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark= [placemarks objectAtIndex:0];
             NSString *addressx = [NSString stringWithFormat:@"%@, %@, %@, %@", [placemark subThoroughfare],[placemark thoroughfare],[placemark locality], [placemark administrativeArea]];
             
             APP_DEL.dic_address = placemark.addressDictionary.mutableCopy;
             //NSLog(@"Address : %@", APP_DEL.dic_address);
             
             [self.collection_data reloadData];
         }
     }];
    
}


#pragma MARK - API FOR GET TEMPERATURE

- (void)getAllDetail {
    
    // Near By API
    CLLocationCoordinate2D coordinate = [self getLocation];
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@&appid=e7b2054dc37b1f464d912c00dd309595&units=Metric",latitude,longitude];;
    
    NSURLRequest* requestForWeatherData = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLResponse* response = nil;
    NSError* error = nil; //do it always
    
    NSData* data = [NSURLConnection sendSynchronousRequest:requestForWeatherData returningResponse:&response error:&error]; //for saving all of received data in non-serialized view
    NSMutableDictionary *allData = [ NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error]; //data in serialized view

    int tempr = [[[allData objectForKey:@"main"] objectForKey:@"temp"] intValue];
    
    [APP_DEL.dic_temprature setObject:[NSString stringWithFormat:@"%d",tempr] forKey:@"temprature"];
    [APP_DEL.dic_temprature setObject:latitude forKey:@"latitude"];
    [APP_DEL.dic_temprature setObject:longitude forKey:@"longitude"];
    
    //NSLog(@"Temrature Dic : %@",APP_DEL.dic_temprature);
    
    [self.collection_data reloadData];
}

#pragma mark - Collection View Datasource and Delegate Method

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 12;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.collection_data.frame.size.width, self.collection_data.frame.size.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DataCell *cell = (DataCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DataCell" forIndexPath:indexPath];
    UIView *view=[cell viewWithTag:10];
    if(view!=nil)
    {
        [view removeFromSuperview];
    }
    UIView *postView = [self selectTemplate:indexPath.row];
    postView.tag=10;
    [cell addSubview:postView];
    
    return cell;
}


- (UIView *)selectTemplate:(NSInteger)index
{
    if (index == 0) {
        FirstView *postView= [[NSBundle mainBundle] loadNibNamed:@"FirstView" owner:self options:nil].firstObject;
        postView.frame = CGRectMake(0,self.collection_data.frame.size.height-116, SCREEN_WIDTH, 116);
        [postView setUpViewWithTimeDic:APP_DEL.dic_time addressDic:APP_DEL.dic_address tempratureDic:APP_DEL.dic_temprature];
        return postView;
    }
    else if (index == 1) {
        SecoundView *postView= [[NSBundle mainBundle] loadNibNamed:@"SecoundView" owner:self options:nil].firstObject;
        postView.frame = CGRectMake(0,self.collection_data.frame.size.height-86, SCREEN_WIDTH, 86);
        [postView setUpViewWithTimeDic:APP_DEL.dic_time addressDic:APP_DEL.dic_address tempratureDic:APP_DEL.dic_temprature];
        return postView;
    }
    else if (index == 2) {
        ThirdView *postView= [[NSBundle mainBundle] loadNibNamed:@"ThirdView" owner:self options:nil].firstObject;
        postView.frame = CGRectMake(0,self.collection_data.frame.size.height-181, SCREEN_WIDTH, 181);
        [postView setUpViewWithTimeDic:APP_DEL.dic_time addressDic:APP_DEL.dic_address tempratureDic:APP_DEL.dic_temprature];
        return postView;
    }
    else if (index == 3) {
        FourthView *postView= [[NSBundle mainBundle] loadNibNamed:@"FourthView" owner:self options:nil].firstObject;
        postView.frame = CGRectMake(0,self.collection_data.frame.size.height-156, SCREEN_WIDTH, 156);
        [postView setUpViewWithTimeDic:APP_DEL.dic_time addressDic:APP_DEL.dic_address tempratureDic:APP_DEL.dic_temprature];
        return postView;
    }
    else if (index == 4) {
        FifthView *postView= [[NSBundle mainBundle] loadNibNamed:@"FifthView" owner:self options:nil].firstObject;
        postView.frame = CGRectMake(0,self.collection_data.frame.size.height-156, SCREEN_WIDTH, 156);
        [postView setUpViewWithTimeDic:APP_DEL.dic_time addressDic:APP_DEL.dic_address tempratureDic:APP_DEL.dic_temprature];
        return postView;
    }
    else if (index == 5) {
        SixthView *postView= [[NSBundle mainBundle] loadNibNamed:@"SixthView" owner:self options:nil].firstObject;
        postView.frame = CGRectMake(0,self.collection_data.frame.size.height-100, SCREEN_WIDTH, 100);
        [postView setUpViewWithTimeDic:APP_DEL.dic_time addressDic:APP_DEL.dic_address tempratureDic:APP_DEL.dic_temprature];
        return postView;
    }
    else if (index == 6) {
        SevnthView *postView= [[NSBundle mainBundle] loadNibNamed:@"SevnthView" owner:self options:nil].firstObject;
        postView.frame = CGRectMake(0,self.collection_data.frame.size.height-187, SCREEN_WIDTH, 187);
        [postView setUpViewWithTimeDic:APP_DEL.dic_time addressDic:APP_DEL.dic_address tempratureDic:APP_DEL.dic_temprature];
        return postView;
    }
    else if (index == 7) {
        EightView *postView= [[NSBundle mainBundle] loadNibNamed:@"EightView" owner:self options:nil].firstObject;
        postView.frame = CGRectMake(0,self.collection_data.frame.size.height-173, SCREEN_WIDTH, 173);
        [postView setUpViewWithTimeDic:APP_DEL.dic_time addressDic:APP_DEL.dic_address tempratureDic:APP_DEL.dic_temprature];
        return postView;
    }
    else if (index == 8) {
        NineView *postView= [[NSBundle mainBundle] loadNibNamed:@"NineView" owner:self options:nil].firstObject;
        postView.frame = CGRectMake(0,self.collection_data.frame.size.height-100, SCREEN_WIDTH, 100);
        [postView setUpViewWithTimeDic:APP_DEL.dic_time addressDic:APP_DEL.dic_address tempratureDic:APP_DEL.dic_temprature];
        return postView;
    }
    else if (index == 9) {
        TenView *postView= [[NSBundle mainBundle] loadNibNamed:@"TenView" owner:self options:nil].firstObject;
        postView.frame = CGRectMake(0,self.collection_data.frame.size.height-198, SCREEN_WIDTH, 198);
        [postView setUpViewWithTimeDic:APP_DEL.dic_time addressDic:APP_DEL.dic_address tempratureDic:APP_DEL.dic_temprature];
        return postView;
    }
    else if (index == 10) {
        ElevenView *postView= [[NSBundle mainBundle] loadNibNamed:@"ElevenView" owner:self options:nil].firstObject;
        postView.frame = CGRectMake(0,self.collection_data.frame.size.height-126, SCREEN_WIDTH, 126);
        [postView setUpViewWithTimeDic:APP_DEL.dic_time addressDic:APP_DEL.dic_address tempratureDic:APP_DEL.dic_temprature];
        return postView;
    }
    else if (index == 11) {
        TwelveView *postView= [[NSBundle mainBundle] loadNibNamed:@"TwelveView" owner:self options:nil].firstObject;
        postView.frame = CGRectMake(0,self.collection_data.frame.size.height-80, SCREEN_WIDTH, 80);
        [postView setUpViewWithTimeDic:APP_DEL.dic_time addressDic:APP_DEL.dic_address tempratureDic:APP_DEL.dic_temprature];
        return postView;
    }
    else
    {
        FirstView *postView= [[NSBundle mainBundle] loadNibNamed:@"FirstView" owner:self options:nil].firstObject;
        postView.frame = CGRectMake(0,self.collection_data.frame.size.height-116, SCREEN_WIDTH, 116);
        [postView setUpViewWithTimeDic:APP_DEL.dic_time addressDic:APP_DEL.dic_address tempratureDic:APP_DEL.dic_temprature];
        return postView;
    }
}

#pragma mark - DONE METHOD
- (IBAction)onClickDone:(id)sender {
    
    
    // SELECT PHOTO
    YMSPhotoPickerViewController *pickerViewController = [[YMSPhotoPickerViewController alloc] init];
    pickerViewController.numberOfPhotoToSelect = 1;
    UIColor *customColor = [UIColor colorWithRed:33.0/255.0 green:33.0/255.0 blue:33.0/255.0 alpha:1.0];
    
    pickerViewController.theme.titleLabelTextColor = [UIColor whiteColor];
    pickerViewController.theme.navigationBarBackgroundColor = customColor;
    pickerViewController.theme.tintColor = [UIColor whiteColor];
    pickerViewController.theme.orderTintColor = customColor;
    pickerViewController.theme.orderLabelTextColor = [UIColor whiteColor];
    pickerViewController.theme.cameraVeilColor = customColor;
    pickerViewController.theme.cameraIconColor = [UIColor whiteColor];
    pickerViewController.theme.statusBarStyle = UIStatusBarStyleDefault;
    
    [self yms_presentCustomAlbumPhotoView:pickerViewController delegate:self];
}

#pragma mark - YMSPhotoPickerViewControllerDelegate

- (void)photoPickerViewControllerDidReceivePhotoAlbumAccessDenied:(YMSPhotoPickerViewController *)picker
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Allow photo album access?", nil) message:NSLocalizedString(@"Need your permission to access photo albumbs", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alertController addAction:dismissAction];
    [alertController addAction:settingsAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)photoPickerViewControllerDidReceiveCameraAccessDenied:(YMSPhotoPickerViewController *)picker
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Allow camera access?", nil) message:NSLocalizedString(@"Need your permission to take a photo", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alertController addAction:dismissAction];
    [alertController addAction:settingsAction];
    
    // The access denied of camera is always happened on picker, present alert on it to follow the view hierarchy
    [picker presentViewController:alertController animated:YES completion:nil];
}

- (void)photoPickerViewController:(YMSPhotoPickerViewController *)picker didFinishPickingImage:(UIImage *)image
{
    
    [picker dismissViewControllerAnimated:YES completion:^() {
        
        self.img_send = image;
        
        MSColorSelectionViewController *colorSelectionController = [[MSColorSelectionViewController alloc] init];
        UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:colorSelectionController];
        
        navCtrl.modalPresentationStyle = UIModalPresentationPopover;
        navCtrl.popoverPresentationController.delegate = self;
        navCtrl.preferredContentSize = [colorSelectionController.view systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        navCtrl.navigationBar.translucent = NO;
        [navCtrl.navigationBar setBarTintColor:[UIColor colorWithRed:33.0/255.0 green:33.0/255.0 blue:33.0/255.0 alpha:1.0]];
        
        colorSelectionController.delegate = self;
        colorSelectionController.color = [UIColor whiteColor];
        
        if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(ms_dismissViewController:)];
            doneBtn.tag = 210;
            
            NSDictionary *barButtonAppearanceDict = @{NSFontAttributeName : [UIFont systemFontOfSize:15], NSForegroundColorAttributeName: [UIColor whiteColor]};
            [doneBtn setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];
            
            
            colorSelectionController.navigationItem.rightBarButtonItem = doneBtn;
            UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Skip" style:UIBarButtonItemStyleDone target:self action:@selector(ms_dismissViewController:)];
            cancelBtn.tag = 211;
            [cancelBtn setTitleTextAttributes:barButtonAppearanceDict forState:UIControlStateNormal];
            
            colorSelectionController.navigationItem.leftBarButtonItem = cancelBtn;
            
            NSDictionary *titleText = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:17], NSForegroundColorAttributeName: [UIColor whiteColor]};
            
            navCtrl.navigationBar.titleTextAttributes = titleText;
            
        }
        
        [self presentViewController:navCtrl animated:YES completion:nil];
        
    }];
}






#pragma mark - MSColorViewDelegate

- (void)colorViewController:(MSColorSelectionViewController *)colorViewCntroller didChangeColor:(UIColor *)color
{
    self.color_select = color;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    for (UICollectionViewCell *cell in [self.collection_data visibleCells]) {
        currentIndexPath = [self.collection_data indexPathForCell:cell];
       // NSLog(@"%@",currentIndexPath);
    }
}

#pragma mark - Private

- (void)ms_dismissViewController:(id)sender
{
    UIBarButtonItem *btn=(UIBarButtonItem *)sender;
    
    if (btn.tag == 210)
    {
        NSArray* visibleCellIndex = self.collection_data.indexPathsForVisibleItems;

        if (visibleCellIndex.count>0) {
            currentIndexPath = [visibleCellIndex objectAtIndex:0];
        }
        
        
        UIView *postView = [self selectTemplate:currentIndexPath.row];
        UIView *backView = [postView viewWithTag:1];

        //GET THE SIZE OF IMAGEVIEW FOR CREATE SUBVIEW OF DATA
        CGRect framex = [self frameImageView:self.img_send];
        BOOL flag = NO;
        
        if (framex.size.width<backView.frame.size.width) {
            flag = YES;
            backView.frame = CGRectMake(backView.frame.origin.x, backView.frame.origin.y, framex.size.width, backView.frame.size.height);
        }

         for (UIView *i in backView.subviews){
            if([i isKindOfClass:[UILabel class]]) {
                UILabel *newLbl = (UILabel *)i;
                newLbl.textColor = self.color_select;
                
                if (flag) {
                    NSString *fontName = newLbl.font.fontName;
                    CGFloat fontSize = newLbl.font.pointSize;
                    CGFloat newFontSize = (backView.frame.size.width*fontSize)/SCREEN_WIDTH;
                    newLbl.font = [UIFont fontWithName:fontName size:newFontSize];
                }
            }
         }
        
         CombineImageVC *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CombineImageVC"];
         nextVC.view_data = backView;
         nextVC.img_original = self.img_send;
         [self.navigationController pushViewController:nextVC animated:YES];
    }
    else
    {
        
        NSArray* visibleCellIndex = self.collection_data.indexPathsForVisibleItems;
        
        if (visibleCellIndex.count>0) {
            currentIndexPath = [visibleCellIndex objectAtIndex:0];
        }

        UIView *postView = [self selectTemplate:currentIndexPath.row];
        UIView *backView = [postView viewWithTag:1];

        //GET THE SIZE OF IMAGEVIEW FOR CREATE SUBVIEW OF DATA
        CGRect framex = [self frameImageView:self.img_send];
        BOOL flag = NO;

        if (framex.size.width<backView.frame.size.width) {
            flag = YES;
            backView.frame = CGRectMake(backView.frame.origin.x, backView.frame.origin.y, framex.size.width, backView.frame.size.height);
        }
        

        for (UIView *i in backView.subviews){
         
            if([i isKindOfClass:[UILabel class]]) {
               
                UILabel *newLbl = (UILabel *)i;

                if (flag) {
                    NSString *fontName = newLbl.font.fontName;
                    CGFloat fontSize = newLbl.font.pointSize;
                    CGFloat newFontSize = (backView.frame.size.width*fontSize)/SCREEN_WIDTH;
                    newLbl.font = [UIFont fontWithName:fontName size:newFontSize];
                }
            }
        }
        
        CombineImageVC *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CombineImageVC"];
        nextVC.view_data = backView;
        nextVC.img_original = self.img_send;
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (CGRect)frameImageView:(UIImage *)image
{
    CGSize kMaxImageViewSize = {.width = SCREEN_WIDTH-16, .height = SCREEN_WIDTH-16};
    CGSize imageSize = image.size;
    CGFloat aspectRatio = imageSize.width / imageSize.height;
    CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH-16, SCREEN_WIDTH-16);
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
    return frame;
}



- (IBAction)onClickSetting:(id)sender {
    SettingVC *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingVC"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma MARK - ALERT DYANAMIC METHOD

- (void)showMessage:(NSString *)title andMessage:(NSString *)msg
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:msg
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Ok"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                }];
    
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
