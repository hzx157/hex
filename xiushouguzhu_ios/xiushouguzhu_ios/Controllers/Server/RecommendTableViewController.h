//
//  RecommendTableViewController.h
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/16.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendTableViewController : UITableViewController

@property (nonatomic,strong) void (^NurseIDBlock)(NSString *NurseID,NSString *nurseName);
@property (nonatomic,strong) NSString *EnCrypId;

@end
