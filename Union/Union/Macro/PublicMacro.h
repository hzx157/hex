//
//  PublicMacro.h
//  XWKitDemo
//
//  Created by xiaowuxiaowu on 16/4/13.
//  Copyright © 2016年 xiaowuxiaowu. All rights reserved.
//

#ifndef PublicMacro_h
#define PublicMacro_h

#define AppShareAppDelegate (AppDelegate*)[[UIApplication sharedApplication]delegate]

#define IPHPNE_HEIGHT      [[UIScreen mainScreen] bounds].size.height  /**-> 整屏高度 */
#define IPHONE_WIDTH       [[UIScreen mainScreen] bounds].size.width   /**-> 整屏宽度 */

//获取系统版本

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

// 加载图片
#define IMAGE_PNG(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define IMAGE_JPG(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define IMAGE_TEXT(NAME, EXT)        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]

#define ImageNamed(_pointer) [UIImage imageNamed:_pointer]
#define WEAKSELF typeof(self) __weak weakSelf = self
#define STRONGSELF typeof(weakSelf) __strong strongSelf = weakSelf


#define IOS7_TOP_Y ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? 64 :0)
#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) // 判断是否是IOS7的系统
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) // 判断是否是IOS7的系统


// 颜色(RGB)
#define COLORRGB(r, g, b)       COLORRGBA(r, g, b, 1.0)
#define COLORRGBA(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
// 随机颜色
#define RANDOM_UICOLOR     [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:1]


/** ->View 圆角和加边框 */
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

/** ->View 圆角 */
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]


// 当前语言
#define CURRENTLANGUAGE         ([[NSLocale preferredLanguages] objectAtIndex:0])

// 本地化字符串
/** NSLocalizedString宏做的其实就是在当前bundle中查找资源文件名“Localizable.strings”(参数:键＋注释) */
#define LocalString(x, ...)     NSLocalizedString(x, nil)
/** NSLocalizedStringFromTable宏做的其实就是在当前bundle中查找资源文件名“xxx.strings”(参数:键＋文件名＋注释) */
#define AppLocalString(x, ...)  NSLocalizedStringFromTable(x, @"someName", nil)

#define  fontSystemOfSize(fone) [UIFont systemFontOfSize:fone]


// 一天的秒数
#define SecondsOfDay            (24.f * 60.f * 60.f)
// 秒数
#define Seconds(Days)           (SecondsOfDay * (Days))
// 一天的毫秒数
#define MillisecondsOfDay       (SecondsOfDay * 1000.f)
// 毫秒数
#define Milliseconds(Days)      (SecondsOfDay * 1000.f * (Days))


// app 信息
#define APP_STORE_URL       @"itms-apps://itunes.apple.com/us/app/xiong-zhao/id1020593660?l=zh&ls=1&mt=8"
#define APP_STORE_INFO_URL  @"https://itunes.apple.com/cn/lookup?id=1020593660"
#define VERSION             [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]


// 自定义NSLog,在debug模式下打印，在release模式下取消一切NSLog
#ifdef DEBUG
#define DLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define DLog(FORMAT, ...) nil
#endif


//检测block 是否存在
#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

#endif /* PublicMacro_h */
