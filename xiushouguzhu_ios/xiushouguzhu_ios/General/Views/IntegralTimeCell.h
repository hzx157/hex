//
//  IntegralTimeCell.h
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/12.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntegralTimeCell : UITableViewCell

@property(strong,nonatomic)IBOutlet UIButton *btnFrom;
@property(strong,nonatomic)IBOutlet UIButton *btnTo;

@property(strong,nonatomic)void (^TagBlock)(int a);

@end
