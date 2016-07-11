//
//  UIView+MBProgressHUD.h
//  XWKit
//
//  Created by xiaowuxiaowu on 16/3/26.
//  Copyright © 2016年 xiaowuxiaowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface UIView (MBProgressHUD)


//单独显示加载菊花不带
-(void )xw_showHUD;
-(void)xw_hideHUD;

//显示加载
-(void)xw_showHUDWithTitle:(NSString *)title;

//进度条
-(void)xw_showHUDWithProgressTitle:(NSString *)title;
-(void)xw_showHUDWorkWithProgress:(CGFloat )progress;

//有图片文字隐藏
-(void)xw_hideHUDafterDelay:(NSString *)title;
//只显示文字
-(void)xw_hideTitle:(NSString *)title;

//隐藏
-(void)xw_hideAfterDelay:(CGFloat)delay;
@end
