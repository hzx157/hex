//
//  OrderViewController.h
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/11.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "CommonViewController.h"

@interface OrderViewController : CommonViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (assign,nonatomic) BOOL isSVShow;
@property (assign,nonatomic) BOOL isNoInitData;
@property (assign,nonatomic) BOOL isPush;

@end
