//
//  MyMoneyCell.h
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/12.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMoneyCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *money;

@property (strong, nonatomic) void(^RechargeBlock)();

@end
