//
//  OrderItemCell.h
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/12.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderItemCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbType;
@property (strong, nonatomic) IBOutlet UILabel *intervalTime;
@property (strong, nonatomic) IBOutlet UILabel *prices;

@end
