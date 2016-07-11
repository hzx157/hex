//
//  UIScrollView+MJ.h
//  WuFamily
//
//  Created by xiaowuxiaowu on 15/6/17.
//  Copyright (c) 2015年 xiaowuxiaowu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface UIScrollView (MJ)
- (void)hzxBeginRefreshing;  //一进来就开始刷新
- (void)hzxAddLegendHeaderWithRefreshingBlock:(void (^)())block;
- (void)hzxAddLegendFooterWithRefreshingBlock:(void (^)())block;
- (void)hzxHiddenFooter:(BOOL)hide;  ////隐藏footer

-(void)hzxHeaderEndRefreshing; //结束head
-(void)hzxFooterEndRefreshing; //结束footer

-(void)hzxNoticeNoMoreData;////没有数据显示出啦u
- (void)hzxHiddenHeader:(BOOL)hide;
@end
