//
//  RecommendCell.h
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/16.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *ivAuntPhoto;
@property (strong, nonatomic) IBOutlet UILabel *lbName;
@property (strong, nonatomic) IBOutlet UILabel *lbOld;
@property (strong, nonatomic) IBOutlet UILabel *lbYears;
@property (strong, nonatomic) IBOutlet UILabel *lbServerCount;
@property (strong, nonatomic) IBOutlet UILabel *lbHometown;
@property (strong, nonatomic) IBOutlet UILabel *lbDistant;

-(void)setXi:(float)xi;
@end
