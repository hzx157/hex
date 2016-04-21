//
//  EvaluateCell.h
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/12.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluateCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *ivAunt;
@property (strong, nonatomic) IBOutlet UILabel *lbName;
@property (strong, nonatomic) IBOutlet UILabel *lbAge;
@property (strong, nonatomic) IBOutlet UILabel *lbHometown;
@property (strong, nonatomic) IBOutlet UILabel *lbServerTime;
@property (strong, nonatomic) IBOutlet UILabel *lbAddTime;
@property (strong, nonatomic) IBOutlet UILabel *lbContext;


-(void)setStars:(int)count;

@end
