//
//  OrderHandleCell.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/12.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "OrderHandleCell.h"

@implementation OrderHandleCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)handle:(UIButton*)sender {
    if (_block) {
        _block((int)sender.tag);
    }
}

- (void) waitBlock :(IntBlock) block{
    _block=block;
}
@end
