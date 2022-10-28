//
//  SecoundView.m
//  GPS Camera
//
//  Created by My Mac on 4/7/19.
//  Copyright © 2019 My Mac. All rights reserved.
//

#import "SecoundView.h"

@implementation SecoundView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setUpViewWithTimeDic:(NSMutableDictionary *)dic_time addressDic:(NSMutableDictionary *)dic_address tempratureDic:(NSMutableDictionary *)dic_temprature
{

    NSString *timeFormate = [[NSUserDefaults standardUserDefaults]objectForKey:@"timeFormate"];
    
    if ([timeFormate isEqualToString:@"12Hour"]) {
        self.lbl_time.text = [NSString stringWithFormat:@"%@:%@ %@",[dic_time objectForKey:@"current12Hour"],[dic_time objectForKey:@"currentMinuit"],[dic_time objectForKey:@"currentFormate"]];
    }
    else if ([timeFormate isEqualToString:@"24Hour"]) {
        self.lbl_time.text = [NSString stringWithFormat:@"%@:%@ %@",[dic_time objectForKey:@"current24Hour"],[dic_time objectForKey:@"currentMinuit"],[dic_time objectForKey:@"currentFormate"]];
    }
    
    NSString *loweCase = [NSString stringWithFormat:@"%@, %@ %@",[dic_time objectForKey:@"currentFullWeekName"],[dic_time objectForKey:@"currentDate"],[dic_time objectForKey:@"currentShortMonthName"]];
    NSString *uparcaseDate = [loweCase uppercaseString];

    self.lbl_date.text = uparcaseDate;

    NSString *loweCaseCountry = [NSString stringWithFormat:@"%@",[dic_address objectForKey:@"Country"]];
    NSString *uparcaseCountry = [loweCaseCountry uppercaseString];

    self.lbl_country.text = uparcaseCountry;

    self.lbl_lat.text = [NSString stringWithFormat:@"LATITUDE   : %@",[dic_temprature objectForKey:@"latitude"]];
    self.lbl_long.text = [NSString stringWithFormat:@"LONGITUDE : %@",[dic_temprature objectForKey:@"longitude"]];
    
    
    
    
    
    //CHANGE ALL LABLE TEXT IF NULL
    UIView *backView = [self viewWithTag:1];
    for (UIView *i in backView.subviews){
        
        if([i isKindOfClass:[UILabel class]]) {
            UILabel *newLbl = (UILabel *)i;
            UIColor *lbl_bc = newLbl.backgroundColor;
            
            if (([newLbl.text containsString:@"(NULL)"] || [newLbl.text containsString:@"(null)"] || newLbl.text.length <=0 || [newLbl.text isEqualToString:@""]) && lbl_bc == nil)
            {
                newLbl.text = @"-";
            }
        }
    }

    
}

@end
