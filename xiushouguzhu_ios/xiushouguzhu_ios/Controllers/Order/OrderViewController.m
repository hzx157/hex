//
//  OrderViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/11.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "OrderViewController.h"
#import "Util.h"
#import "OrderNumberCell.h"
#import "OrderItemCell.h"
#import "OrderHandleCell.h"
#import "OrderDetailTableViewController.h"
#import "EvaluteSimpleTableViewController.h"
#import "LoginViewController.h"
#import "HttpService.h"
#import "MJRefresh.h"
#import "PayViewController.h"
#import "ScanViewController.h"
#import "ZHPickView.h"


@interface OrderViewController ()<ZHPickViewDelegate,UINavigationControllerDelegate>{
    IBOutlet UITableView *tvOrder;
    IBOutlet UIView *vcSectionHead;
    IBOutletCollection(UIButton) NSArray *orderCategory;
    IBOutlet UIImageView *vcBottom;
    
    UIImageView *ivChoose;
    ZHPickView *countPicker;
    
    int Page;
    NSMutableArray *arrNumItem;
    NSIndexPath *ipPre;
    NSMutableArray *arrListData;
    int state;
    
    NSString *delID;//删除ID
    NSString *delHao;//删除号
    int delSection;//删除Section
    NSString *delName;//阿姨名称
    NSString *hours;//续时时长
}

@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    if (self.isPush) {
        vcBottom.hidden=YES;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"通用-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    }else{
        vcBottom.hidden=NO;
        [self.view bringSubviewToFront:vcBottom];
    }
    [tvOrder deselectRowAtIndexPath:ipPre animated:YES];
    if (!_isNoInitData) {
        Page=1;
        tvOrder.contentOffset=CGPointMake(0, 0);
        [self initData];
    }else{
        [self initData];
//        [tvOrder reloadSections:[NSIndexSet indexSetWithIndex:ipPre.row] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        _isNoInitData=YES;
    }
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pop {
    NSArray *arr = self.navigationController.viewControllers;
    if ([[arr objectAtIndex:arr.count-2] isKindOfClass:[PayViewController class]]) {
        [self.navigationController popToViewController:[arr objectAtIndex:arr.count-3] animated:NO];
    }else{
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - Private Methods
- (NSString *)tabImageName
{
    return @"首页-标题栏-订单(暗)";
}

- (void)initUI
{
    
    arrListData=[[NSMutableArray alloc]init];
    arrNumItem=[[NSMutableArray alloc]init];
    self.title=@"我的订单";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    ivChoose = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"我的订单-小三角"]];
    ivChoose.frame=CGRectMake(0, 0, 15, 8);
    ivChoose.center=CGPointMake(ScreenWidth/6, 50-4);
    [vcSectionHead addSubview:ivChoose];
    [[orderCategory objectAtIndex:0]setTitleColor:CommonColor forState:UIControlStateNormal];
    
    [Util setExtraCellLineHidden:tvOrder];
    [Util hideHeader:tvOrder];
    UINib *nib = [UINib nibWithNibName:@"OrderNumberCell" bundle:[NSBundle bundleWithIdentifier:@"OrderNumberCell"]];
    [tvOrder registerNib:nib forCellReuseIdentifier:@"OrderNumberCell"];
    nib = [UINib nibWithNibName:@"OrderItemCell" bundle:[NSBundle bundleWithIdentifier:@"OrderItemCell"]];
    [tvOrder registerNib:nib forCellReuseIdentifier:@"OrderItemCell"];
    nib = [UINib nibWithNibName:@"OrderHandleCell" bundle:[NSBundle bundleWithIdentifier:@"OrderHandleCell"]];
    [tvOrder registerNib:nib forCellReuseIdentifier:@"OrderHandleCell"];
    nib=nil;
    [tvOrder addHeaderWithTarget:self action:@selector(headerRereshing)];
    [tvOrder addFooterWithTarget:self action:@selector(footerRereshing)];
    
}

