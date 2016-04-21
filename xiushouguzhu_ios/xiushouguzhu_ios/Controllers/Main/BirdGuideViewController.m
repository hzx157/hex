//
//  BirdGuideViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/4/9.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "BirdGuideViewController.h"

@interface BirdGuideViewController (){
    
    IBOutlet UITextView *tv;
}

@end

@implementation BirdGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Private Methods

- (void)initUI
{
    self.navigationController.navigationBarHidden=NO;
    self.title=@"新手引导";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"通用-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    tv.layer.cornerRadius=10.0f;
}
/*
    快速响应
    预订袖手阿姨，若家政公司在用户下单后10分钟内未与用户确认订单如何安排，以在线支付金额的100%赔付。
 	例:用户黄小姐在袖手家政预订了钟点工张阿姨，并在线支付了2小时工资。如果黄小姐在10分钟内没有得到订单是否安排好了确切回复，将得到袖手家政相应的赔付。
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
