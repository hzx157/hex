//
//  Util.h
//  Poly
//
//  Created by Interest on 14/11/5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//一些公用的方法

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UserInfo.h"
#import "AppDelegate.h"
@interface Util : NSObject

+(AppDelegate *)shareAppDelegate;
+(void)setDataToRom:(NSDictionary*)dic;
+(NSString *)returnNotNull:(id)content;
+(NSString *) compareCurrentTime:(NSDate*) compareDate;
+(NSString *) hourFromTime:(NSString*)fTime toTime:(NSString*)tTime;
+(NSString *) compareTimeFromTime:(NSString*)fTime toTime:(NSString*)tTime;
+(NSDate *)dateFromString:(NSString *)dateString;
+(NSString *)StringToDate:(NSString *)date;
+(NSArray *) getSevenDay;
+(void)setExtraCellLineHidden: (UITableView *)tableView;
+(void)hideHeader:(UITableView*)tableView;
+(void)call:(NSString*)pnoneNum;

+(NSString *)stateString:(int )state;
@end