-(void)initData{
    if(!((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo){
        [SVProgressHUD showInfoWithStatus:@"请先登录才能查看订单哦" maskType:SVProgressHUDMaskTypeBlack];
        [arrListData removeAllObjects];
        [tvOrder reloadData];
        [tvOrder headerEndRefreshing];
        [tvOrder footerEndRefreshing];
    }else{
        if (!self.isSVShow) {
            self.isSVShow=NO;
        }
        NSLog(@"%@",@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Order,@"state":state==0?@"":(state==1?@"1":@"15"),@"ReviewState":state==2?@"0":@"",@"Maxlen":@"10",@"Page":[NSString stringWithFormat:@"%d",Page]});
        [[HttpService sharedInstance]postOrderList:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Order,@"state":state==0?@"":(state==1?@"1":@"15"),@"ReviewState":state==2?@"0":@"",@"Maxlen":@"10",@"Page":[NSString stringWithFormat:@"%d",Page]} completionBlock:^(id object,int count) {
            
            if ([object isKindOfClass:[NSNull class]]) {
//                [SVProgressHUD showErrorWithStatus:@"您没有这类订单哦"];
                [arrListData removeAllObjects];
                [tvOrder reloadData];
                [SVProgressHUD dismiss];
            }else{
                if(((NSArray*)object).count==0&&Page!=1){
                    [SVProgressHUD showErrorWithStatus:@"已没有更多数据"];
                    Page--;
                }else{
                    if (Page==1) {
                        [arrListData removeAllObjects];
                    }
                    for (int i=0; i<((NSArray*)object).count; i++) {
                        NSDictionary *dic=[object objectAtIndex:i];
                        [arrListData addObject:@{@"Hao":[[dic valueForKey:@"Hao"]valueForKey:@"Value"],@"State":[[dic valueForKey:@"State"]valueForKey:@"Value"],@"IntervalHour":[Util hourFromTime:[[dic valueForKey:@"StartTime"]valueForKey:@"Value"] toTime:[[dic valueForKey:@"EndTime"]valueForKey:@"Value"]],@"ServerTime":[Util compareTimeFromTime:[[dic valueForKey:@"StartTime"]valueForKey:@"Value"] toTime:[[dic valueForKey:@"EndTime"]valueForKey:@"Value"]],@"AllMoney":[[dic valueForKey:@"AllMoney"]valueForKey:@"Value"],@"Address":[[dic valueForKey:@"Address"]valueForKey:@"Value"],@"NurseMemId":[[[dic valueForKey:@"NurseMemId"]valueForKey:@"ClassInfo"]valueForKey:@"EnCrypId"],@"NurseMemName":[dic valueForKey:@"NurseMemName"],@"EnCrypId":[dic valueForKey:@"EnCrypId"],@"Claim":[[dic valueForKey:@"Claim"]valueForKey:@"Value"],@"ReviewState":[[dic valueForKey:@"ReviewState"]valueForKey:@"Value"],@"IsRefundState":[[dic valueForKey:@"IsRefundState"]valueForKey:@"Value"],@"StateInfo":[dic valueForKey:@"StateInfo"],@"orderAddEnCrypId":[dic valueForKey:@"orderAddEnCrypId"],@"IsOrderAdd":[[dic valueForKey:@"IsOrderAdd"]valueForKey:@"Value"],@"ServerAddTime":[Util compareTimeFromTime:[[dic valueForKey:@"OrderAddStartTime"]valueForKey:@"Value"] toTime:[[dic valueForKey:@"OrderAddEndTime"]valueForKey:@"Value"]],@"Money":[[dic valueForKey:@"Money"]valueForKey:@"Value"],@"AddIntervalHour":[Util hourFromTime:[[dic valueForKey:@"OrderAddStartTime"]valueForKey:@"Value"] toTime:[[dic valueForKey:@"OrderAddEndTime"]valueForKey:@"Value"]],@"OrderAddYouHuiMoney":[[dic valueForKey:@"OrderAddYouHuiMoney"]valueForKey:@"Value"],@"ZjMoney":[[dic valueForKey:@"ZjMoney"]valueForKey:@"Value"]}];
                    }
                    [tvOrder reloadData];
                    [SVProgressHUD dismiss];
                }
            }
            [tvOrder headerEndRefreshing];
            [tvOrder footerEndRefreshing];
        } failureBlock:^(NSError *error, NSString *responseString) {
            if(!responseString){
                [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
            }else{
                [SVProgressHUD showErrorWithStatus:responseString];
            }
            [tvOrder headerEndRefreshing];
            [tvOrder footerEndRefreshing];

        }];
    }
}

#pragma mark - IBOutlet Methods
- (IBAction)orderCategory:(UIButton*)sender {
    [UIView animateWithDuration:0.3 animations:^{
        ivChoose.center=CGPointMake(sender.frame.origin.x+sender.frame.size.width/2, ivChoose.center.y);
    }];
    for (UIButton *btn in orderCategory) {
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    [[orderCategory objectAtIndex:sender.tag]setTitleColor:CommonColor forState:UIControlStateNormal];
    Page=1;
    
    state=(int)sender.tag;
    [SVProgressHUD show];
    [self initData];
}

#pragma mark - alertView Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==0) {
        if (buttonIndex==1) {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [[HttpService sharedInstance]postOrder:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Order_Del,@"OrderEnCrypId":delID} completionBlock:^(id object) {
                [SVProgressHUD dismiss];
                [arrListData removeObjectAtIndex:delSection];
                [tvOrder deleteSections:[NSIndexSet indexSetWithIndex:delSection] withRowAnimation:UITableViewRowAnimationAutomatic];
                [tvOrder reloadData];
            } failureBlock:^(NSError *error, NSString *responseString) {
                if(!responseString){
                    [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
                }else{
                    [SVProgressHUD showErrorWithStatus:responseString];
                }
            }];
        }
    }else if (alertView.tag==1) {
        if (buttonIndex==1) {
            [SVProgressHUD showWithStatus:@"玩命在提交..." maskType:SVProgressHUDMaskTypeBlack];
            [[HttpService sharedInstance]postOrder:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Order_AddTime,@"OrderEnCrypId":delID,@"overtime":hours} completionBlock:^(id object) {
                if ([object valueForKey:@"EnCrypId"]&&![[object valueForKey:@"EnCrypId"]isEqualToString:@""]) {
                    [SVProgressHUD showSuccessWithStatus:@"已申请续时"];
                    PayViewController *vc = [[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
                    vc.orderEnCrypId=[object valueForKey:@"EnCrypId"];
                    vc.isAddTime=YES;
                    [vc setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:vc animated:NO];
                }
            } failureBlock:^(NSError *error, NSString *responseString) {
                if(!responseString){
                    [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
                }else{
                    [SVProgressHUD showErrorWithStatus:responseString];
                }
            }];
        }
        
    }else if (alertView.tag==2) {
        if (buttonIndex==1) {
            [SVProgressHUD showWithStatus:@"玩命在提交..." maskType:SVProgressHUDMaskTypeBlack];
            [[HttpService sharedInstance]postOrder:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Order_ApplyRefund,@"OrderEnCrypId":delID} completionBlock:^(id object) {
                [SVProgressHUD showSuccessWithStatus:@"申请成功！请耐心等待后台审核"];
                [self initData];
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


#pragma mark - ZHPickView Methods

//选择器回滚事件
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"是否对服务进行续时" message:[NSString stringWithFormat:@"\n服务阿姨：%@\n续时时长：%@",delName,resultString] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    hours=[resultString substringToIndex:3];
    av.tag=1;
    [av show];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return arrListData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dicData=[arrListData objectAtIndex:section];
    if ([[dicData valueForKey:@"IsOrderAdd"]isEqual:@(1)]) {
        return 5;
    }else {
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dicData=[arrListData objectAtIndex:indexPath.section];
    if([[dicData valueForKey:@"IsOrderAdd"]isEqual:@(1)]?indexPath.row==4:indexPath.row==3){
        return 118;
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dicData=[arrListData objectAtIndex:indexPath.section];
    if (indexPath.row==0) {
        OrderNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderNumberCell"];
        cell.hao.text=[NSString stringWithFormat:@"订单号:%@",[dicData valueForKey:@"Hao"]];
        cell.orderState.text=[dicData valueForKey:@"StateInfo"];
        if([[dicData valueForKey:@"IsRefundState"]intValue]==1){
            cell.orderState.text=@"退款审核中";
        }else if([[dicData valueForKey:@"IsRefundState"]intValue]==10){
            cell.orderState.text=@"退款中";
        }else if([[dicData valueForKey:@"IsRefundState"]intValue]==20){
            cell.orderState.text=@"退款失败";
        }else if([[dicData valueForKey:@"IsRefundState"]intValue]==25){
            cell.orderState.text=@"退款成功";
        }

        return cell;
    } else if ([[dicData valueForKey:@"IsOrderAdd"]isEqual:@(1)]?indexPath.row==4:indexPath.row==3) {
        OrderHandleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderHandleCell"];
        int orderState=[[dicData valueForKey:@"State"]intValue];
        if(orderState>=0&&orderState<=1){
            cell.lbPrices.text=@"需付:";
            cell.prices.text=[NSString stringWithFormat:@"￥%.2f",[[dicData valueForKey:@"AllMoney"]floatValue]];
            cell.lbHasPay.hidden=YES;
            cell.hasPay.hidden=YES;
            cell.lcLbHasPay.constant=0;
            cell.lcHasPay.constant=0;
        }else if(orderState>=2&&orderState<=4){
            cell.lbPrices.text=@"已付:";
            cell.prices.text=[NSString stringWithFormat:@"￥%.2f",[[dicData valueForKey:@"AllMoney"]floatValue]];
            cell.lbHasPay.hidden=YES;
            cell.hasPay.hidden=YES;
            cell.lcLbHasPay.constant=0;
            cell.lcHasPay.constant=0;
        }else if(orderState==5){
            cell.lbHasPay.text=@"代付:";
            cell.hasPay.text=[NSString stringWithFormat:@"￥%.2f",[[dicData valueForKey:@"AllMoney"]floatValue]];
            cell.lbPrices.text=@"需付:";
            cell.prices.text=[NSString stringWithFormat:@"￥%.2f",[[dicData valueForKey:@"ZjMoney"]floatValue]];
            cell.lbHasPay.hidden=NO;
            cell.hasPay.hidden=NO;
            cell.lcLbHasPay.constant=30;
            cell.lcHasPay.constant=70;
            
        }else if(orderState>=6&&orderState<=15){
            cell.lbPrices.text=@"已付:";
            cell.prices.text=[NSString stringWithFormat:@"￥%.2f",[[dicData valueForKey:@"AllMoney"]floatValue]+[[dicData valueForKey:@"ZjMoney"]floatValue]];
            cell.lbHasPay.hidden=YES;
            cell.hasPay.hidden=YES;
            cell.lcLbHasPay.constant=0;
            cell.lcHasPay.constant=0;
        }
        if(orderState<=1){
            cell.btnDelOrder.hidden=NO;
        }else{
            cell.btnDelOrder.hidden=YES;
        }
        if(orderState==3){
            cell.btnScan.hidden=NO;
        }else{
            cell.btnScan.hidden=YES;
        }
        if(orderState==4){
            cell.btnAddTime.alpha=1.0;
        }else{
            cell.btnAddTime.alpha=0.3;
        }
        if(orderState==15){
            if([[dicData valueForKey:@"ReviewState"]intValue]==0){
                [cell.btnEvalute setTitle:@"评价订单" forState:UIControlStateNormal];
            }else{
                [cell.btnEvalute setTitle:@"已评价" forState:UIControlStateNormal];
            }
        }else if(orderState==1||orderState==5){
            [cell.btnEvalute setTitle:@"去付款" forState:UIControlStateNormal];
        }else if(orderState>=2&&orderState<5){
            if([[dicData valueForKey:@"IsRefundState"]intValue]==0){
                [cell.btnEvalute setTitle:@"申请退款" forState:UIControlStateNormal];
            }else if([[dicData valueForKey:@"IsRefundState"]intValue]==1){
                [cell.btnEvalute setTitle:@"退款审核" forState:UIControlStateNormal];
            }else if([[dicData valueForKey:@"IsRefundState"]intValue]==10){
                [cell.btnEvalute setTitle:@"退款中" forState:UIControlStateNormal];
            }else if([[dicData valueForKey:@"IsRefundState"]intValue]==20){
                [cell.btnEvalute setTitle:@"退款失败" forState:UIControlStateNormal];
            }else if([[dicData valueForKey:@"IsRefundState"]intValue]==25){
                [cell.btnEvalute setTitle:@"退款成功" forState:UIControlStateNormal];
            }
        }else{
            [cell.btnEvalute setTitle:@"订单详情" forState:UIControlStateNormal];
        }
        [cell waitBlock:^(int tag) {
            if(tag==0){
                delID=[dicData valueForKey:@"EnCrypId"];
                delHao=[dicData valueForKey:@"Hao"];
                delSection=(int)indexPath.section;
                UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"是否删除订单?" message:[NSString stringWithFormat:@"\n订单号：%@",delHao] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
                av.tag=0;
                [av show];
            }else if(tag==1){
                if(orderState==4){
                    delID=[dicData valueForKey:@"EnCrypId"];
                    delName=[dicData valueForKey:@"NurseMemName"];
                    delSection=(int)indexPath.section;
                    countPicker=[[ZHPickView alloc] initPickviewWithArray:[NSArray arrayWithObjects:@"0.5小时",@"1.0小时",@"1.5小时",@"2.0小时",@"2.5小时",@"3.0小时",@"3.5小时",@"4.0小时",@"4.5小时",@"5.0小时",@"5.5小时",@"6.0小时", nil]isHaveNavControler:NO];
                    countPicker.delegate=self;
                    [countPicker show];
                }
            }else if(tag==2){
//                if (orderState==1) {
//                    PayViewController *vc = [[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
//                    [vc setHidesBottomBarWhenPushed:YES];
//                    [self.navigationController pushViewController:vc animated:NO];
//
//                }
                
                if(orderState==15){
                    OrderDetailTableViewController *vc = [[OrderDetailTableViewController alloc] initWithNibName:@"OrderDetailTableViewController" bundle:nil];
                    vc.dicData=[arrListData objectAtIndex:indexPath.section];
                    [vc setHidesBottomBarWhenPushed:YES];
                    if (self.isPush) {
                        vc.isPush=YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }else {
                        vc.isPush=NO;
                        [self.navigationController pushViewController:vc animated:NO];
                    }
//                        EvaluteSimpleTableViewController *vc = [[EvaluteSimpleTableViewController alloc]initWithNibName:@"EvaluteSimpleTableViewController" bundle:nil];
//                        ((EvaluteSimpleTableViewController*)vc).isPush=self.isPush;
//                        [vc setHidesBottomBarWhenPushed:YES];
//                        if (self.isPush) {
//                            [self.navigationController pushViewController:vc animated:YES];
//                        }else {
//                            [self.navigationController pushViewController:vc animated:NO];
//                        }
                }else if(orderState==1||orderState==5){
                    PayViewController *vc = [[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
                    vc.ClearBlock=nil;
                    if(orderState==5){
                        vc.isAddTime=YES;
                        vc.orderEnCrypId=[dicData valueForKey:@"orderAddEnCrypId"];
                    }else{
                        vc.orderEnCrypId=[dicData valueForKey:@"EnCrypId"];
                    }
                    [vc setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:vc animated:NO];
                }else if(orderState>=2&&orderState<5){
                    
                    if([[dicData valueForKey:@"IsRefundState"]intValue]==0){
                        delID=[dicData valueForKey:@"EnCrypId"];
                        delHao=[dicData valueForKey:@"Hao"];
                        delSection=(int)indexPath.section;
                        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"是否申请退款?" message:[NSString stringWithFormat:@"\n订单号：%@",delHao] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"申请", nil];
                        av.tag=2;
                        [av show];
                    }else{
                        OrderDetailTableViewController *vc = [[OrderDetailTableViewController alloc] initWithNibName:@"OrderDetailTableViewController" bundle:nil];
                        vc.dicData=[arrListData objectAtIndex:indexPath.section];
                        [vc setHidesBottomBarWhenPushed:YES];
                        if (self.isPush) {
                            vc.isPush=YES;
                            [self.navigationController pushViewController:vc animated:YES];
                        }else {
                            vc.isPush=NO;
                            [self.navigationController pushViewController:vc animated:NO];
                        }
                    }
                }else{
                    OrderDetailTableViewController *vc = [[OrderDetailTableViewController alloc] initWithNibName:@"OrderDetailTableViewController" bundle:nil];
                    vc.dicData=[arrListData objectAtIndex:indexPath.section];
                    [vc setHidesBottomBarWhenPushed:YES];
                    if (self.isPush) {
                        vc.isPush=YES;
                        [self.navigationController pushViewController:vc animated:YES];
                    }else {
                        vc.isPush=NO;
                        [self.navigationController pushViewController:vc animated:NO];
                    }
                }

            }else if(tag==3){
                ScanViewController *vc = [[ScanViewController alloc] initWithNibName:@"ScanViewController" bundle:nil];
                self.isSVShow=YES;
                [vc setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:vc animated:NO];
                
            }
        }];
        return cell;
    } else if(indexPath.row==1){
        OrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderItemCell"];
        cell.lbType.text=@"家庭保洁";
        cell.prices.text=[NSString stringWithFormat:@"￥%.2f",[[dicData valueForKey:@"Money"]floatValue]];
        cell.intervalTime.font=[UIFont systemFontOfSize:15.0f];
        cell.intervalTime.text=[dicData valueForKey:@"IntervalHour"];
        return cell;
    }else if([[dicData valueForKey:@"IsOrderAdd"]isEqual:@(1)]?indexPath.row==3:indexPath.row==2){
        OrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderItemCell"];
        cell.lbType.text=@"";
        cell.prices.text=[NSString stringWithFormat:@"总价:￥%.2f",[[dicData valueForKey:@"AllMoney"]floatValue]+[[dicData valueForKey:@"ZjMoney"]floatValue]];
        cell.intervalTime.font=[UIFont systemFontOfSize:13.0f];
        if([[dicData valueForKey:@"OrderAddYouHuiMoney"]floatValue]>0.0){
            cell.intervalTime.text=[NSString stringWithFormat:@"已优惠:￥%.2f",[[dicData valueForKey:@"OrderAddYouHuiMoney"]floatValue]];
        }else{
            cell.intervalTime.text=@"";
        }
        return cell;
    }else{
        OrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderItemCell"];
        cell.lbType.text=@"续时";
        cell.prices.text=[NSString stringWithFormat:@"￥%.2f",[[dicData valueForKey:@"ZjMoney"]floatValue]];
        cell.intervalTime.font=[UIFont systemFontOfSize:15.0f];
        cell.intervalTime.text=[dicData valueForKey:@"AddIntervalHour"];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
//    // Create the next view controller.
    OrderDetailTableViewController *vc = [[OrderDetailTableViewController alloc] initWithNibName:@"OrderDetailTableViewController" bundle:nil];
    vc.dicData=[arrListData objectAtIndex:indexPath.section];
    [vc setHidesBottomBarWhenPushed:YES];
    if (self.isPush) {
        vc.isPush=YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        vc.isPush=NO;
        [self.navigationController pushViewController:vc animated:NO];
    }
    ipPre=indexPath;
//
//    // Pass the selected object to the new view controller.
//    
//    // Push the view controller.
}

-(void)headerRereshing{
    Page=1;
    [self initData];
}

-(void)footerRereshing{
    Page++;
    [self initData];
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
