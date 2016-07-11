//
//  BaseViewController.h
//  XiaoWu
//
//  Created by xiaowuxiaowu on 15/11/15.
//  Copyright © 2015年 xiaowuxiaowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong)UIButton *leftBtn;
@property (nonatomic,strong)UIButton *rightBtn;
@property (nonatomic,strong)UIBarButtonItem *rightBtnItem;

/**
 *  显示大量数据的控件
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 *  初始化init的时候设置tableView的样式才有效
 */
@property (nonatomic, assign) UITableViewStyle tableViewStyle;

/**
 *  大量数据的数据源
 */
@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 *  去除iOS7新的功能api，tableView的分割线变成iOS6正常的样式
 */
- (void)configuraTableViewNormalSeparatorInset;

/**
 *  配置tableView右侧的index title 背景颜色，因为在iOS7有白色底色，iOS6没有
 *
 *  @param tableView 目标tableView
 */
- (void)configuraSectionIndexBackgroundColorWithTableView:(UITableView *)tableView;

/**
 *  加载本地或者网络数据源
 */
- (void)loadDataSource;

#pragma mark --- 导航栏左侧按钮点击方法 ---
- (void)leftBtnAction:(UIButton *)sender;
#pragma mark --- 导航栏右侧按钮点击方法 ---
- (void)rightBtnAction:(id )sender;

-(void)hzxEndRefreshingWithPage:(NSInteger)page;
@end
