//
//  EvaluateTextViewCell.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/16.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "EvaluateTextViewCell.h"

@implementation EvaluateTextViewCell{
    IBOutletCollection(UIButton) NSArray *Stars;
}

- (void)awakeFromNib {
    // Initialization code
    self.tvEvaluate.layer.borderWidth=0.5;
    self.tvEvaluate.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    [self.tvEvaluate setPlaceholder:@"说点什么吧~"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)starTouch:(UIButton *)sender {
    for (int i=0; i<Stars.count; i++) {
        if (i>sender.tag) {
            [((UIButton*)[Stars objectAtIndex:i]) setBackgroundImage:[UIImage imageNamed:@"评价-星2"] forState:UIControlStateNormal];
        }else{
            [((UIButton*)[Stars objectAtIndex:i]) setBackgroundImage:[UIImage imageNamed:@"评价-星1"] forState:UIControlStateNormal];
        }
    }
    if (self.block) {
        self.block((int)sender.tag+1);
    }
}

- (IBAction)commit:(UIButton*)sender {
    if (self.block) {
        self.block(0);
    }
}

- (void)waitBlock:(IntBlock)block{
    self.block=block;
}

@end
