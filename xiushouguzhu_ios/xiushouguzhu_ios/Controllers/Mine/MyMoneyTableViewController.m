//
//  MyMoneyTableViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/12.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "MyMoneyTableViewController.h"
#import "Util.h"
#import "MyMoneyCell.h"
#import "IntegralTimeCell.h"
#import "MoneyViewCell.h"
#import "HttpService.h"
#import "CustomIOS7AlertView.h"
#import "MD5Create.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "MJRefresh.h"

@interface MyMoneyTableViewController (){
    IBOutlet UIView *vcSectionHead;
    IBOutletCollection(UIButton) NSArray *MoneyCategory;
    
    UIImageView *ivChoose;
    NSArray *arrBtnPayWay;
    ZHPickView *countPicker;
    
    int Page;
    float money;
    NSString *rechargeMoney;
    int payWayTag;
    NSMutableArray *arrData;
    NSString *strTo;
    NSString *strFrom;
    NSString *strHao;
    int recordTag;
}

@end

@implementation MyMoneyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - IBOutlet Methods
- (IBAction)orderCategory:(UIButton*)sender {
    [UIView animateWithDuration:0.3 animations:^{
        ivChoose.center=CGPointMake(sender.frame.origin.x+sender.frame.size.width/2, ivChoose.center.y);
    }];
    for (UIButton *btn in MoneyCategory) {
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    [[MoneyCategory objectAtIndex:sender.tag]setTitleColor:CommonColor forState:UIControlStateNormal];
    recordTag=(int)sender.tag;
    Page=1;
    [self getRecord];
}

#pragma mark - Private Methods

- (void)initUI
{
    self.navigationController.navigationBarHidden=NO;
    self.title=@"我的余额";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"通用-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(weixinPaySuccese)
                                                 name:@"WEIXINPAYSUCCESE"
                                               object:nil];
    
    arrData = [[NSMutableArray alloc]init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *to = [NSDate dateWithTimeIntervalSinceNow:0];
    strTo = [dateFormatter stringFromDate:to];
    NSDate *from = [NSDate dateWithTimeIntervalSinceNow:-60*60*24*30];
    strFrom = [dateFormatter stringFromDate:from];
    
    [ivChoose removeFromSuperview];
    ivChoose = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"黑底小三角"]];
    ivChoose.frame=CGRectMake(0, 0, 15, 8);
    ivChoose.center=CGPointMake(ScreenWidth/4, 50-4);
    [vcSectionHead addSubview:ivChoose];
    
    [Util setExtraCellLineHidden:self.tableView];
    [Util hideHeader:self.tableView];
    UINib *nib = [UINib nibWithNibName:@"MyMoneyCell" bundle:[NSBundle bundleWithIdentifier:@"MyMoneyCell"]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MyMoneyCell"];
    nib = [UINib nibWithNibName:@"IntegralTimeCell" bundle:[NSBundle bundleWithIdentifier:@"IntegralTimeCell"]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"IntegralTimeCell"];
    nib = [UINib nibWithNibName:@"MoneyViewCell" bundle:[NSBundle bundleWithIdentifier:@"MoneyViewCell"]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MoneyViewCell"];
    nib = nil;
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    Page=1;
    [self initData];
}

- (void)initData {
    [SVProgressHUD show];
    [[HttpService sharedInstance]post:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Money} completionBlock:^(id object) {
        [SVProgressHUD dismiss];
        money=[[object objectForKey:@"money"]floatValue];
        [self.tableView reloadData];
        [self getRecord];
    } failureBlock:^(NSError *error, NSString *responseString) {
        if(!responseString){
            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
        }else{
            [SVProgressHUD showErrorWithStatus:responseString];
        }
    }];
}

