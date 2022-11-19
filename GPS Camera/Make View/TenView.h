//
//  TenView.h
//  GPS Camera
//
//  Created by My Mac on 4/8/19.
//  Copyright © 2019 My Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TenView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lbl_year;
@property (weak, nonatomic) IBOutlet UILabel *lbl_country;
@property (weak, nonatomic) IBOutlet UILabel *lbl_weekname;
@property (weak, nonatomic) IBOutlet UILabel *lbl_date;
@property (weak, nonatomic) IBOutlet UILabel *lbl_temp;


- (void)setUpViewWithTimeDic:(NSMutableDictionary *)dic_time addressDic:(NSMutableDictionary *)dic_address tempratureDic:(NSMutableDictionary *)dic_temprature;


@end
