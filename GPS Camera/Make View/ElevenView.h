//
//  ElevenView.h
//  GPS Camera
//
//  Created by My Mac on 4/8/19.
//  Copyright © 2019 My Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ElevenView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lbl_city;
@property (weak, nonatomic) IBOutlet UILabel *lbl_weekname;
@property (weak, nonatomic) IBOutlet UILabel *lbl_date;
@property (weak, nonatomic) IBOutlet UILabel *lbl_temp;
@property (weak, nonatomic) IBOutlet UILabel *lbl_lat;
@property (weak, nonatomic) IBOutlet UILabel *lbl_long;
@property (weak, nonatomic) IBOutlet UILabel *lbl_address;


- (void)setUpViewWithTimeDic:(NSMutableDictionary *)dic_time addressDic:(NSMutableDictionary *)dic_address tempratureDic:(NSMutableDictionary *)dic_temprature;





@end
