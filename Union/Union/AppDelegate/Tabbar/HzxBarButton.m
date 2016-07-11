//
//  HzxBarButton.m
//  GPiao
//
//  Created by xiaowuxiaowu on 15/12/27.
//  Copyright © 2015年 xiaowuxiaowu. All rights reserved.
//

#import "HzxBarButton.h"
#define TabbarItemNums 4.0    //tabbar的数量 如果是5个设置为5.0

@implementation HzxBarButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.top = 5;
    self.imageView.width = self.imageView.image.size.width*0.8;
    self.imageView.height = self.imageView.image.size.height*0.75;
    self.imageView.left = (self.width - self.imageView.width)/2.0;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.titleLabel.left = self.imageView.left - (self.titleLabel.width - self.imageView.width)/2.0;
    self.titleLabel.top = self.imageView.bottom + 2;
    
    //+++
    self.titleLabel.width = IPHONE_WIDTH/4;
    self.titleLabel.textAlignment = 1;
    self.titleLabel.frame = CGRectMake(0, self.imageView.bottom+2, IPHONE_WIDTH/4, 24);
    //Me
    
    self.titleLabel.font = fontSystemOfSize(15.0);
    self.titleLabel.shadowColor = [UIColor clearColor];
    
    
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}
//显示小红点
- (void)showBadgeOnItemIndex:(int)index{
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 4;//圆形
    badgeView.backgroundColor = [UIColor redColor];//颜色：红色
//    CGRect tabFrame = self.frame;
    
    //确定小红点的位置
//    float percentX = (index +0.6) / TabbarItemNums;
    CGFloat x = ceilf(self.titleLabel.width/2+10);
    CGFloat y = ceilf(5);
    badgeView.frame = CGRectMake(x, y, 8, 8);//圆形大小为10
    [self addSubview:badgeView];
}
//隐藏小红点
- (void)hideBadgeOnItemIndex:(int)index{
    //移除小红点
    [self removeBadgeOnItemIndex:index];
}
//移除小红点
- (void)removeBadgeOnItemIndex:(int)index{
    //按照tag值进行移除
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888+index) {
            [subView removeFromSuperview];
        }
    }
}

@end
