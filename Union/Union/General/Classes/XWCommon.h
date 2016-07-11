//
//  XWCommon.h
//  XWKitDemo
//
//  Created by xiaowuxiaowu on 16/4/17.
//  Copyright © 2016年 xiaowuxiaowu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
@interface XWCommon : NSObject


/**
 *  正则判断手机号码地址格式
 *
 *  @param mobileNum
 *
 *  @return YES & NO
 */
BOOL xw_isMobileNumber(NSString *mobileNum);

/**
 *  获取storyBoard上的vc
 *
 *  @param identifier identifier
 *  @param title      哪个storyBoard
 *
 *  @return vc
 */
id xw_getController(NSString *identifier,NSString *title);


/**
 *  验证邮箱
 *
 *  @param email 字符串
 *
 *  @return 返回布尔值
 */

BOOL xw_isValidateEmail(NSString *email);

/**
 *  验证md5
 *
 *  @param inPutText
 *
 *  @return md5 之后的值
 */

NSString *xw_md5(NSString *inPutText);


/**
 *  身份证验证
 *
 *  @param sPaperId sPaperId
 *
 *  @return YES & NO
 */
BOOL xw_chk18PaperId(NSString *sPaperId);


/**
 *  空值验证
 *
 *  @param obj obj description
 *
 *  @return 如果是nil 那么返回 @""
 */
NSString *xw_getNULLString(NSObject*obj);


/*-------------------------- 不
  -----------------------------常
   ------------------------------用
     ------------------------------*/

/**
 *  获取视频缩略图
 *
 *  @param videoURL
 *
 *  @return image
 */
+(UIImage *)xw_getVideoImage:(NSString *)videoURL;


/**
 *  DES加密 ：用CCCrypt函数加密一下，然后用base64编码
 *
 *  @param sText
 *  @param key
 *
 *  @return NSString
 */
+ (NSString *)encrypt:(NSString *)sText key:(NSString *)key;




/**
 *  拨打电话
 *
 *  @param phone 手机号码
 *  @param view  显示在哪个View
 */
+(void)getPhoneNuber:(NSString *)phone view:(UIView *)view;


@end
