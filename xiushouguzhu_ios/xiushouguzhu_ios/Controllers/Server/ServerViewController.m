//
//  ServerViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/11.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "ServerViewController.h"
#import "Util.h"
#import "ServerCell.h"
#import "ServerTimeViewController.h"
#import "RecommendTableViewController.h"
#import "AVOrder.h"
#import "PayViewController.h"
#import "HttpService.h"
#import "LoginViewController.h"
#import "MD5Create.h"
#import "OneKeyOrderViewController.h"


@interface ServerViewController (){
    IBOutlet UITableView *tvServer;
    IBOutlet UIImageView *vcBottom;
    
    HZAreaPickerView *locatePicker;
    
    NSTimer *tmAskServer;
    NSString *strLocate;
    NSString *strLocateDetail;
    NSString *strServerTime;
    NSString *strPhone;
    NSString *strClaim;
    NSString *Hao;
    NSString *orderEnCrypId;
    NSString *strAskServer;
    NSString *strId;
    
    float prices;
    float hours;
    int askServerTime;
    
    Boolean isOnekey;
}

@end

@implementation ServerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
 
   
    if (!self.isPush) {
        OneKeyOrderViewController *vc=[[OneKeyOrderViewController alloc]initWithNibName:@"OneKeyOrderViewController" bundle:nil];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:NO];
    }
}


