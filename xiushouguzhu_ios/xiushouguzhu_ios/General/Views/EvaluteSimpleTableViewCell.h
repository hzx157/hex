//
//  EvaluteSimpleTableViewCell.h
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/16.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluteSimpleTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbPhone;
@property (strong, nonatomic) IBOutlet UILabel *lbDate;
@property (strong, nonatomic) IBOutlet UILabel *lbContent;

-(void)setStars:(int)count;

@end
