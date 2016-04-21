//
//  AVOrder.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/17.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "AVOrder.h"

@implementation AVOrder

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if (self != nil) {
       
        // 初始化自定义控件，注意摆放的位置，可以多试几次位置参数直到满意为止
        // createTextField函数用来初始化UITextField控件，在文件末尾附上
//        self._oldPwd = [self createTextField:@"旧密码"
//                                   withFrame:CGRectMake(22, 45, 240, 36)];
//        [self addSubview:self._oldPwd];
//        
//        self._newPwd = [self createTextField:@"新密码"
//                                   withFrame:CGRectMake(22, 90, 240, 36)];
//        [self addSubview:self._newPwd];
//        
//        self._cfmPwd = [self createTextField:@"确认新密码"
//                                   withFrame:CGRectMake(22, 135, 240, 36)];
//        [self addSubview:self._cfmPwd];
    }
    return self;
}
- (void)show{
    [super show];
    NSArray * views = [[NSBundle mainBundle] loadNibNamed:@"AVOrder" owner:nil options:nil];
    UIView * view = views[0];
    view.backgroundColor=[UIColor redColor];
//    [self addSubview:view];
    for (UIView *view in [self subviews])
    {
        NSLog(@"%@",view);
        if ([view isKindOfClass:[UILabel class]]||[view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];     // 当override父类的方法时，要注意一下是否需要调用父类的该方法
    
//    for (UIView* view in self.subviews) {
//        // 搜索AlertView底部的按钮，然后将其位置下移
//        // IOS5以前按钮类是UIButton, IOS5里该按钮类是UIThreePartButton
//        if ([view isKindOfClass:[UIButton class]] ||
//            [view isKindOfClass:NSClassFromString(@"UIThreePartButton")]) {
//            CGRect btnBounds = view.frame;
//            btnBounds.origin.y = self._cfmPwd.frame.origin.y + self._cfmPwd.frame.size.height + 7;
//            view.frame = btnBounds;
//        }
//    }
//    
//    // 定义AlertView的大小
//    CGRect bounds = self.frame;
//    bounds.size.height = 260;
//    self.frame = bounds;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end