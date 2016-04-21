//
//  PayViewController.h
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/18.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "CommonViewController.h"
#import "CustomIOS7AlertView.h"
#import "WXApi.h"

@interface PayViewController : CommonViewController<CustomIOS7AlertViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)void (^ClearBlock)();
@property (nonatomic,strong) NSString *orderEnCrypId;
@property (nonatomic,assign) BOOL isAddTime;

@end
