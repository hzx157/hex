//
//  OpinionViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/31.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "OpinionViewController.h"
#import "HttpService.h"

@interface OpinionViewController (){
    IBOutlet UITextField *lbName;
    IBOutlet UITextView *tvOpinion;
}

@end

@implementation OpinionViewController

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
    self.title=@"意见反馈";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"通用-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    [tvOpinion setPlaceholder:@"请填写您的反馈内容"];
}

#pragma mark - IBOutlet Methods

- (IBAction)btnClick:(UIButton*)sender {
    if(sender.tag==0){
        [SVProgressHUD show];
        [[HttpService sharedInstance]postMore:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_More_Opinion,@"name":lbName.text,@"content":tvOpinion.text} completionBlock:^(id object) {
            [SVProgressHUD showSuccessWithStatus:@"提交成功！感谢您的宝贵意见！我们会做得更好！"];
            [self pop];
        } failureBlock:^(NSError *error, NSString *responseString) {
            if(!responseString){
                [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
            }else{
                [SVProgressHUD showErrorWithStatus:responseString];
            }
        }];
    }else{
        lbName.text=@"";
        tvOpinion.text=@"";
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
