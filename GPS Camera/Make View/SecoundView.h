//
//  SecoundView.h
//  GPS Camera
//
//  Created by My Mac on 4/7/19.
//  Copyright © 2019 My Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecoundView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lbl_time;
@property (weak, nonatomic) IBOutlet UILabel *lbl_date;
@property (weak, nonatomic) IBOutlet UILabel *lbl_country;
@property (weak, nonatomic) IBOutlet UILabel *lbl_long;
@property (weak, nonatomic) IBOutlet UILabel *lbl_lat;






- (void)setUpViewWithTimeDic:(NSMutableDictionary *)dic_time addressDic:(NSMutableDictionary *)dic_address tempratureDic:(NSMutableDictionary *)dic_temprature;

@end
