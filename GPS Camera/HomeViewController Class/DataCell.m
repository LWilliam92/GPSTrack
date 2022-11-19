//
//  DataCell.m
//  GPS Camera
//
//  Created by My Mac on 4/6/19.
//  Copyright © 2019 My Mac. All rights reserved.
//

#import "DataCell.h"
#import "StringConstants.h"

@implementation DataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if(SCREEN_HEIGHT==812 || SCREEN_HEIGHT==896)
    {
        self.img_back.image=[UIImage imageNamed:@"background"];
    }
    else
    {
        self.img_back.image=[UIImage imageNamed:@"backgroundX"];
    }
}

@end
