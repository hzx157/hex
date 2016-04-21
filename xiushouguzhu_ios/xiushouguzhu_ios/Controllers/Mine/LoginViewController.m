//
//  LoginViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/17.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "LoginViewController.h"
#import "HttpService.h"
#import "Util.h"

@interface LoginViewController (){
    IBOutlet UITextField *tfAcount;
    IBOutlet UITextField *tfPassword;
    
//    int checkcode;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)initUI
{
    self.title=@"登录";
}

#pragma mark - IBOutlet

- (IBAction)getCheckNum:(id)sender {
    [SVProgressHUD showWithStatus:@"获取验证码中..." maskType:SVProgressHUDMaskTypeBlack];
    [[HttpService sharedInstance]post:@{@"phone":tfAcount.text,@"activetype":AT_LoginFirst} completionBlock:^(id object) {
        [SVProgressHUD showSuccessWithStatus:@"获取成功，请留意手机短信，并输入验证码"];
    } failureBlock:^(NSError *error, NSString *responseString) {
        if(!responseString){
            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
        }else{
            [SVProgressHUD showErrorWithStatus:responseString];
        }
    }];
}

- (IBAction)login:(id)sender {
    [SVProgressHUD showWithStatus:@"登录中..." maskType:SVProgressHUDMaskTypeBlack];
    
    [[HttpService sharedInstance]post:@{@"phone":tfAcount.text,@"code":tfPassword.text,@"activetype":AT_LoginSecond} completionBlock:^(id object) {
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        ((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId=[object valueForKey:@"SessionId"];
        [ud setObject:[object valueForKey:@"SessionId"] forKey:@"SessionId"];
        [ud setObject:tfAcount.text forKey:@"userName"];
        
        [[HttpService sharedInstance]post:@{@"userName":tfAcount.text,@"sessionId":[object valueForKey:@"SessionId"],@"activetype":AT_Personal_Info} completionBlock:^(id object) {
            
            [Util setDataToRom:object];
            ((AppDelegate *)[UIApplication sharedApplication].delegate).isSIDChange=YES;
            [SVProgressHUD showSuccessWithStatus:@"登陆成功！"];
            
            if(self.loginSccuessBlock)
            self.loginSccuessBlock(YES);
            
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } failureBlock:^(NSError *error, NSString *responseString) {
            
         
            
            
            if(!responseString){
                [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
            }else{
                [SVProgressHUD showErrorWithStatus:responseString];
            }
        }];
    } failureBlock:^(NSError *error, NSString *responseString) {
        if(!responseString){
            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
        }else{
            [SVProgressHUD showErrorWithStatus:responseString];
        }
    }];
}

- (IBAction)pop:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
