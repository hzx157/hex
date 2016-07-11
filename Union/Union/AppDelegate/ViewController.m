//
//  ViewController.m
//  Union
//
//  Created by xiaowuxiaowu on 16/7/11.
//  Copyright © 2016年 xiaowuxiaowu. All rights reserved.
//

#import "ViewController.h"
#import "HzxTabbar.h"
#import "HzxBarButton.h"
#import "HzxNavigationController.h"

#import "UNUserRootViewController.h"
@interface ViewController ()<HzxTabBarDelegate>{
    
}
@property (nonatomic,weak)HzxTabbar *hzxTabbar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    
    
}
-(void)addTabbar{
    
    HzxTabbar *tabBar = [[HzxTabbar alloc]init];
    self.hzxTabbar = tabBar;
    tabBar.frame = self.tabBar.bounds;
    [tabBar addImageView];
    [self.tabBar addSubview:tabBar];
    tabBar.delegate = self;
    [tabBar addImageView];
    [tabBar addBarButtonWithNorName:@"menu_ex_qtIndex" andDisName:@"menu_ex_qtIndex" andTitle:@"自选股"];
    [tabBar addBarButtonWithNorName:@"menu_fix_gobalmarket" andDisName:@"menu_fix_gobalmarket" andTitle:@"龙虎榜"];
    [tabBar addBarButtonWithNorName:@"menu_ex_paiming" andDisName:@"menu_ex_paiming" andTitle:@"敢死队"];
    [tabBar addBarButtonWithNorName:@"menu_fix_jiaoyi" andDisName:@"menu_fix_jiaoyi" andTitle:@"我的订阅"];
    
    UNUserRootViewController *autoVC = [UNUserRootViewController new];
    UNUserRootViewController *longHuVC = [UNUserRootViewController new];
    UNUserRootViewController *duiVC = [UNUserRootViewController new];
    UNUserRootViewController *meVC = [UNUserRootViewController new];
    
    NSArray *VCArr = @[autoVC,longHuVC,duiVC,meVC];
    NSMutableArray *NumArray = [[NSMutableArray alloc]initWithCapacity:0];
    for(int i=0;i<VCArr.count;i++)
    {
        HzxNavigationController *BussNav = [[HzxNavigationController alloc]initWithRootViewController:VCArr[i]];
        
        [ NumArray addObject:BussNav];
    }
    
    self.viewControllers = NumArray;
    for(UIView *view in self.tabBar.subviews){
        //   NSLog(@"%@",NSStringFromClass([view class]));
        if(![NSStringFromClass([view class]) isEqualToString:@"HzxTabbar"]){
            view.hidden = YES;
            [view removeFromSuperview];
        }
    }
    
    self.selectedIndex = 1;
    
}
-(BOOL)willChangSelIndexForm:(NSInteger)from to:(NSInteger)to{
    

    return YES;
    
}
-(void)ChangSelIndexForm:(NSInteger)from to:(NSInteger)to{
    self.selectedIndex = to;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
