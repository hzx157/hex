//
//  MinStar.m
//  DuoDuoM
//
//  Created by Interest on 15/3/5.
//  Copyright (c) 2015年 interest. All rights reserved.
//

#import "MinStar.h"

@implementation MinStar{
    NSMutableArray *stars;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 75, 14) ];
    if (self) {
        stars =[[NSMutableArray alloc]init];
        for (int i=0; i<5; i++) {
            UIImageView *star = [[UIImageView alloc]initWithFrame:CGRectMake(i*15, 0, 13, 13)];
            [self addSubview:star];
            [stars addObject:star];
        }
    }
    return self;
}

-(void)setStarCount:(int)count{
    for (int i=0; i<stars.count; i++) {
        if (i<count) {
            ((UIImageView*)[stars objectAtIndex:i]).image=[UIImage imageNamed:@"评价-星1"];
        }else{
            ((UIImageView*)[stars objectAtIndex:i]).image=[UIImage imageNamed:@"评价-星2"];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
