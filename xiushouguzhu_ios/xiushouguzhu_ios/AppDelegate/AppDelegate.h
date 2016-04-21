//
//  AppDelegate.h
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/11.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AKTabBarController.h"
#import "UserInfo.h"
#import "WXApi.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UserInfo *userInfo;
@property (strong, nonatomic) NSString *sessionId;
@property (assign, nonatomic) BOOL isSIDChange;
@property (assign, nonatomic) BOOL isAppHasNew;
@property (strong, nonatomic) AKTabBarController * akTabBarController;

@end

