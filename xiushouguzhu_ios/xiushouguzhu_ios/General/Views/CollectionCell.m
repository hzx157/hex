//
//  CollectionCell.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/12.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "CollectionCell.h"
#import "MinStar.h"

@implementation CollectionCell{
    MinStar *vcStar;
}

- (void)awakeFromNib {
    // Initialization code
    
    _ivAuntPhoto.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _ivAuntPhoto.layer.borderWidth=0.1f;
    _ivAuntPhoto.layer.cornerRadius=30.0f;
    _ivAuntPhoto.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setXj:(int)xj{
    [vcStar removeFromSuperview];
    vcStar=[[MinStar alloc]initWithFrame:CGRectMake(150, 22, 75, 15)];
    [vcStar setStarCount:xj];
    [self addSubview:vcStar];
}

@end
