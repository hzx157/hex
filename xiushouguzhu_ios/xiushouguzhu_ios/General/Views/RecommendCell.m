//
//  RecommendCell.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/16.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "RecommendCell.h"
#import "MinStar.h"

@implementation RecommendCell{
    MinStar *vcStar;
}

- (void)awakeFromNib {
    // Initialization code
    self.ivAuntPhoto.layer.masksToBounds=YES;
    self.ivAuntPhoto.layer.cornerRadius=31;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setXi:(float)xi{
    [vcStar removeFromSuperview];
    vcStar=[[MinStar alloc]initWithFrame:CGRectMake(80, 36, 75, 15)];
    [vcStar setStarCount:(int)xi];
    [self addSubview:vcStar];
}

@end
