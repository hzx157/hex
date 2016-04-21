//
//  FunctionMacros.h
//  ZhuZhu
//
//  Created by Carl on 15/2/2.
//  Copyright (c) 2015年 Vison. All rights reserved.
//

#define ApplicationDelegate  (AppDelegate *)[UIApplication sharedApplication].delegate
#define ResURL(x) [NSString stringWithFormat:@"%@%@",Res_URL_Prefix,x]
//获取设备的物理高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
//获取设备的物理宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
//定义block
typedef void (^CommonBlock)(void);
typedef void (^IntBlock)(int);
typedef void (^StringBlock)(NSString *);