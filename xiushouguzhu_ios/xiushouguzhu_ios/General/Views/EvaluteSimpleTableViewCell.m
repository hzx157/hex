//
//  EvaluteSimpleTableViewCell.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/16.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "EvaluteSimpleTableViewCell.h"
#import "MinStar.h"

@implementation EvaluteSimpleTableViewCell{
    MinStar *vcStar;
}

- (void)awakeFromNib {
    // Initialization code
    vcStar=[[MinStar alloc]initWithFrame:CGRectMake(220, 21, 75, 15)];
    [self addSubview:vcStar];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setStars:(int)count{
    [vcStar setStarCount:count];
}


@end
