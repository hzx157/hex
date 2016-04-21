//
//  IntegralTimeCell.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/12.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "IntegralTimeCell.h"

@implementation IntegralTimeCell

- (void)awakeFromNib {
    // Initialization code
    _btnFrom.layer.borderWidth=0.5;
    _btnFrom.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    _btnTo.layer.borderWidth=0.5;
    _btnTo.layer.borderColor=[[UIColor lightGrayColor] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnClick:(UIButton *)sender {
    if (self.TagBlock) {
        self.TagBlock((int)sender.tag);
    }
}

@end
