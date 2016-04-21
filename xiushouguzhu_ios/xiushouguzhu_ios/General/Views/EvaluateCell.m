//
//  EvaluateCell.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/12.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "EvaluateCell.h"
#import "MinStar.h"

@implementation EvaluateCell{
    MinStar *vcStar;
}

- (void)awakeFromNib {
    // Initialization code
    vcStar=[[MinStar alloc]initWithFrame:CGRectMake(220, 21, 75, 15)];
    [self addSubview:vcStar];
    _ivAunt.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _ivAunt.layer.borderWidth=0.1f;
    _ivAunt.layer.cornerRadius=30.0f;
    _ivAunt.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setStars:(int)count{
    [vcStar setStarCount:count];
}

@end
