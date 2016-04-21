//
//  LoginViewController.h
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/17.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "CommonViewController.h"

@interface LoginViewController : CommonViewController
@property (nonatomic,copy)void (^loginSccuessBlock)(BOOL isSccuess);
@end
