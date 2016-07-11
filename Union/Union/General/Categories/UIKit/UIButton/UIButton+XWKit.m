//
//  UIButton+XWKit.m
//  XWKit
//
//  Created by xiaowuxiaowu on 16/3/26.
//  Copyright © 2016年 xiaowuxiaowu. All rights reserved.
//

#import "UIButton+XWKit.h"
#import "UIImage+Color.h"
@implementation UIButton (XWKit)
/**
 *  初始化
 *
 *  @param frame     坐标长宽
 *  @param imageName 图片名称
 *
 *  @return 按钮对象
 */
+ (instancetype)buttonWithFrame:(CGRect)frame imageName:(NSString *)imageName{
     return [self buttonWithFrame:frame backgroundImageName:imageName title:@"" capInsets:UIEdgeInsetsZero font:[UIFont systemFontOfSize:17.0]];

}

/**
 *  初始化
 *
 *  @param frame     坐标长宽
 *  @param imageName 背景图片名称
 *
 *  @return 按钮对象
 */
+ (instancetype)buttonWithFrame:(CGRect)frame backgroundImageName:(NSString *)imageName{
   
    return [self buttonWithFrame:frame backgroundImageName:imageName title:@"" capInsets:UIEdgeInsetsZero font:[UIFont systemFontOfSize:17.0]];
}

/**
 *  初始化
 *
 *  @param frame     坐标长宽
 *  @param imageName 背景图片名称
 *  @param title     标题文字
 *  @param capInsets 图片拉伸区域
 *  @param font      字体
 *
 *  @return 按钮对象
 */
+ (instancetype)buttonWithFrame:(CGRect)frame
            backgroundImageName:(NSString *)imageName
                          title:(NSString *)title
                      capInsets:(UIEdgeInsets)capInsets
                           font:(UIFont *)font{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:[[UIImage imageNamed:imageName] imageWithAlignmentRectInsets:capInsets] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    return button;
}

/**
 *  初始化
 *
 *  @param frame 坐标长宽
 *  @param title 标题文字
 *  @param font  字体
 *  @param color 颜色
 *
 *  @return 按钮对象
 */
+ (instancetype)buttonWithFrame:(CGRect)frame
                          title:(NSString *)title
                           font:(UIFont *)font
                          color:(UIColor *)color{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = font;
    [button setTitleColor:color forState:UIControlStateNormal];
    return button;

}

/**
 *  设置属性
 *
 *  @param title     标题文字
 *  @param imageName 背景图片名称
 *  @param capInsets 图片拉伸区域
 */
- (void)setTitle:(NSString *)title backgroundImageName:(NSString *)imageName capInsets:(UIEdgeInsets)capInsets{
    [self setTitle:title forState:UIControlStateNormal];
    [self setBackgroundImage:[[UIImage imageNamed:imageName] imageWithAlignmentRectInsets:capInsets] forState:UIControlStateNormal];
}

/**
 *  设置默认状态标题文字
 *
 *  @param title 标题文字
 */
- (void)setStateNormalTitle:(NSString *)title{
    
  [self setTitle:title forState:UIControlStateNormal];

}

/**
 *  设置默认状态标题颜色
 *
 *  @param color 颜色
 */
- (void)setStateNormalTitleColor:(UIColor *)color{
    
    [self setTitleColor:color forState:UIControlStateNormal];
}

/**
 *  设置默认状态标题阴影颜色
 *
 *  @param color 颜色
 */
- (void)setStateNormalTitleShadowColor:(UIColor *)color{
    
    [self setTitleShadowColor:color forState:UIControlStateNormal];
}

/**
 *  设置默认状态图片
 *
 *  @param image 图片
 */
- (void)setStateNormalImage:(UIImage *)image{
    [self setImage:image forState:UIControlStateNormal];
}

/**
 *  设置默认状态图片
 *
 *  @param name 图片名称
 */
- (void)setStateNormalImageName:(NSString *)name{
  
    [self setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
}

/**
 *  设置默认状态背景
 *
 *  @param image 背景图片
 */
- (void)setStateNormalBackgroundImage:(UIImage *)image{
    [self setBackgroundImage:image forState:UIControlStateNormal];
}

/**
 *  设置默认状态背景图片名称
 *
 *  @param imageName 背景图片名称
 */
- (void)setStateNormalBackgroundImageName:(NSString *)imageName{

    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

/**
 *  设置默认状态背景
 *
 *  @param imageName 背景图片名称
 *  @param capInsets 图片拉伸区域
 */
- (void)setStateNormalBackgroundImageName:(NSString *)imageName capInsets:(UIEdgeInsets)capInsets{
     [self setBackgroundImage:[[UIImage imageNamed:imageName] imageWithAlignmentRectInsets:capInsets] forState:UIControlStateNormal];

}

/**
 *  设置默认状态标题属性
 *
 *  @param title 标题属性
 */
- (void)setStateNormalAttributedTitle:(NSAttributedString *)title{

    self.titleLabel.attributedText = title;

}

/**
 *  设置默认状态图片背景色
 *
 *  @param color 背景色
 */
- (void)setStateNormalBackgroundImageColor:(UIColor *)color{
    [self setBackgroundImageColor:color forState:UIControlStateNormal];
}

/**
 *  设置可以触发事件的背景色
 *
 *  @param imageColor 背景色
 *  @param state      事件状态
 */
- (void)setBackgroundImageColor:(UIColor *)imageColor forState:(UIControlState)state{
    
       [self setBackgroundImage:[UIImage imageWithColor:imageColor] forState:state];
    
}

/**
 *  添加范围内点击事件
 *
 *  @param target 目标对象
 *  @param action 动作
 */
- (void)addTouchUpInsideTarget:(id)target action:(SEL)action{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  垂直居中图片和标题
 *
 *  @param space 图片和标题间距
 */
- (void)centerImageAndTitle:(float)space{

}

@end
