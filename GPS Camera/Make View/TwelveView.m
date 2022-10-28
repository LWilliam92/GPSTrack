//
//  TwelveView.m
//  GPS Camera
//
//  Created by My Mac on 4/8/19.
//  Copyright © 2019 My Mac. All rights reserved.
//

#import "TwelveView.h"

@implementation TwelveView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setUpViewWithTimeDic:(NSMutableDictionary *)dic_time addressDic:(NSMutableDictionary *)dic_address tempratureDic:(NSMutableDictionary *)dic_temprature
{

    NSString *dateFormate = [[NSUserDefaults standardUserDefaults]objectForKey:@"dateFormate"];
    NSString *timeFormate = [[NSUserDefaults standardUserDefaults]objectForKey:@"timeFormate"];
    
    if ([timeFormate isEqualToString:@"12Hour"]) {
        self.lbl_time.text = [NSString stringWithFormat:@"%@:%@ %@",[dic_time objectForKey:@"current12Hour"],[dic_time objectForKey:@"currentMinuit"],[dic_time objectForKey:@"currentFormate"]];
    }
    else if ([timeFormate isEqualToString:@"24Hour"]) {
        self.lbl_time.text = [NSString stringWithFormat:@"%@:%@ %@",[dic_time objectForKey:@"current24Hour"],[dic_time objectForKey:@"currentMinuit"],[dic_time objectForKey:@"currentFormate"]];
    }

    NSString *str_date;
    
    if ([dateFormate isEqualToString:@"dd-mm-yyyy"]) {
        str_date = [NSString stringWithFormat:@"%@ %@ %@",[dic_time objectForKey:@"currentDate"],[dic_time objectForKey:@"currentFullMonthName"],[dic_time objectForKey:@"currentYear"]];
    }
    else if ([dateFormate isEqualToString:@"mm-dd-yyyy"]) {
        str_date = [NSString stringWithFormat:@"%@ %@ %@",[dic_time objectForKey:@"currentFullMonthName"],[dic_time objectForKey:@"currentDate"],[dic_time objectForKey:@"currentYear"]];
    }
    else if ([dateFormate isEqualToString:@"yyyy-mm-dd"]) {
        str_date = [NSString stringWithFormat:@"%@ %@ %@",[dic_time objectForKey:@"currentYear"],[dic_time objectForKey:@"currentFullMonthName"],[dic_time objectForKey:@"currentDate"]];
    }

    self.lbl_date.text = str_date;
    self.lbl_city.text = [[dic_address objectForKey:@"City"] uppercaseString];
    self.lbl_country.text = [[dic_address objectForKey:@"Country"] uppercaseString];
    
    
    
    
    
    
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
