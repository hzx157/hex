//
//  ServerViewController.h
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/11.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "CommonViewController.h"
#import "CustomIOS7AlertView.h"
#import "HZAreaPickerView.h"

@interface ServerViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,HZAreaPickerDelegate>

@property (assign,nonatomic) BOOL isPush;
@property (assign,nonatomic)NSString *NurseMemEnCrypId;
@property (assign,nonatomic)NSString *NurseMemName;

@end
