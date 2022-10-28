//
//  SixthView.m
//  GPS Camera
//
//  Created by My Mac on 4/8/19.
//  Copyright © 2019 My Mac. All rights reserved.
//

#import "SixthView.h"

@implementation SixthView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setUpViewWithTimeDic:(NSMutableDictionary *)dic_time addressDic:(NSMutableDictionary *)dic_address tempratureDic:(NSMutableDictionary *)dic_temprature
{
    
    NSString *str_city = [NSString stringWithFormat:@"TRAVELING TO %@",[dic_address objectForKey:@"City"]];
    self.lbl_city.text = [str_city uppercaseString];
    
    NSString *loweCase = [NSString stringWithFormat:@"%@, %@ - %@ - %@",[dic_time objectForKey:@"currentShortWeekName"],[dic_time objectForKey:@"currentDate"],[dic_time objectForKey:@"currentShortMonthName"],[dic_time objectForKey:@"currentYear"]];
    self.lbl_date.text = [loweCase uppercaseString];

    NSString *str_add = [NSString stringWithFormat:@"%@, %@",[dic_address objectForKey:@"State"],[dic_address objectForKey:@"Country"]];
    self.lbl_address.text = str_add;
    
    
    
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
