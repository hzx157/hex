//
//  UserInfo.h
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/19.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (strong,nonatomic) NSString *UserName;//账号
@property (strong,nonatomic) NSString *Name;//真实姓名
@property (strong,nonatomic) NSString *Sex;//性别（0 女1男）
@property (strong,nonatomic) NSString *Phone;//手机号码
@property (strong,nonatomic) NSString *Address;//地址
@property (strong,nonatomic) NSString *Email;//邮箱
@property (strong,nonatomic) NSString *Img;//头像Url

@end
