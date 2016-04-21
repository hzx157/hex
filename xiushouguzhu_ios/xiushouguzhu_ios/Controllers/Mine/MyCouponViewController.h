//
//  MyCouponViewController.h
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/12.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "CommonViewController.h"

@interface MyCouponViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) void (^CouponCodeBlock)(NSString *code,float money);

@end