- (void)getRecord{
    [SVProgressHUD show];
    if(recordTag==0){
        [[HttpService sharedInstance]postRechargeList:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_RechargeRecord,@"addTimeStart":[NSString stringWithFormat:@"%@",strFrom],@"addTimeEnd":[NSString stringWithFormat:@"%@",strTo],@"Maxlen":@"10",@"Page":[NSString stringWithFormat:@"%d",Page]} completionBlock:^(id object,int count) {
            if ([object isKindOfClass:[NSNull class]]) {
//                [SVProgressHUD showErrorWithStatus:@"没有充值记录哦"];
                [SVProgressHUD dismiss];
                [arrData removeAllObjects];
                [self.tableView reloadData];
            }else{
                if(((NSArray*)object).count==0&&Page!=1){
                    [SVProgressHUD showErrorWithStatus:@"已没有更多数据"];
                    Page--;
                }else{
                    if (Page==1) {
                        [arrData removeAllObjects];
                    }
                    for (int i=0;i<((NSArray*)object).count;i++) {
                        [arrData addObject:@{@"Money":[[[object objectAtIndex:i]valueForKey:@"Money"]valueForKey:@"Value"],@"AddTime":[[[object objectAtIndex:i]valueForKey:@"AddTime"]valueForKey:@"Value"]}];
                    }
                    [self.tableView reloadData];
                    [SVProgressHUD dismiss];
                }
                [self.tableView footerEndRefreshing];
            }
        } failureBlock:^(NSError *error, NSString *responseString) {
            if(!responseString){
                [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
            }else{
                [SVProgressHUD showErrorWithStatus:responseString];
            }
            [self.tableView footerEndRefreshing];
        }];
    }else if (recordTag==1){
        
        [[HttpService sharedInstance]postOrderList:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Order,@"state":@"225",@"addTimeStart":[NSString stringWithFormat:@"%@",strFrom],@"addTimeEnd":[NSString stringWithFormat:@"%@",strTo],@"Maxlen":@"10",@"Page":[NSString stringWithFormat:@"%d",Page]} completionBlock:^(id object,int count) {
            if ([object isKindOfClass:[NSNull class]]) {
                //                [SVProgressHUD showErrorWithStatus:@"没有消费记录哦"];
                [SVProgressHUD dismiss];
                [arrData removeAllObjects];
                [self.tableView reloadData];
            }else{
                if(((NSArray*)object).count==0&&Page!=1){
                    [SVProgressHUD showErrorWithStatus:@"已没有更多数据"];
                    Page--;
                }else{
                    if (Page==1) {
                        [arrData removeAllObjects];
                    }
                    for (int i=0;i<((NSArray*)object).count;i++) {
                        [arrData addObject:@{@"Money":[[object objectAtIndex:i]valueForKey:@"TotalMoney"],@"AddTime":[[[object objectAtIndex:i]valueForKey:@"AddTime"]valueForKey:@"Value"]}];
                    }
                    [self.tableView reloadData];
                    [SVProgressHUD dismiss];
                }
                [self.tableView footerEndRefreshing];
            }
        }failureBlock:^(NSError *error, NSString *responseString) {
            if(!responseString){
                [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
            }else{
                [SVProgressHUD showErrorWithStatus:responseString];
            }
            [self.tableView footerEndRefreshing];
        }];
//        [[HttpService sharedInstance]postMoneyList:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_MoneyLog,@"addTimestar":strFrom,@"addTimeend":strTo,@"Maxlen":@"10",@"Page":[NSString stringWithFormat:@"%d",Page],@"type":@"1"} completionBlock:^(id object,int count) {
//            
//            if ([object isKindOfClass:[NSNull class]]) {
////                [SVProgressHUD showErrorWithStatus:@"没有消费记录哦"];
//                [SVProgressHUD dismiss];
//                [arrData removeAllObjects];
//                [self.tableView reloadData];
//            }else{
//                if(((NSArray*)object).count==0&&Page!=1){
//                    [SVProgressHUD showErrorWithStatus:@"已没有更多数据"];
//                    Page--;
//                }else{
//                    if (Page==1) {
//                        [arrData removeAllObjects];
//                    }
//                    for (int i=0;i<((NSArray*)object).count;i++) {
//                        [arrData addObject:@{@"Money":[[object objectAtIndex:i]valueForKey:@"Money"],@"AddTime":[[object objectAtIndex:i]valueForKey:@"AddTime"]}];
//                    }
//                    [self.tableView reloadData];
//                    [SVProgressHUD dismiss];
//                }
//                [self.tableView footerEndRefreshing];
//            }
//        } failureBlock:^(NSError *error, NSString *responseString) {
//            if(!responseString){
//                [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
//            }else{
//                [SVProgressHUD showErrorWithStatus:responseString];
//            }
//            [self.tableView footerEndRefreshing];
//        }];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        return 94;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        return vcSectionHead;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 2:
            return arrData.count;
            break;
        default:
            return 1;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 50;
            break;
        case 1:
            return 120;
            break;
        default:
            return 37;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (indexPath.section==0) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"MyMoneyCell"];
        ((MyMoneyCell*)cell).money.text=[NSString stringWithFormat:@"%.2f",money];
        ((MyMoneyCell*)cell).RechargeBlock=^{
            UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"请输入充值的金额" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            av.alertViewStyle=UIAlertViewStylePlainTextInput;
            ((UITextField*)[av textFieldAtIndex:0]).keyboardType=UIKeyboardTypeNumbersAndPunctuation;
            ((UITextField*)[av textFieldAtIndex:0]).placeholder=@"请输入充值金额";
            [av show];
        };
    }else if (indexPath.section==1){
        cell=[tableView dequeueReusableCellWithIdentifier:@"IntegralTimeCell"];
        [((IntegralTimeCell*)cell).btnFrom setTitle:strFrom forState:UIControlStateNormal];
        [((IntegralTimeCell*)cell).btnTo setTitle:strTo forState:UIControlStateNormal];
        ((IntegralTimeCell*)cell).TagBlock = ^(int a){
            if (a==0) {
                Page=1;
                [self getRecord];
            }else{
                NSDate *now = [NSDate dateWithTimeIntervalSinceNow:0];
                countPicker=[[ZHPickView alloc] initDatePickWithDate:now datePickerMode:UIDatePickerModeDate dateFormat:@"yyyy-MM-dd" isHaveNavControler:NO];
                countPicker.tag=a;
                countPicker.delegate=self;
                [countPicker show];
            }
        };
    }else{
        cell=[tableView dequeueReusableCellWithIdentifier:@"MoneyViewCell"];
        NSArray *arr=[[[arrData objectAtIndex:indexPath.row]valueForKey:@"AddTime"]componentsSeparatedByString:@"T"];
        ((MoneyViewCell*)cell).lbAddTime.text=[NSString stringWithFormat:@"%@ %@",[arr objectAtIndex:0],[[arr objectAtIndex:1] substringToIndex:5]];
        ((MoneyViewCell*)cell).lbMoney.text=[[[arrData objectAtIndex:indexPath.row]valueForKey:@"Money"]stringValue];
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


#pragma mark - ZHPickView Methods

//选择器回滚事件
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    if (pickView.tag==1) {
        strFrom=resultString;
    }else{
        strTo=resultString;
    }
    [self.tableView reloadData];
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    rechargeMoney=((UITextField*)[alertView textFieldAtIndex:0]).text;
    if (buttonIndex==1&&rechargeMoney&&![rechargeMoney isEqualToString:@""]) {
        CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];

        // Add some custom content to the alert view
        UIView *v=[((NSArray*)([[NSBundle mainBundle] loadNibNamed:@"Recharge" owner:nil options:nil])) objectAtIndex:0];
        arrBtnPayWay=[v subviews];

        for (id lb in ((NSArray*)[v subviews])) {
            if ([lb isKindOfClass:[UIButton class]]) {
                [lb addTarget:self action:@selector(choosePayWay:) forControlEvents:UIControlEventTouchUpInside];
                ((UIButton*)lb).layer.borderColor=[[UIColor lightGrayColor]CGColor];
                ((UIButton*)lb).layer.borderWidth=0.5f;
                ((UIButton*)lb).layer.cornerRadius = 10.0f;//圆弧半径
                if (payWayTag==((UIButton*)lb).tag){
                    [lb setImage:[UIImage imageNamed:@"选定"] forState:UIControlStateNormal];
                }
            }
        }
        [alertView setContainerView:v];
        // Modify the parameters
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];

        
        [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
            if (buttonIndex==1) {
                if(payWayTag==0){
                    [SVProgressHUD show];
                    [[HttpService sharedInstance]post:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Recharge,@"mesdd5enID":[MD5Create stringToMD5Up:[NSString stringWithFormat:@"%@%@",MD5KEY,rechargeMoney]],@"money":rechargeMoney} completionBlock:^(id object) {
                        NSString *partner = @"2088901473345525";
                        NSString *seller = @"tzhang@yo6.me";
                        NSString *privateKey = @"MIICeQIBADANBgkqhkiG9w0BAQEFAASCAmMwggJfAgEAAoGBALty4Fj66jnnbTqn4fq3y31CgBgFCphzucD9LIMv48bV5PkiXehL9odEOT6yXb22m+v268sVZWX+cW41ZVUyysyusThDX9RhZldzrxX9hxy/tdUOCeddHTrmezqhH0l9qJuRFdVjRjSCMdi1jBG7qyBKR/Y1CaY+Lfi+NbspCDOjAgMBAAECgYEAkPL2FRiCQyB4UKE9l9jEXCouT2SmmtjyTQ/5ecBwjHMeSqCOqXEEQ/k3ownefzNUQxV/pFz5OfOV1zknEMjkFCscA7l5gvy184SFFCONOtkUmNVknSBiFEaRYA/IPN8Y8QDc0YrwOWMZ5Wp4uij9eNkOZmerjoholpHaXeJtPiECQQDtx7DwhGz1T9fKWC0DBEH86W6R1++Qc8mDREUTbrKS40G2SVEWMw+bUL7K1J8m+9hQykAqGLl0uFoCukfLueX5AkEAyc/iCoX9qbD2W/pQDmrRRcv5+AU4GZxBUwV2HlKomcasieUa/6qwA3bdlHJCT2FEPnAQjiD5S23ONEJHcVWdewJBAMbH3j/0NTKPYRMjy91tvcy1SV5ba0cTxS8b77NjI55wpgrCGCu63B03z4i5X6Ozfw9rRWDr8n6Fb5pAKK1D5+ECQQCDEFEayH4+8EBu55eKZXDXxWrn2mvepg3+nvNhKgl5JP/05iesluuMtGue9r191AuACUOXKm78v6lFYy4GurV1AkEAo0rdgVMIOBFL83OkCvnfYG14NSidEwbvNXm7ClCkeTlS8fUuvJ7QAPW5VJ4bqqfvcn25YlCuwBpf4JuLX0Elfw==";
                        /*============================================================================*/
                        /*============================================================================*/
                        /*============================================================================*/
                        
                        //partner和seller获取失败,提示
                        if ([partner length] == 0 || [seller length] == 0)
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                            message:@"缺少partner或者seller。"
                                                                           delegate:self
                                                                  cancelButtonTitle:@"确定"
                                                                  otherButtonTitles:nil];
                            [alert show];
                            return;
                        }
                        
                        /*
                         *生成订单信息及签名
                         */
                        //将商品信息赋予AlixPayOrder的成员变量
                        Order *order = [[Order alloc] init];
                        order.partner = partner;
                        order.seller = seller;
                        order.tradeNO = [object valueForKey:@"hao"]; //订单ID（由商家自行制定）
                        order.productName = @"服务"; //商品标题
                        order.productDescription = @"英趣出品"; //商品描述
                        //        order.amount = [self.dataDic valueForKey:@"price"]; //商品价格(记得要乘以数量count)
                        order.amount = rechargeMoney; //商品价格
                        order.notifyURL =  @"http://www.usoiso.com/WeiXinWeb/Pay/Alipay2/notify_url.aspx"; //回调URL
                        
                        order.service = @"mobile.securitypay.pay";
                        order.paymentType = @"1";
                        order.inputCharset = @"utf-8";
                        order.itBPay = @"30m";
                        order.showUrl = @"m.alipay.com";
                        
                        //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
                        NSString *appScheme = @"xiushou";
                        
                        //将商品信息拼接成字符串
                        NSString *orderSpec = [order description];
                        NSLog(@"orderSpec = %@",orderSpec);
                        
                        //    获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
                        
                        id<DataSigner> signer = CreateRSADataSigner(privateKey);
                        NSString *signedString = [signer signString:orderSpec];
                        
                        //将签名成功字符串格式化为订单字符串,请严格按照该格式
                        NSString *orderString = nil;
                        if (signedString != nil) {
                            orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                           orderSpec, signedString, @"RSA"];
                            NSLog(@"orderString,%@,orderString",orderString);
                            
                            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                                if ([[resultDic valueForKey:@"resultStatus"]intValue]==9000) {
                                    [SVProgressHUD showSuccessWithStatus:@"支付成功"];
                                    [self initData];
                                }
                                switch ([[resultDic valueForKey:@"resultStatus"]intValue]) {
                                    case 4000:
                                        [SVProgressHUD showErrorWithStatus:@"支付失败"];
                                        break;
                                    case 6001:
                                        [SVProgressHUD showErrorWithStatus:@"支付已取消"];
                                        break;
                                    case 6002:
                                        [SVProgressHUD showErrorWithStatus:@"网络错误"];
                                        break;
                                    case 8000:
                                        [SVProgressHUD showErrorWithStatus:@"订单正在处理"];
                                        break;
                                    default:
                                        break;
                                }
                            }];
                        }
                    } failureBlock:^(NSError *error, NSString *responseString) {
                        
                        if(!responseString){
                            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
                        }else{
                            [SVProgressHUD showErrorWithStatus:responseString];
                        }
                    }];
                }else if (payWayTag==1){
                    [SVProgressHUD show];
                    [[HttpService sharedInstance]postWeiXin:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_WeiXin_Recharge,@"mesdd5enID":[MD5Create stringToMD5Up:[NSString stringWithFormat:@"%@%@",MD5KEY,rechargeMoney]],@"money":rechargeMoney} completionBlock:^(id object) {

                        //============================================================
                        // V3&V4支付流程实现
                        // 注意:参数配置请查看服务器端Demo
                        // 更新时间：2015年3月3日
                        // 负责人：李启波（marcyli）
                        //============================================================
                        //从服务器获取支付参数，服务端自定义处理逻辑和格式
                        NSDictionary *dicToPay  = [object objectForKey:@"ToPayStr"];
                        //调起微信支付ToPayStr
                        PayReq* req             = [[PayReq alloc] init];
                        req.prepayId            = [object objectForKey:@"PrePayId"];
                        req.partnerId           = [object objectForKey:@"partnerid"];
                        req.openID              = [dicToPay objectForKey:@"appId"];
                        req.nonceStr            = [dicToPay objectForKey:@"nonceStr"];
                        req.timeStamp           = (int)[[dicToPay objectForKey:@"timeStamp"]doubleValue];
                        req.package             = [dicToPay objectForKey:@"package"];
                        req.sign                = [dicToPay objectForKey:@"paySign"];
                        //                        [WXApi sendReq:req];
                        [WXApi safeSendReq:req];
                        
                        [SVProgressHUD dismiss];
                        //日志输出
                        NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",req.openID,req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                        
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
        // You may use a Block, rather than a delegate.

        [alertView setUseMotionEffects:true];

        // And launch the dialog
        [alertView show];
    }
}

- (void)weixinPaySuccese{
    [SVProgressHUD showSuccessWithStatus:@"微信支付成功"];
    [self initData];
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
//    [[HttpService sharedInstance]post:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Recharge,@"orderHao":strHao,@"money":rechargeMoney,@"billNumber":strHao,@"mesdd5enID":[MD5Create stringToMD5Up:[NSString stringWithFormat:@"%@%@",MD5KEY,rechargeMoney]]} completionBlock:^(id object) {
//        [SVProgressHUD showSuccessWithStatus:@"微信支付成功"];
//        [self initData];
//    } failureBlock:^(NSError *error, NSString *responseString) {
//        if(!responseString){
//            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
//        }else{
//            [SVProgressHUD showErrorWithStatus:responseString];
//        }
//    }];
}

- (void)choosePayWay:(UIButton*)sender {
    payWayTag=(int)sender.tag;
    for (int i=0; i<2; i++) {
        [((UIButton*)[arrBtnPayWay objectAtIndex:i]) setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    }
    [((UIButton*)[arrBtnPayWay objectAtIndex:payWayTag]) setImage:[UIImage imageNamed:@"选定"] forState:UIControlStateNormal];
}

-(void)footerRereshing{
    Page++;
    [self getRecord];
}

@end
