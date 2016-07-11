//
//  UILabel+XWKit.m
//  XWKit
//
//  Created by xiaowuxiaowu on 16/3/26.
//  Copyright © 2016年 xiaowuxiaowu. All rights reserved.
//

#import "UILabel+XWKit.h"

@implementation UILabel (XWKit)
/**
*  初始化
*
*  @param frame    坐标长宽
*  @param fontSize 文字大小(单位:PT)
*  @param color    颜色
*
*  @return UILabel
*/
+ (instancetype)initWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize color:(UIColor*)color{
    return [self initWithFrame:frame fontSize:fontSize color:color aligment:NSTextAlignmentLeft];
}

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
+ (instancetype)initWithFrame:(CGRect)frame fontSize:(CGFloat)fontSize color:(UIColor*)color aligment:(NSTextAlignment)aligment{

    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = color;
    label.textAlignment = aligment;
    return label;

}

/**
 *  初始化
 *
 *  @param frame 坐标长宽
 *  @param font  字体
 *  @param color 颜色
 *
 *  @return UILabel
 */
+ (instancetype)initWithFrame:(CGRect)frame font:(UIFont*)font color:(UIColor*)color{
    return [self initWithFrame:frame font:font color:color aligment:NSTextAlignmentLeft];
}

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
+ (instancetype)initWithFrame:(CGRect)frame font:(UIFont*)font color:(UIColor*)color aligment:(NSTextAlignment)aligment{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = font;
    label.textColor = color;
    label.textAlignment = aligment;
    return label;
}

/**
 *  当设置文字时返回label大小
 *
 *  @param text    文字
 *  @param maxSize 最大允许宽高
 *
 *  @return label大小
 */
- (CGSize)getSizeWithSetText:(NSString *)text maxSize:(CGSize)maxSize{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
   CGSize size = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return size;
}

/**
 *  设置单行文本宽度  只设置宽度 高度保持不变
 *
 *  @param text    文字
 *  @param maxSize 最大允许宽高
 */
- (void)setLineText:(NSString *)text maxSize:(CGSize)maxSize{


}

/**
 *  设置多行文本
 *
 *  @param text    文字
 *  @param maxSize 最大允许宽高
 */
- (void)setMultipleText:(NSString *)text maxSize:(CGSize)maxSize{

}

/**
 *  设置文字，并直接设置尺寸
 *
 *  @param text    文字
 *  @param maxSize 最大允许宽高
 */
- (void)setText:(NSString *)text maxSize:(CGSize)maxSize{

}

/**
 *  设置阴影
 *
 *  @param color  颜色
 *  @param offset 偏移 CGSizeMake(1, 1)
 */
- (void)shadowColor:(UIColor *)color offset:(CGSize)offset{

    
}

/**
 *  设置阴影 (默认偏移:CGSizeMake(1, 1))
 *
 *  @param color 颜色
 */
- (void)shadowColor:(UIColor *)color{

}

/**
 *  显示默认阴影 (默认偏移:CGSizeMake(1, 1), 默认颜色:[UIColor blackColor])
 */
- (void)shadowDefault{
}


@end
