//
//  HzxNavigationController.m
//  GPiao
//
//  Created by xiaowuxiaowu on 15/12/27.
//  Copyright © 2015年 xiaowuxiaowu. All rights reserved.
//

#import "HzxNavigationController.h"

@implementation HzxNavigationController

-(void)viewDidLoad{
  
    [super viewDidLoad];
 
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(self.viewControllers.count > 0)
        viewController.hidesBottomBarWhenPushed = YES;
    
    [super pushViewController:viewController animated:animated];
    
}
@end
