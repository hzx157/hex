//
//  MineViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/11.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "MineViewController.h"
#import "Util.h"
#import "MyIntegralTableViewController.h"
#import "MyInfoViewController.h"
#import "MyMoneyTableViewController.h"
#import "MyCouponViewController.h"
#import "MyCollectionTableViewController.h"
#import "OrderViewController.h"
#import "MyEvaluateTableViewController.h"
#import "ShareViewController.h"
#import "LoginViewController.h"
#import "HttpService.h"


@interface MineViewController (){
    IBOutlet UIView *headView;
    IBOutlet UITableView *tvMine;
    IBOutlet UIButton *btnPhone;
    IBOutlet UIImageView *ivParite;
    
    NSIndexPath *ipPre;
    int numTableViewCount;
}

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    [tvMine deselectRowAtIndexPath:ipPre animated:YES];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (NSString *)tabImageName
{
    return @"首页-标题栏-我(暗)";
}

- (void)initUI
{
    numTableViewCount=7;
    [tvMine setTableHeaderView:headView];
    [Util setExtraCellLineHidden:tvMine];
    [tvMine registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    ivParite.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    ivParite.layer.borderWidth=0.5f;
    ivParite.layer.cornerRadius=30.0f;
    ivParite.layer.masksToBounds=YES;
}

- (void)initData {
    if (((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo) {
        [btnPhone setTitle:((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName forState:UIControlStateNormal];
        numTableViewCount=8;
        [ivParite setImageWithURL:[NSURL URLWithString:((AppDelegate*)[UIApplication sharedApplication].delegate).userInfo.Img]placeholderImage:[UIImage imageNamed:@"我的资料-个人头像"]];
        [tvMine reloadData];
    }else{
        [btnPhone setTitle:@"点击登陆，获取更多精彩" forState:UIControlStateNormal];
        [ivParite setImage:[UIImage imageNamed:@"我的资料-个人头像"]];
        numTableViewCount=7;
        [tvMine reloadData];
    }
}

- (IBAction)login:(id)sender {
    
    if(((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId){
        MyInfoViewController *vc = [[MyInfoViewController alloc]initWithNibName:@"MyInfoViewController" bundle:nil];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:NO];

    }else{
        LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        [vc setHidesBottomBarWhenPushed:YES];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (void)logout{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"是否退出登录?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [av show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [SVProgressHUD show];
        [[HttpService sharedInstance]post:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Logout} completionBlock:^(id object) {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            ((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo=nil;
            ((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId=nil;
            [ud setObject:nil forKey:@"SessionId"];
            [ud setObject:nil forKey:@"userName"];
            ((AppDelegate *)[UIApplication sharedApplication].delegate).isSIDChange=YES;
            [SVProgressHUD showSuccessWithStatus:@"已退出登陆"];
            [self initData];
        } failureBlock:^(NSError *error, NSString *responseString) {
            if(!responseString){
                [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
            }else{
                [SVProgressHUD showErrorWithStatus:responseString];
            }
        }];
    }
    [tvMine deselectRowAtIndexPath:ipPre animated:YES];
}

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section==0 ? 5 : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.textColor=[UIColor darkGrayColor];
    cell.textLabel.textAlignment=NSTextAlignmentLeft;
    cell.textLabel.font=[UIFont systemFontOfSize:17.0];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.imageView.image=nil;//[UIImage imageNamed:@"会员中心-我的资料" ];
                cell.textLabel.text=@"我的资料";
                break;
            case 1:
                cell.imageView.image=nil;//[UIImage imageNamed:@"会员中心-我的订单" ];
                cell.textLabel.text=@"我的订单";
                break;
            case 2:
                cell.imageView.image=nil;//[UIImage imageNamed:@"会员中心-我的余额" ];
                cell.textLabel.text=@"我的余额";
                break;
            case 3:
                cell.imageView.image=nil;//[UIImage imageNamed:@"会员中心-我的优惠券" ];
                cell.textLabel.text=@"我的袖手券";
                break;
            case 4:
                cell.imageView.image=nil;//[UIImage imageNamed:@"会员中心-评论" ];
                cell.textLabel.text=@"我的评论";
                break;
                
            default:
                break;
        }
    }
    else if(indexPath.section == 1) {
        cell.imageView.image=nil;//[UIImage imageNamed:@"分享" ];
        cell.textLabel.text=@"分享";
    }
    else {
        
        cell.imageView.image=nil;
        cell.textLabel.text = [UIManager isLogin] ? @"退出登录": @"登录";
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.textLabel.textColor=[UIColor lightGrayColor];
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.textLabel.font=[UIFont systemFontOfSize:18.0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc;
    if((![UIManager isLogin])&&indexPath.section!=1){
        [SVProgressHUD showInfoWithStatus:@"请先登录"];
        LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        [vc setHidesBottomBarWhenPushed:YES];
        [self presentViewController:vc animated:YES completion:nil];
        return;
    }
    
        
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                    vc=[[MyInfoViewController alloc]initWithNibName:@"MyInfoViewController" bundle:nil];
                    [vc setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:vc animated:NO];
                    break;
                case 1:
                    vc=[[OrderViewController alloc]initWithNibName:@"OrderViewController" bundle:nil];
                    ((OrderViewController*)vc).isPush=YES;
                    [vc setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:vc animated:NO];
                    break;
                case 2:
                    vc=[[MyMoneyTableViewController alloc]initWithNibName:@"MyMoneyTableViewController" bundle:nil];
                    [vc setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:vc animated:NO];
                    break;
                case 3:
                    vc=[[MyCouponViewController alloc]initWithNibName:@"MyCouponViewController" bundle:nil];
                    [vc setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:vc animated:NO];
                    break;
                case 4:
                    vc=[[MyEvaluateTableViewController alloc]initWithNibName:@"MyEvaluateTableViewController" bundle:nil];
                    [vc setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:vc animated:NO];
                    break;
                    
                default:
                    break;
            }
        }
        else if(indexPath.section == 1) {
            vc=[[ShareViewController alloc]initWithNibName:@"ShareViewController" bundle:nil];
            [vc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:vc animated:NO];
        }
        else {
            [self logout];
        }
    
    ipPre=indexPath;
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
