//
//  HzxBarButton.h
//  GPiao
//
//  Created by xiaowuxiaowu on 15/12/27.
//  Copyright © 2015年 xiaowuxiaowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HzxBarButton : UIButton

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点
@end
