//
//  MainViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/11.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "MainViewController.h"
#import "OneKeyOrderViewController.h"
#import "HttpService.h"
#import "Util.h"
#import "GuideViewController.h"
#import "AOScrollerView.h"
#import "MyCouponViewController.h"
#import "GongZhongViewController.h"
#import "ServerAreaViewController.h"
#import "BirdGuideViewController.h"
#import "LoginViewController.h"
#import "SDCycleScrollView.h"

@interface MainViewController ()<ValueClickDelegate>{
    IBOutlet UIView *vcLogo;
    AOScrollerView *aSV;
    
    NSMutableArray * advUrl;
    IBOutlet SDCycleScrollView *topView;
    
    
    IBOutlet UITextField *txtCode;
}

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if([userDefault objectForKey:@"AppStartFirstTime"]==nil){
        
        GuideViewController *gvc=
        [[GuideViewController alloc]initWithNibName:@"GuideViewController" bundle:nil];//[[GuideViewController alloc]init];
        gvc.modalTransitionStyle=UIModalTransitionStyleCrossDissolve;
        [self presentViewController:gvc animated:NO completion:nil];
    }
    
    NSArray *images = @[[UIImage imageNamed:@"banner1.png"],
                       [UIImage imageNamed:@"banner2.png"]
                       ];
    
    topView.infiniteLoop = YES;
    [topView setLocalizationImagesGroup:images];
    topView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    /*
    [[HttpService sharedInstance]checkUpdate:APP_ID compleitionBlock:^(BOOL hasNew, NSError *error) {
        if (hasNew) {
            ((AppDelegate *)[UIApplication sharedApplication].delegate).isAppHasNew=YES;
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
    }];
    */
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private Methods
- (NSString *)tabImageName
{
    return @"首页-标题栏-首页(暗)";
}

- (IBAction)btnExchangePressed:(id)sender {
    
    [txtCode resignFirstResponder];
    
    if(!((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId){
        [SVProgressHUD showInfoWithStatus:@"请先登录"];
        LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        [vc setHidesBottomBarWhenPushed:YES];
        [self presentViewController:vc animated:YES completion:nil];
    }else {
    NSString *hao = [txtCode.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!hao || hao.length <=0) {
        [SVProgressHUD showErrorWithStatus:@"请输入兑换号"];
        return;
    }
    
    [SVProgressHUD show];
    [[HttpService sharedInstance]postCoupon:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":@"887", @"hao":hao} completionBlock:^(id object) {
        
        [SVProgressHUD showSuccessWithStatus:@"您已经成功兑换了一张袖手劵"];
        txtCode.text = @"";
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        if(!responseString){
            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
        }else{
            [SVProgressHUD showErrorWithStatus:responseString];
        }
    }];
    }
    
}

-(IBAction)btnNyCouponPressed:(id)sender {

    [txtCode resignFirstResponder];
    
    if(!((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId){
        [SVProgressHUD showInfoWithStatus:@"请先登录"];
        LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        [vc setHidesBottomBarWhenPushed:YES];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        UIViewController *vc=[[MyCouponViewController alloc]init];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:NO];
    }

}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (txtCode == textField){
        //检测是否为纯数字
        if ([self isPureInt:string]) {
            //添加空格，每4位之后，4组之后不加空格，格式为xxxx xxxx xxxx xxxx xxxxxxxxxxxxxx
            if (textField.text.length % 5 == 4 && textField.text.length < 22) {
                textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
            }
            //只要12位数字
            if ([toBeString length] >= 14)
            {
                toBeString = [toBeString substringToIndex:14];
                txtCode.text = toBeString;
                return NO;
            }
        }
        else if ([string isEqualToString:@""]) { // 删除字符
            if ((textField.text.length - 2) % 5 == 4 && textField.text.length < 22) {
                textField.text = [textField.text substringToIndex:textField.text.length - 1];
            }
            return YES;
        }
        else{
            return NO;
        }
        return YES;
    }
    return YES;
}

- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}



- (void)initUI
{
    [self.navigationItem setTitleView:vcLogo];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
//    [advUrl addObject:@"http://www.baidu.com"];
//    [advUrl addObject:@"http://www.baidu.com"];
//    aSV = [[AOScrollerView alloc]initWithNameArr:[NSMutableArray arrayWithObjects:@"http://youshun.yowbo.cn//Files/201531/7FD9A2327EA3F2E4169EE5F659F9E9BBFF885791.png",@"http://youshun.yowbo.cn//Files/201531/7FD9A2327EA3F2E4169EE5F659F9E9BBFF885791.png", nil] titleArr:nil];
//    aSV.vDelegate=self;
//    [self.view addSubview:aSV];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud objectForKey:@"SessionId"]&&[ud objectForKey:@"userName"]) {
        
       // [SVProgressHUD showWithStatus:@"自动登录中..." maskType:SVProgressHUDMaskTypeBlack];
        [[HttpService sharedInstance]post:@{@"userName":[ud objectForKey:@"userName"],@"sessionId":[ud objectForKey:@"SessionId"],@"activetype":AT_Personal_Info} completionBlock:^(id object) {
            
            [SVProgressHUD dismiss];
            ((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId=[ud objectForKey:@"SessionId"];
            ((AppDelegate *)[UIApplication sharedApplication].delegate).isSIDChange=YES;
            [Util setDataToRom:object];
            
        } failureBlock:^(NSError *error, NSString *responseString) {
            [SVProgressHUD showErrorWithStatus:@"自动登陆失败,请重新登录"];
            ((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId=nil;
            ((AppDelegate *)[UIApplication sharedApplication].delegate).isSIDChange=YES;
        }];
    }
}

#pragma mark - IBOutlet Methods
- (IBAction)oneKey:(id)sender {
    if(!((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId){
        [SVProgressHUD showInfoWithStatus:@"请先登录"];
        LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        [vc setHidesBottomBarWhenPushed:YES];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        OneKeyOrderViewController *vc=[[OneKeyOrderViewController alloc]initWithNibName:@"OneKeyOrderViewController" bundle:nil];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:NO];
    }
}

- (IBAction)fourClick:(UIButton*)sender {
    if(!((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId&&sender.tag==2){
        [SVProgressHUD showInfoWithStatus:@"请先登录"];
        LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        [vc setHidesBottomBarWhenPushed:YES];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        UIViewController *vc;
        switch (sender.tag) {
            case 0:
                vc=[[GongZhongViewController alloc]init];
                break;
            case 1:
                vc=[[ServerAreaViewController alloc]init];
                break;
            case 2:
                vc=[[MyCouponViewController alloc]init];
                break;
            case 3:
                vc=[[BirdGuideViewController alloc]init];
                break;
                
            default:
                break;
        }
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:NO];
    }
}

//#pragma mark - AOScrollerView Methods
//-(void)buttonClick:(int)vid{
//    NSLog(@"链接:%@",[advUrl objectAtIndex:vid]);
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
