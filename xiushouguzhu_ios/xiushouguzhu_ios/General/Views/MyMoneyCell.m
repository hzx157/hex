//
//  MyMoneyCell.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/12.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "MyMoneyCell.h"

@implementation MyMoneyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)recharge:(UIButton *)sender {
    if (self.RechargeBlock) {
        self.RechargeBlock();
        NSLog(@"充值");
    }
    ;
}

@end
