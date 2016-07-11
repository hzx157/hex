//
//  UILabel+XWKit.h
//  XWKit
//
//  Created by xiaowuxiaowu on 16/3/26.
//  Copyright © 2016年 xiaowuxiaowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+SuggestSize.h"
@interface UILabel (XWKit)

/**
*  初始化
*
*  @param frame    坐标长宽
*  @param fontSize 文字大小(单位:PT)
*  @param color    颜色
*
*  @return UILabel
*/
+ (instancetype)initWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize color:(UIColor*)color;

/**
 *  初始化
 *
 *  @param frame    坐标长宽
 *  @param fontSize 文字大小(单位:PT)
 *  @param color    颜色
 *  @param aligment 对齐方式
 *
 *  @return UILabel
 */
+ (instancetype)initWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize color:(UIColor*)color aligment:(NSTextAlignment)aligment;

/**
 *  初始化
 *
 *  @param frame 坐标长宽
 *  @param font  字体
 *  @param color 颜色
 *
 *  @return UILabel
 */
+ (instancetype)initWithFrame:(CGRect)frame font:(UIFont*)font color:(UIColor*)color;

/**
 *  初始化
 *
 *  @param frame    坐标长宽
 *  @param font     字体
 *  @param color    颜色
 *  @param aligment 对齐方式
 *
 *  @return UILabel
 */
+ (instancetype)initWithFrame:(CGRect)frame font:(UIFont*)font color:(UIColor*)color aligment:(NSTextAlignment)aligment;

/**
 *  当设置文字时返回label大小
 *
 *  @param text    文字
 *  @param maxSize 最大允许宽高
 *
 *  @return label大小
 */
- (CGSize)getSizeWithSetText:(NSString *)text maxSize:(CGSize)maxSize;

/**
 *  设置单行文本宽度  只设置宽度 高度保持不变
 *
 *  @param text    文字
 *  @param maxSize 最大允许宽高
 */
- (void)setLineText:(NSString *)text maxSize:(CGSize)maxSize;

/**
 *  设置多行文本
 *
 *  @param text    文字
 *  @param maxSize 最大允许宽高
 */
- (void)setMultipleText:(NSString *)text maxSize:(CGSize)maxSize;

/**
 *  设置文字，并直接设置尺寸
 *
 *  @param text    文字
 *  @param maxSize 最大允许宽高
 */
- (void)setText:(NSString *)text maxSize:(CGSize)maxSize;

/**
 *  设置阴影
 *
 *  @param color  颜色
 *  @param offset 偏移 CGSizeMake(1, 1)
 */
- (void)shadowColor:(UIColor *)color offset:(CGSize)offset;

/**
 *  设置阴影 (默认偏移:CGSizeMake(1, 1))
 *
 *  @param color 颜色
 */
- (void)shadowColor:(UIColor *)color;

/**
 *  显示默认阴影 (默认偏移:CGSizeMake(1, 1), 默认颜色:[UIColor blackColor])
 */
- (void)shadowDefault;

/**
 *  获取最佳字体大小
 *
 *  @param font 字体
 *  @param size 希望的大小
 *
 *  @return 最佳字体大小
 */

@end
