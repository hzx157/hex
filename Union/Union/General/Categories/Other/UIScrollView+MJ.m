//
//  UIScrollView+MJ.m
//  WuFamily
//
//  Created by xiaowuxiaowu on 15/6/17.
//  Copyright (c) 2015年 xiaowuxiaowu. All rights reserved.
//

#import "UIScrollView+MJ.h"

@implementation UIScrollView (MJ)

-(void)hzxBeginRefreshing
{
    //#warning 自动刷新(一进入程序就下拉刷新)
    [self.mj_header beginRefreshing];
}
- (void)hzxAddLegendHeaderWithRefreshingBlock:(void (^)())block{
      MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
    // 设置文字
    [header setTitle:@"上拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"释放更新" forState:MJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    
    header.arrowView.image = ImageNamed(@"MJ_arrow");
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:14];
     header.lastUpdatedTimeLabel.hidden = YES;
    self.mj_header = header;//[MJRefreshNormalHeader headerWithRefreshingBlock:block];
}
- (void)hzxAddLegendFooterWithRefreshingBlock:(void (^)())block{

    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:block];
     footer.stateLabel.font = [UIFont systemFontOfSize:14];
    [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
    self.mj_footer = footer;
    self.mj_footer.hidden = YES;
  //  [self addLegendFooterWithRefreshingBlock:block];
}

- (void)hzxHiddenFooter:(BOOL)hide  //隐藏footer
{
    self.mj_footer.hidden = hide;
    
}
- (void)hzxHiddenHeader:(BOOL)hide  //隐藏footer
{
    self.mj_header.hidden = hide;
    
}
-(void)hzxHeaderEndRefreshing //结束head
{
    [self.mj_header endRefreshing];
}
-(void)hzxFooterEndRefreshing //结束footer
{
    [self.mj_footer endRefreshing];
    
}

-(void)hzxNoticeNoMoreData{  //没有数据显示出啦u
    [self.mj_footer endRefreshingWithNoMoreData];
}

@end