- (void)viewDidAppear:(BOOL)animated{
    
    if (self.isPush) {
        
        [super viewDidAppear:animated];
        vcBottom.hidden=YES;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"通用-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
        
        [SVProgressHUD show];
        [[HttpService sharedInstance]postOrder:@{@"activetype":AT_Order_OneKey_Cost} completionBlock:^(id object) {
            prices=[[object valueForKey:@"prices"]floatValue];
            [[HttpService sharedInstance]postNurseMemberList:@{@"activetype":@"1254"} completionBlock:^(id object,int count) {
                [SVProgressHUD dismiss];
                strId=[[object objectAtIndex:0] valueForKey:@"Id"];
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
        if(((AppDelegate *)[UIApplication sharedApplication].delegate).isSIDChange){
            strServerTime=@"请选择服务时间段";
            strLocateDetail=@"";
            strPhone=@"";
            strClaim=@"";
            Hao=@"";
            if (_NurseMemName) {
                strAskServer=_NurseMemName;
            }else{
                strAskServer=@"系统推荐服务";
                _NurseMemEnCrypId=@"";
            }
            if(!((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.Address||[((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.Address isEqualToString:@""]){
                strLocate=@"请选择服务地点";
                NSIndexPath *ip = [NSIndexPath indexPathForRow:1 inSection:0];
                ServerCell *cell = (ServerCell*)[tvServer cellForRowAtIndexPath:ip];
                cell.tfServer.text = @"";
            }else {
                NSArray *arrLocate=[((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.Address componentsSeparatedByString:@"-"];
                strLocate=[arrLocate objectAtIndex:0];
                NSIndexPath *ip = [NSIndexPath indexPathForRow:1 inSection:0];
                ServerCell *cell = (ServerCell*)[tvServer cellForRowAtIndexPath:ip];
                cell.tfServer.text = [arrLocate objectAtIndex:1];
            }
            if(((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName&&![((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName isEqualToString:@""]){
                NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:2];
                ServerCell *cell = (ServerCell*)[tvServer cellForRowAtIndexPath:ip];
                cell.tfServer.text = ((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName;
            }else{
                NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:2];
                ServerCell *cell = (ServerCell*)[tvServer cellForRowAtIndexPath:ip];
                cell.tfServer.text = @"";
            }
            [tvServer reloadData];
            ((AppDelegate *)[UIApplication sharedApplication].delegate).isSIDChange=NO;
        }
        
    }else{
//        vcBottom.hidden=NO;
//        [self.view bringSubviewToFront:vcBottom];
        
        OneKeyOrderViewController *vc=[[OneKeyOrderViewController alloc]initWithNibName:@"OneKeyOrderViewController" bundle:nil];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:NO];
        ((AppDelegate *)[UIApplication sharedApplication].delegate).akTabBarController.selectedIndex =0;
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - Private Methods

- (NSString *)tabImageName
{
    return @"首页-标题栏-要服务(暗)";
}

- (void)initUI
{
    self.title=@"要服务";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    [Util setExtraCellLineHidden:tvServer];
    [Util hideHeader:tvServer];
    [tvServer registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    UINib *nib = [UINib nibWithNibName:@"ServerCell" bundle:[NSBundle bundleWithIdentifier:@"ServerCell"]];
    [tvServer registerNib:nib forCellReuseIdentifier:@"ServerCell"];
    nib=nil;
    
        strServerTime=@"请选择服务时间段";
        strLocateDetail=@"";
        strPhone=@"";
        strClaim=@"";
        Hao=@"";
        if (_NurseMemName) {
            strAskServer=_NurseMemName;
        }else{
            strAskServer=@"系统推荐服务";
            _NurseMemEnCrypId=@"";
        }
        if(!((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.Address||[((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.Address isEqualToString:@""]){
            strLocate=@"请选择服务地点";
        }else {
            NSArray *arrLocate=[((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.Address componentsSeparatedByString:@"-"];
            strLocate=[arrLocate objectAtIndex:0];
            NSIndexPath *ip = [NSIndexPath indexPathForRow:1 inSection:0];
            ServerCell *cell = (ServerCell*)[tvServer cellForRowAtIndexPath:ip];
            cell.tfServer.text = [arrLocate objectAtIndex:1];
        }
        if(((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName&&![((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName isEqualToString:@""]){
            NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:2];
            ServerCell *cell = (ServerCell*)[tvServer cellForRowAtIndexPath:ip];
            cell.tfServer.text = ((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName;
        }
        [tvServer reloadData];
}

- (void)askServer
{
    [[HttpService sharedInstance]postOrderList:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Order_Allot_Aunt,@"orderEnCrypId":orderEnCrypId} completionBlock:^(id object,int count) {
        [SVProgressHUD dismiss];
        strAskServer=@"已获取推荐服务,请点击进行选择";
        [tvServer reloadData];
    } failureBlock:^(NSError *error, NSString *responseString) {
        strAskServer=[NSString stringWithFormat:@"搜寻服务中(预计%d分钟内完成)",askServerTime>1?--askServerTime:1];
        [tvServer reloadData];
//        if(!responseString){
//            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
//        }else{
//            [SVProgressHUD showErrorWithStatus:responseString];
//        }
    }];
}

- (void)askServerClick
{
    [SVProgressHUD show];
    [[HttpService sharedInstance]postOrderList:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Order_Allot_Aunt,@"orderEnCrypId":orderEnCrypId} completionBlock:^(id object,int count) {
        [SVProgressHUD dismiss];
        strAskServer=@"已获取推荐服务,请点击进行选择";
        [tvServer reloadData];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD dismiss];
        strAskServer=[NSString stringWithFormat:@"搜寻服务中(预计%d分钟内完成)",askServerTime];
        [tvServer reloadData];
    }];
}

- (void)clearData{
    Hao=@"";
    _NurseMemName=nil;
    _NurseMemEnCrypId=@"";
    strAskServer=@"系统推荐服务";
    orderEnCrypId=nil;
    [tmAskServer invalidate];
    [tvServer reloadData];
}

#pragma mark - IBOutlet Methods

- (IBAction)wantServer:(id)sender {
    if(!((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId){
        [SVProgressHUD showInfoWithStatus:@"请先登录"];
        LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        [vc setHidesBottomBarWhenPushed:YES];
        [self presentViewController:vc animated:YES completion:nil];
    }else {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:1 inSection:0];
        ServerCell *cell=(ServerCell*)[tvServer cellForRowAtIndexPath:ip];
        strLocateDetail=cell.tfServer.text;
        ip = [NSIndexPath indexPathForRow:0 inSection:2];
        cell=(ServerCell*)[tvServer cellForRowAtIndexPath:ip];
        strPhone=cell.tfServer.text;
        ip = [NSIndexPath indexPathForRow:1 inSection:3];
        cell=(ServerCell*)[tvServer cellForRowAtIndexPath:ip];
        strClaim=cell.tfServer.text;
        if ([strLocate isEqualToString:@"请选择服务地点"]||[strLocateDetail isEqualToString:@""]||[strPhone isEqualToString:@""]||[strServerTime isEqualToString:@"请选择服务时间段"]) {
            [SVProgressHUD showErrorWithStatus:@"资料尚未完善"];
        }else if(orderEnCrypId){
            CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
            // Add some custom content to the alert view
            UIView *v=[((NSArray*)([[NSBundle mainBundle] loadNibNamed:@"AVOrder" owner:nil options:nil])) objectAtIndex:0];
            for (UILabel *lb in ((NSArray*)[v subviews])) {
                switch (lb.tag) {
                    case 1:
                        lb.text=[NSString stringWithFormat:@"订单号:%@",Hao];
                        break;
                    case 2:
                        lb.text=[NSString stringWithFormat:@"服务时间:%@",strServerTime];
                        break;
                    case 3:
                        lb.text=[NSString stringWithFormat:@"服务地点:%@ %@",strLocate,strLocateDetail];
                        break;
                    case 4:
                        lb.text=[NSString stringWithFormat:@"订单金额:%.2f元",prices*hours];
                        break;
                    case 5:
                        lb.text=[NSString stringWithFormat:@"备注:%@",strClaim];
                        break;
                        
                    default:
                        break;
                }
            }
            [alertView setContainerView:v];
            
            // Modify the parameters
            [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
            
            // You may use a Block, rather than a delegate.
            [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
                NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
                if (buttonIndex==1) {
                    PayViewController *vc = [[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
                    vc.orderEnCrypId=orderEnCrypId;
                    vc.ClearBlock=^{[self clearData];};
                    [vc setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:vc animated:NO];
                }
                [alertView close];
            }];
            
            [alertView setUseMotionEffects:true];
            
            // And launch the dialog
            [alertView show];
        }else{
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [[HttpService sharedInstance]postOrder:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_OrderNum_Create} completionBlock:^(id object) {
                [SVProgressHUD dismiss];
                CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
                UIView *v=[((NSArray*)([[NSBundle mainBundle] loadNibNamed:@"AVOrder" owner:nil options:nil])) objectAtIndex:0];
                for (UILabel *lb in ((NSArray*)[v subviews])) {
                    switch (lb.tag) {
                        case 1:
                            lb.text=[NSString stringWithFormat:@"订单号:%@",[object valueForKey:@"Hao"]];
                            break;
                        case 2:
                            lb.text=[NSString stringWithFormat:@"服务时间:%@",strServerTime];
                            break;
                        case 3:
                            lb.text=[NSString stringWithFormat:@"服务地点:%@ %@",strLocate,strLocateDetail];
                            break;
                        case 4:
                            lb.text=[NSString stringWithFormat:@"订单金额:%.2f元",prices*hours];
                            break;
                        case 5:
                            lb.text=[NSString stringWithFormat:@"备注:%@",strClaim];
                            break;
                            
                        default:
                            break;
                    }
                }
                [alertView setContainerView:v];
                
                // Modify the parameters
                [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
                
                // You may use a Block, rather than a delegate.
                [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
                    if (buttonIndex==1) {
                        if(![_NurseMemEnCrypId isEqualToString:@""]&&!_NurseMemName){
                            PayViewController *vc = [[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
                            vc.orderEnCrypId=orderEnCrypId;
                            vc.ClearBlock=^{[self clearData];};
                            [vc setHidesBottomBarWhenPushed:YES];
                            [self.navigationController pushViewController:vc animated:NO];
                        }else{
                            NSArray *arr=[strServerTime componentsSeparatedByString:@"("];
                            
                            NSString *fromDate=[NSString stringWithFormat:@"%@ %@:00",[arr objectAtIndex:0],[[[[arr objectAtIndex:1]componentsSeparatedByString:@")"]objectAtIndex:1]substringToIndex:5]];
                            NSString *toDate=[NSString stringWithFormat:@"%@ %@:00",[arr objectAtIndex:0],[[[[arr objectAtIndex:1]componentsSeparatedByString:@")"]objectAtIndex:1]substringFromIndex:6]];
                            
                            [SVProgressHUD showWithStatus:@"玩命在提交..." maskType:SVProgressHUDMaskTypeBlack];
                            [[HttpService sharedInstance]postOrder:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Order_Exact,@"address":[NSString stringWithFormat:@"%@ %@",strLocate,strLocateDetail],@"startTime":fromDate,@"endTime":toDate,@"mesdd5enID":[MD5Create stringToMD5Up:[MD5KEY stringByAppendingString:[object valueForKey:@"Hao"
                                                                                                                                                                                                                                                                                                                                                                                                                                                                         ]]],@"hao":[object valueForKey:@"Hao"],@"phone":strPhone,@"NurseMemEnCrypId":_NurseMemEnCrypId,@"Claim":strClaim,@"TradesId":strId} completionBlock:^(id object) {
                                [SVProgressHUD dismiss];                                PayViewController *vc = [[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
                                vc.orderEnCrypId=[object objectForKey:@"EnCrypId"];
                                vc.ClearBlock=^{[self clearData];};
                                [vc setHidesBottomBarWhenPushed:YES];
                                [self.navigationController pushViewController:vc animated:NO];
                            } failureBlock:^(NSError *error, NSString *responseString) {
                                if(!responseString){
                                    [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
                                }else{
                                    [SVProgressHUD showErrorWithStatus:responseString];
                                }
                            }];
                        }
                        
                    }
                    [alertView close];
                }];
                
                [alertView setUseMotionEffects:true];
                
                // And launch the dialog
                [alertView show];
            } failureBlock:^(NSError *error, NSString *responseString) {
                if(!responseString){
                    [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
                }else{
                    [SVProgressHUD showErrorWithStatus:responseString];
                }
            }];
        }
    }
}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidCommitStatus:(NSString *)locate
{
    if([locate hasPrefix:@"广东省 广州市"]){
        strLocate=locate;
        [tvServer reloadData];
        [locatePicker cancelPicker];
    }else{
        [SVProgressHUD showErrorWithStatus:@"该地区暂未开放服务喔~"];
    }
}

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 3:
            return 2;
            break;
            
        default:
            return 1;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.textColor=[UIColor darkGrayColor];
    cell.textLabel.font=[UIFont systemFontOfSize:16.0];
    switch (indexPath.section) {
        case 0:
            if (indexPath.row==0) {
                cell.imageView.image=[UIImage imageNamed:@"要服务-服务地点"];
                cell.textLabel.text=strLocate;
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:@"ServerCell"];
                ((ServerCell*)cell).tfServer.placeholder=@"请填写详细街道";
                ((ServerCell*)cell).ivServer.image=nil;
                ((ServerCell*)cell).tfServer.keyboardType=UIKeyboardTypeDefault;
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
            break;
        case 1:
            cell.imageView.image=[UIImage imageNamed:@"要服务-服务时间段"];
            cell.textLabel.text=strServerTime;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"ServerCell"];
            ((ServerCell*)cell).tfServer.placeholder=@"请填写您的联系电话";
            ((ServerCell*)cell).ivServer.image=[UIImage imageNamed:@"要服务-电话"];
            ((ServerCell*)cell).tfServer.keyboardType=UIKeyboardTypeNumberPad;
            cell.accessoryType=UITableViewCellAccessoryNone;
            break;
        case 3:
            if (indexPath.row==0) {
                cell.imageView.image=[UIImage imageNamed:@"要服务-备注"];
                cell.textLabel.text=@"备注";
                cell.accessoryType=UITableViewCellAccessoryNone;
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:@"ServerCell"];
                ((ServerCell*)cell).tfServer.placeholder=@"请填写您的其他要求";
                ((ServerCell*)cell).ivServer.image=nil;
                ((ServerCell*)cell).tfServer.keyboardType=UIKeyboardTypeDefault;
            }
            break;
        case 4:
            cell.imageView.image=[UIImage imageNamed:@"要服务-系统推荐"];
            cell.textLabel.text=strAskServer;
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textColor=NavColor;
            break;
        default:
            break;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc;
    if (indexPath.section==1) {
        vc = [[ServerTimeViewController alloc]initWithNibName:@"ServerTimeViewController" bundle:nil];
        ((ServerTimeViewController*)vc).isPush=NO;
        ((ServerTimeViewController*)vc).EnCrypId=_NurseMemEnCrypId;
        ((ServerTimeViewController*)vc).IntervalTimeBlock=^(NSString* str){
            
            NSArray *arr= [str componentsSeparatedByString:@","];
            strServerTime=[arr objectAtIndex:1];
            hours=[[arr objectAtIndex:0]floatValue];
            [tvServer reloadData];
        };
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:NO];
    }else if (indexPath.section==4){
        if(!_NurseMemName){
            if(!((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId){
                [SVProgressHUD showInfoWithStatus:@"请先登录"];
                LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
                [vc setHidesBottomBarWhenPushed:YES];
                [self presentViewController:vc animated:YES completion:nil];
            }else {
                NSIndexPath *ip = [NSIndexPath indexPathForRow:1 inSection:0];
                ServerCell *cell=(ServerCell*)[tvServer cellForRowAtIndexPath:ip];
                strLocateDetail=cell.tfServer.text;
                ip = [NSIndexPath indexPathForRow:0 inSection:2];
                cell=(ServerCell*)[tvServer cellForRowAtIndexPath:ip];
                strPhone=cell.tfServer.text;
                ip = [NSIndexPath indexPathForRow:1 inSection:3];
                cell=(ServerCell*)[tvServer cellForRowAtIndexPath:ip];
                strClaim=cell.tfServer.text;
                if ([strLocate isEqualToString:@"请选择服务地点"]||[strLocateDetail isEqualToString:@""]||[strPhone isEqualToString:@""]||[strServerTime isEqualToString:@"请选择服务时间段"]) {
                    [SVProgressHUD showErrorWithStatus:@"资料尚未完善"];
                }else{
                    if(![_NurseMemEnCrypId isEqualToString:@""]){
                        RecommendTableViewController *vc = [[RecommendTableViewController alloc]initWithNibName:@"RecommendTableViewController" bundle:nil];
                        [tmAskServer invalidate];
                        vc.EnCrypId=orderEnCrypId;
                        vc.NurseIDBlock=^(NSString *NurseID,NSString *NurseName){
                            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
                            [[HttpService sharedInstance]postOrder:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Order_Choose_Aunt,@"orderEnCrypId":orderEnCrypId,@"nurseMemEnCrypId":NurseID} completionBlock:^(id object) {
                                [SVProgressHUD showSuccessWithStatus:@"选定阿姨成功"];
                                _NurseMemEnCrypId=NurseID;
                                
                            } failureBlock:^(NSError *error, NSString *responseString) {
                                if(!responseString){
                                    [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
                                }else{
                                    [SVProgressHUD showErrorWithStatus:responseString];
                                }
                            }];
                        };
                        [vc setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:vc animated:NO];
                    }else if([strAskServer isEqualToString:@"系统推荐服务"]){
                        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
                        [[HttpService sharedInstance]postOrder:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_OrderNum_Create} completionBlock:^(id object) {
                            
                            NSArray *arr=[strServerTime componentsSeparatedByString:@"("];
                            
                            NSString *fromDate=[NSString stringWithFormat:@"%@ %@:00",[arr objectAtIndex:0],[[[[arr objectAtIndex:1]componentsSeparatedByString:@")"]objectAtIndex:1]substringToIndex:5]];
                            NSString *toDate=[NSString stringWithFormat:@"%@ %@:00",[arr objectAtIndex:0],[[[[arr objectAtIndex:1]componentsSeparatedByString:@")"]objectAtIndex:1]substringFromIndex:6]];
                            Hao=[object valueForKey:@"Hao"];
                            [[HttpService sharedInstance]postOrder:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Order_Exact,@"address":[NSString stringWithFormat:@"%@ %@",strLocate,strLocateDetail],@"startTime":fromDate,@"endTime":toDate,@"mesdd5enID":[MD5Create stringToMD5Up:[MD5KEY stringByAppendingString:[object valueForKey:@"Hao"]]],@"hao":[object valueForKey:@"Hao"],@"phone":strPhone,@"NurseMemEnCrypId":_NurseMemEnCrypId,@"Claim":strClaim,@"TradesId":strId} completionBlock:^(id object) {
                                [SVProgressHUD dismiss];
                                orderEnCrypId=[object objectForKey:@"EnCrypId"];
                                askServerTime=10;
                                [self askServerClick];
                                tmAskServer = [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(askServer) userInfo:nil repeats:YES];
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
                    }else if ([strAskServer hasPrefix:@"搜寻服务中(预计"]){
                        [self askServerClick];
                    }else if ([strAskServer isEqualToString:@"已获取推荐服务,请点击进行选择"]){
                        RecommendTableViewController *vc = [[RecommendTableViewController alloc]initWithNibName:@"RecommendTableViewController" bundle:nil];
                        [tmAskServer invalidate];
                        vc.EnCrypId=orderEnCrypId;
                        vc.NurseIDBlock=^(NSString *NurseID,NSString *NurseName){
                            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
                            [[HttpService sharedInstance]postOrder:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Order_Choose_Aunt,@"orderEnCrypId":orderEnCrypId,@"nurseMemEnCrypId":NurseID} completionBlock:^(id object) {
                                [SVProgressHUD showSuccessWithStatus:@"选定阿姨成功"];
                                strAskServer=NurseName;
                                _NurseMemEnCrypId=NurseID;
                                [tvServer reloadData];
                            } failureBlock:^(NSError *error, NSString *responseString) {
                                if(!responseString){
                                    [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
                                }else{
                                    [SVProgressHUD showErrorWithStatus:responseString];
                                }
                            }];
                        };
                        [vc setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:vc animated:NO];
                    }
                }
            }
        }
    }
    switch (indexPath.section) {
        case 0:
            if (indexPath.row==0) {
                locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
                [locatePicker showInView:[[[UIApplication sharedApplication] windows] firstObject]];
                [self.view bringSubviewToFront:vcBottom];
            }else{
//                ((ServerCell*)cell).tfServer.placeholder=@"请填写详细街道";
            }
            break;
        case 2:
//            ((ServerCell*)cell).tfServer.placeholder=@"请填写您的联系电话";
            break;
        case 3:
            if (indexPath.row==0) {
//                cell.textLabel.text=@"备注";
            }else{
//                ((ServerCell*)cell).tfServer.placeholder=@"请填写您的其他要求";
            }
            break;
        default:
            break;
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
