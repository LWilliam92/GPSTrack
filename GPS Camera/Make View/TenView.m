//
//  TenView.m
//  GPS Camera
//
//  Created by My Mac on 4/8/19.
//  Copyright © 2019 My Mac. All rights reserved.
//

#import "TenView.h"

@implementation TenView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setUpViewWithTimeDic:(NSMutableDictionary *)dic_time addressDic:(NSMutableDictionary *)dic_address tempratureDic:(NSMutableDictionary *)dic_temprature
{

    self.lbl_year.text = [dic_time objectForKey:@"currentYear"];
    self.lbl_country.text = [[dic_address objectForKey:@"Country"] uppercaseString];
    self.lbl_temp.text = [NSString stringWithFormat:@"%@° C",[dic_temprature objectForKey:@"temprature"]];

    self.lbl_weekname.text = [[dic_time objectForKey:@"currentFullWeekName"] uppercaseString];
    
    NSString *dateFormate = [[NSUserDefaults standardUserDefaults]objectForKey:@"dateFormate"];
    NSString *str_date;
    
    if ([dateFormate isEqualToString:@"dd-mm-yyyy"]) {
        str_date = [NSString stringWithFormat:@"%@/%@/%@",[dic_time objectForKey:@"currentDate"],[dic_time objectForKey:@"currentMonth"],[dic_time objectForKey:@"currentYear"]];
    }
    else if ([dateFormate isEqualToString:@"mm-dd-yyyy"]) {
        str_date = [NSString stringWithFormat:@"%@/%@/%@",[dic_time objectForKey:@"currentMonth"],[dic_time objectForKey:@"currentDate"],[dic_time objectForKey:@"currentYear"]];
    }
    else if ([dateFormate isEqualToString:@"yyyy-mm-dd"]) {
        str_date = [NSString stringWithFormat:@"%@/%@/%@",[dic_time objectForKey:@"currentYear"],[dic_time objectForKey:@"currentMonth"],[dic_time objectForKey:@"currentDate"]];
    }
    
    self.lbl_date.text = str_date;

    
    
    
    
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
