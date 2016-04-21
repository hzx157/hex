//
//  OrderHandleCell.h
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/12.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHandleCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lbHasPay;
@property (strong, nonatomic) IBOutlet UILabel *hasPay;
@property (strong, nonatomic) IBOutlet UILabel *lbPrices;
@property (strong, nonatomic) IBOutlet UILabel *prices;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lcHasPay;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lcLbHasPay;
@property (strong, nonatomic) IBOutlet UIButton *btnScan;
@property (strong, nonatomic) IBOutlet UIButton *btnAddTime;
@property (strong, nonatomic) IBOutlet UIButton *btnEvalute;
@property (strong, nonatomic) IBOutlet UIButton *btnDelOrder;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lcEvalute;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lcAddTime;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lcDelOrder;

@property (strong,nonatomic) IntBlock block;

- (void) waitBlock :(IntBlock) block;

@end
