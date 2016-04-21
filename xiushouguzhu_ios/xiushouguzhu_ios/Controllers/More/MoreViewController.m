//
//  MoreViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/11.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "MoreViewController.h"
#import "Util.h"
#import "HttpService.h"
#import "OpinionViewController.h"
#import "GradeViewController.h"
#import "PolicyViewController.h"
#import "AboutViewController.h"
#import "CommonQuestionViewController.h"
#import "LoginViewController.h"

@interface MoreViewController()<UIAlertViewDelegate> {
    
    IBOutlet UITableView *tvMore;
    
    NSIndexPath *preIp;
}

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [tvMore deselectRowAtIndexPath:preIp animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (NSString *)tabImageName
{
    return @"首页-标题栏-更多(暗)";
}

- (void)initUI
{
    self.title=@"更多";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [Util setExtraCellLineHidden:tvMore];
    tvMore.layer.cornerRadius=15.0f;
    [tvMore registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"] ;
}

#pragma mark - AlertView data source
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==3) {
        if (buttonIndex==1) {
            [Util call:@"400-8090-224"];
        }
    }
//    else if(alertView.tag==4){
//        if (buttonIndex==1) {
//            NSString *str = [NSString stringWithFormat:
//                             @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@",APP_ID];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//        }
//    }
    [tvMore deselectRowAtIndexPath:preIp animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor=[UIColor darkGrayColor];
    /*
    if(indexPath.row==4){
        if(((AppDelegate *)[UIApplication sharedApplication].delegate).isAppHasNew){
            UIView *vRed = [[UIView alloc]initWithFrame:CGRectMake(90, 24, 10, 10)];
            vRed.backgroundColor=[UIColor redColor];
            vRed.layer.cornerRadius=5.0f;
            [cell addSubview:vRed];
        }
        cell.textLabel.text=@"版本检测";
    }
    */
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text=@"意见反馈";
            break;
        case 1:
            cell.textLabel.text=@"常见问题";
            break;
        case 2:
            cell.textLabel.text=@"给我们评分";
            break;
        case 3:
            cell.textLabel.text=@"袖手专线 400-8090-224";
            break;
//        case 4:
//            cell.textLabel.text=@"版本检测";
//            break;
        case 4:
            cell.textLabel.text=@"条款和政策";
            break;
        case 5:
            cell.textLabel.text=@"关于我们";
            break;
        default:
            break;
    }    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    if(indexPath.row==3){
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"服务热线电话" message:@"\n客服电话：400-8090-224\n\n客服在线时间：8:30-20:30" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨号", nil];
        av.tag=3;
        [av show];
    }
//    else if(indexPath.row==4){
//        [SVProgressHUD showWithStatus:@"获取版本更新中..."];
//        [[HttpService sharedInstance]checkUpdate:APP_ID compleitionBlock:^(BOOL hasNew, NSError *error) {
//            if (hasNew) {
//                [SVProgressHUD dismiss];
//                UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"检测到最新版本!是否前往AppStore更新？" message:nil delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"立即前往", nil];
//                av.tag=4;
//                [av show];
//                ((AppDelegate *)[UIApplication sharedApplication].delegate).isAppHasNew=YES;
//                [tvMore reloadData];
//            }else if(!error){
//                [SVProgressHUD showSuccessWithStatus:@"当前已经是最新版本了"];
//            }else{
//                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
//            }
//        } failureBlock:^(NSError *error, NSString *responseString) {
//            [SVProgressHUD showErrorWithStatus:responseString];
//        }];
//
//    }
    else if(!((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId&&(indexPath.row==0||indexPath.row==2)){
        [SVProgressHUD showInfoWithStatus:@"请先登录"];
        LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        [vc setHidesBottomBarWhenPushed:YES];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        UIViewController *vc;
        switch (indexPath.row) {
            case 0:
                vc=[[OpinionViewController alloc]init];
                [vc setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:vc animated:NO];
                break;
            case 1:
                vc=[[CommonQuestionViewController alloc]init];
                [vc setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:vc animated:NO];
                
                break;
            case 2:
                vc=[[GradeViewController alloc]init];
                [vc setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:vc animated:NO];
                break;
            case 4:
                vc=[[PolicyViewController alloc]init];
                [vc setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:vc animated:NO];
                break;
            case 5:
                vc=[[AboutViewController alloc]init];
                [vc setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:vc animated:NO];
                break;
                
            default:
                break;
        }
    }
    preIp=indexPath;
}

@end
