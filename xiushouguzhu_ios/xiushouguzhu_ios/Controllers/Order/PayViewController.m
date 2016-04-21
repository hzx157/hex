//
//  PayViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/18.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "PayViewController.h"
#import "HttpService.h"
#import "MD5Create.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "OrderViewController.h"
#import "MyCouponViewController.h"

@interface PayViewController (){
    IBOutlet UILabel *lbPayWay;
    IBOutlet UILabel *lbHao;
    IBOutlet UILabel *lbServerTime;
    IBOutlet UILabel *lbPrices;
    IBOutlet UILabel *lbCoupon;
    IBOutlet UILabel *lbTruePrices;
    IBOutlet UILabel *lbHadCoupon;
    IBOutlet UILabel *lbChooseCoupon;
    IBOutlet UIView *vCoup;
    
    NSMutableArray *arrBtnPayWay;
    
    NSString *serverTime;
    NSString *address;
    NSString *Hao;
    float allPrices;
    float prices;
    int payWayTag;
    NSString *couponCodeHao;
}

@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)choose:(UIButton*)sender {
    payWayTag=(int)sender.tag;
    for (int i=0; i<3; i++) {
        [((UIButton*)[arrBtnPayWay objectAtIndex:i]) setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
    }
    [sender setImage:[UIImage imageNamed:@"选定"] forState:UIControlStateNormal];
}

- (void)pop {
    NSArray *arr = self.navigationController.viewControllers;
    if ([[arr objectAtIndex:arr.count-2] isKindOfClass:[OrderViewController class]]) {
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        OrderViewController *vc=[[OrderViewController alloc]initWithNibName:@"OrderViewController" bundle:nil];
        if (self.ClearBlock&&Hao) {
            self.ClearBlock();
        }
        vc.isPush=YES;
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:NO];
    }

    
//    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"是否放弃付款?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [av show];
}

#pragma mark - Private Methods

- (void)initUI{
    
    self.navigationController.navigationBarHidden=NO;
    self.title=@"订单支付";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"通用-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(weixinPaySuccese)
                                                 name:@"WEIXINPAYSUCCESE"
                                               object:nil];
    
    arrBtnPayWay=[[NSMutableArray alloc]init];
    [SVProgressHUD show];
    if (_isAddTime) {
        [[HttpService sharedInstance]postAddTime:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_AddTime_Order_Detial,@"orderAddEnCrypId":_orderEnCrypId} completionBlock:^(id object) {
            NSArray *arrServerTime=[[[object objectForKey:@"StartTime"]objectForKey:@"Value"] componentsSeparatedByString:@"T"];
            serverTime=[NSString stringWithFormat:@"%@ %@-%@",[arrServerTime objectAtIndex:0],[[arrServerTime objectAtIndex:1]substringToIndex:5],[[[[[object objectForKey:@"EndTime"]objectForKey:@"Value"] componentsSeparatedByString:@"T"]objectAtIndex:1]substringToIndex:5]];
//            address=[[object objectForKey:@"Address"]objectForKey:@"Value"];
            Hao=[[object objectForKey:@"Hao"]objectForKey:@"Value"];
            allPrices=[[[object objectForKey:@"Money"]objectForKey:@"Value"]floatValue];
            couponCodeHao=@"";
            payWayTag=-1;
            lbHao.text=[NSString stringWithFormat:@"续时订单号：%@",Hao];
            lbServerTime.text=[NSString stringWithFormat:@"总服务时间：%@",serverTime];
            lbPrices.text=[NSString stringWithFormat:@"￥%.2f",allPrices];
            lbCoupon.text=@"-0.00";
            lbHadCoupon.text=@"已优惠￥0";
            lbTruePrices.text=lbPrices.text;
            prices=allPrices;
            [SVProgressHUD dismiss];
        } failureBlock:^(NSError *error, NSString *responseString) {
            if(!responseString){
                [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
            }else{
                [SVProgressHUD showErrorWithStatus:responseString];
            }
        }];
    }else{
        [[HttpService sharedInstance]postOrder:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Order_Detial,@"orderEnCrypId":_orderEnCrypId} completionBlock:^(id object) {
            NSArray *arrServerTime=[[[object objectForKey:@"StartTime"]objectForKey:@"Value"] componentsSeparatedByString:@"T"];
            serverTime=[NSString stringWithFormat:@"%@ %@-%@",[arrServerTime objectAtIndex:0],[[arrServerTime objectAtIndex:1]substringToIndex:5],[[[[[object objectForKey:@"EndTime"]objectForKey:@"Value"] componentsSeparatedByString:@"T"]objectAtIndex:1]substringToIndex:5]];
            address=[[object objectForKey:@"Address"]objectForKey:@"Value"];
            Hao=[[object objectForKey:@"Hao"]objectForKey:@"Value"];
            allPrices=[[[object objectForKey:@"AllMoney"]objectForKey:@"Value"]floatValue];
            couponCodeHao=@"";
            payWayTag=-1;
            lbHao.text=[NSString stringWithFormat:@"订单号：%@",Hao];
            lbServerTime.text=[NSString stringWithFormat:@"服务时间：%@",serverTime];
            lbPrices.text=[NSString stringWithFormat:@"￥%.2f",allPrices];
            lbCoupon.text=@"-0.00";
            lbHadCoupon.text=@"已优惠￥0";
            lbTruePrices.text=lbPrices.text;
            prices=allPrices;
            [SVProgressHUD dismiss];
        } failureBlock:^(NSError *error, NSString *responseString) {
            if(!responseString){
                [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
            }else{
                [SVProgressHUD showErrorWithStatus:responseString];
            }
        }];
    }
    if (_isAddTime) {
        vCoup.hidden=YES;
    }else{
        vCoup.hidden=NO;
    }
}

#pragma mark - IBOutlet Methods

- (IBAction)OrderCommit:(id)sender {
    if(payWayTag==-1){
        [SVProgressHUD showErrorWithStatus:@"请先选择支付方式"];
    }else{
        if (_isAddTime) {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            NSLog(@"%@",[NSString stringWithFormat:@"%@%d%@%@",MD5KEY,payWayTag,couponCodeHao,_orderEnCrypId]);
            [[HttpService sharedInstance]postAddTime:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_AddTime_Order_Edit,@"orderAddEnCrypId":_orderEnCrypId,@"payment":[NSString stringWithFormat:@"%d",payWayTag],@"mesdd5enID":[MD5Create stringToMD5Up:[NSString stringWithFormat:@"%@%d%@",MD5KEY,payWayTag,_orderEnCrypId]]} completionBlock:^(id object) {
                [SVProgressHUD dismiss];
                if(payWayTag==0){
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
                    order.tradeNO = [object valueForKey:@"Hao"]; //订单ID（由商家自行制定）
                    order.productName = @"服务"; //商品标题
                    order.productDescription = @"英趣出品"; //商品描述
                    order.amount = [NSString stringWithFormat:@"%.2f",prices]; //商品价格
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
                        
                        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                            if([[resultDic valueForKey:@"resultStatus"]intValue]==9000){
                                [SVProgressHUD showWithStatus:@"支付成功"];
                                NSArray *arr = self.navigationController.viewControllers;
                                if ([[arr objectAtIndex:arr.count-2] isKindOfClass:[OrderViewController class]]) {
                                    [self.navigationController popViewControllerAnimated:NO];
                                }else{
                                    OrderViewController *vc=[[OrderViewController alloc]initWithNibName:@"OrderViewController" bundle:nil];
                                    if (self.ClearBlock&&Hao) {
                                        self.ClearBlock();
                                    }
                                    vc.isSVShow=YES;
                                    vc.isPush=YES;
                                    [vc setHidesBottomBarWhenPushed:YES];
                                    [self.navigationController pushViewController:vc animated:NO];
                                }
//                                [[HttpService sharedInstance]postAddTime:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_AddTime_Order_Pay_Succes,@"orderEnCrypId":_orderEnCrypId,@"pymentState":@"1",@"State":@"7",@"mesdd5enID":[MD5Create stringToMD5Up:[NSString stringWithFormat:@"%@%@71",MD5KEY,_orderEnCrypId]],@"billNumber":[object valueForKey:@"Hao"]} completionBlock:^(id object) {
//                                    
//                                } failureBlock:^(NSError *error, NSString *responseString) {
//                                    if(!responseString){
//                                        [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
//                                    }else{
//                                        [SVProgressHUD showErrorWithStatus:responseString];
//                                    }
//                                }];
                            }
                            switch ([[resultDic valueForKey:@"resultStatus"]intValue]) {
                                case 4000:
                                    [SVProgressHUD showErrorWithStatus:@"支付失败!"];
                                    break;
                                case 6001:
                                    [SVProgressHUD showErrorWithStatus:@"支付已取消!"];
                                    break;
                                case 6002:
                                    [SVProgressHUD showErrorWithStatus:@"网络错误!"];
                                    break;
                                case 8000:
                                    [SVProgressHUD showErrorWithStatus:@"订单正在处理!"];
                                    break;
                                default:
                                    break;
                            }
                        }];
                    }
                }else if (payWayTag==1){
                    NSLog(@"%@",@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_WeiXin_Pay,@"orderType":@"1",@"orderEnCrypId":_orderEnCrypId,@"mesdd5enID":[MD5Create stringToMD5Up:[NSString stringWithFormat:@"%@%@",MD5KEY,_orderEnCrypId]]});
                    [[HttpService sharedInstance]postWeiXin:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_WeiXin_Pay,@"orderType":@"1",@"orderEnCrypId":_orderEnCrypId,@"mesdd5enID":[MD5Create stringToMD5Up:[NSString stringWithFormat:@"%@%@",MD5KEY,_orderEnCrypId]]} completionBlock:^(id object) {
                        
                        //============================================================
                        // V3&V4支付流程实现
                        // 注意:参数配置请查看服务器端Demo
                        // 更新时间：2015年3月3日
                        // 负责人：李启波（marcyli）
                        //============================================================
                        //从服务器获取支付参数，服务端自定义处理逻辑和格式
                        NSDictionary *dicToPay  = [object objectForKey:@"ToPayStr"];
                        //调起微信支付
                        PayReq* req             = [[PayReq alloc] init];
                        req.prepayId            = [object objectForKey:@"PrePayId"];
                        req.partnerId           = [object objectForKey:@"partnerid"];
                        req.openID              = [dicToPay objectForKey:@"appId"];
                        req.nonceStr            = [dicToPay objectForKey:@"nonceStr"];
                        req.timeStamp           = (int)[[dicToPay objectForKey:@"timeStamp"]doubleValue];
                        req.package             = [dicToPay objectForKey:@"package"];
                        req.sign                = [dicToPay objectForKey:@"paySign"];
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
                }else if (payWayTag==2){
                    [SVProgressHUD showSuccessWithStatus:@"余额支付成功~"];
                    NSArray *arr = self.navigationController.viewControllers;
                    if ([[arr objectAtIndex:arr.count-2] isKindOfClass:[OrderViewController class]]) {
                        [self.navigationController popViewControllerAnimated:NO];
                    }else{
                        OrderViewController *vc=[[OrderViewController alloc]initWithNibName:@"OrderViewController" bundle:nil];
                        if (self.ClearBlock&&Hao) {
                            self.ClearBlock();
                        }
                        vc.isSVShow=YES;
                        vc.isPush=YES;
                        [vc setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:vc animated:NO];
                    }
                }
            } failureBlock:^(NSError *error, NSString *responseString) {
                if(!responseString){
                    [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
                }else{
                    [SVProgressHUD showErrorWithStatus:responseString];
                }
            }];
        }else{
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            NSLog(@"%@",[NSString stringWithFormat:@"%@%d%@%@",MD5KEY,payWayTag,couponCodeHao,_orderEnCrypId]);
            [[HttpService sharedInstance]postOrder:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Order_Edit,@"orderEnCrypId":_orderEnCrypId,@"payment":[NSString stringWithFormat:@"%d",payWayTag],@"mesdd5enID":[MD5Create stringToMD5Up:[NSString stringWithFormat:@"%@%d%@%@",MD5KEY,payWayTag,couponCodeHao,_orderEnCrypId]],@"couponCodeHao":couponCodeHao} completionBlock:^(id object) {
                if(payWayTag==0){
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
                    order.tradeNO = [object valueForKey:@"Hao"]; //订单ID（由商家自行制定）
                    order.productName = @"服务"; //商品标题
                    order.productDescription = @"英趣出品"; //商品描述
                    order.amount = [NSString stringWithFormat:@"%.2f",prices]; //商品价格
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
                        
                        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
                        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                            NSLog(@"%@",resultDic);
                            if([[resultDic valueForKey:@"resultStatus"]intValue]==9000){
                                [SVProgressHUD showWithStatus:@"支付成功"];
                                NSArray *arr = self.navigationController.viewControllers;
                                if ([[arr objectAtIndex:arr.count-2] isKindOfClass:[OrderViewController class]]) {
                                    [self.navigationController popViewControllerAnimated:NO];
                                }else{
                                    OrderViewController *vc=[[OrderViewController alloc]initWithNibName:@"OrderViewController" bundle:nil];
                                    if (self.ClearBlock&&Hao) {
                                        self.ClearBlock();
                                    }
                                    vc.isPush=YES;
                                    vc.isSVShow=YES;
                                    [vc setHidesBottomBarWhenPushed:YES];
                                    [self.navigationController pushViewController:vc animated:NO];
                                }
                            }
                            switch ([[resultDic valueForKey:@"resultStatus"]intValue]) {
                                case 4000:
                                    [SVProgressHUD showErrorWithStatus:@"支付失败!"];
                                    break;
                                case 6001:
                                    [SVProgressHUD showErrorWithStatus:@"支付已取消!"];
                                    break;
                                case 6002:
                                    [SVProgressHUD showErrorWithStatus:@"网络错误!"];
                                    break;
                                case 8000:
                                    [SVProgressHUD showErrorWithStatus:@"订单正在处理!"];
                                    break;
                                default:
                                    break;
                            }
                        }];
                    }
                }else if (payWayTag==1){
                    [[HttpService sharedInstance]postWeiXin:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_WeiXin_Pay,@"orderType":@"0",@"orderEnCrypId":_orderEnCrypId,@"mesdd5enID":[MD5Create stringToMD5Up:[NSString stringWithFormat:@"%@%@",MD5KEY,_orderEnCrypId]]} completionBlock:^(id object) {
                        
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
                }else if (payWayTag==2){
                    [SVProgressHUD showSuccessWithStatus:@"余额支付成功~"];
                    NSArray *arr = self.navigationController.viewControllers;
                    if ([[arr objectAtIndex:arr.count-2] isKindOfClass:[OrderViewController class]]) {
                        [self.navigationController popViewControllerAnimated:NO];
                    }else{
                        OrderViewController *vc=[[OrderViewController alloc]initWithNibName:@"OrderViewController" bundle:nil];
                        if (self.ClearBlock&&Hao) {
                            self.ClearBlock();
                        }
                        vc.isSVShow=YES;
                        vc.isPush=YES;
                        [vc setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:vc animated:NO];
                    }
                }
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

- (void)weixinPaySuccese{
    [SVProgressHUD showWithStatus:@"微信支付成功"];
    NSArray *arr = self.navigationController.viewControllers;
    if ([[arr objectAtIndex:arr.count-2] isKindOfClass:[OrderViewController class]]) {
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        OrderViewController *vc=[[OrderViewController alloc]initWithNibName:@"OrderViewController" bundle:nil];
        
        if (self.ClearBlock&&Hao) {
            self.ClearBlock();
        }
        vc.isPush=YES;
        vc.isSVShow=YES;
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:NO];
    }
}


#pragma mark - Gesture Methods

- (IBAction)choosePayWay:(id)sender {
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    
    // Add some custom content to the alert view
    UIView *v=[((NSArray*)([[NSBundle mainBundle] loadNibNamed:@"PayWay" owner:nil options:nil])) objectAtIndex:0];
    [arrBtnPayWay removeAllObjects];
    for (id btn in ((NSArray*)[v subviews])) {
        if ([btn isKindOfClass:[UIButton class]]) {
            [btn addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
            ((UIButton*)btn).layer.borderColor=[[UIColor lightGrayColor]CGColor];
            ((UIButton*)btn).layer.borderWidth=0.5f;
            ((UIButton*)btn).layer.cornerRadius = 10.0f;//圆弧半径
            if (payWayTag==((UIButton*)btn).tag){
                [btn setImage:[UIImage imageNamed:@"选定"] forState:UIControlStateNormal];
            }
            [arrBtnPayWay addObject:btn];
        }
    }
    [alertView setContainerView:v];
    
    // Modify the parameters
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"确定", nil]];
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
//    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
//        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
//        [alertView close];
//    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
}

- (IBAction)chooseCoupon:(id)sender {
    if(!_isAddTime){
        MyCouponViewController *vc =[[MyCouponViewController alloc]init];
        vc.CouponCodeBlock = ^(NSString *Code,float money){
            NSLog(@"%@,,%f",Code,money);
            couponCodeHao=Code;
            lbChooseCoupon.text=[NSString stringWithFormat:@"优惠券号码:%@",couponCodeHao];
            lbCoupon.text=[NSString stringWithFormat:@"-%.2f",money];
            lbHadCoupon.text=[NSString stringWithFormat:@"已优惠￥%.f",money];
            prices=allPrices-money;
            if (prices<0.0) prices=0.0;
            lbTruePrices.text=[NSString stringWithFormat:@"￥%.2f",prices];
        };
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:NO];
    }
}

#pragma mark - CustomIOS7AlertView Methods
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
    [alertView close];
    switch (payWayTag) {
        case 0:
            [lbPayWay setText:@"支付宝支付"];
            break;
        case 1:
            [lbPayWay setText:@"微信支付"];
            break;
        case 2:
            [lbPayWay setText:@"余额支付"];
            break;
            
        default:
            break;
    }
}

#pragma mark - AlertView Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if (self.ClearBlock) {
            self.ClearBlock();
            [self.navigationController popViewControllerAnimated:NO];
            
//            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
//            [[HttpService sharedInstance]postOrder:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Order_Del,@"OrderEnCrypId":_orderEnCrypId} completionBlock:^(id object) {
//                [SVProgressHUD showSuccessWithStatus:@"删除订单成功"];
//                [self.navigationController popViewControllerAnimated:NO];
//            } failureBlock:^(NSError *error, NSString *responseString) {
//                if(!responseString){
//                    [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
//                }else{
//                    [SVProgressHUD showErrorWithStatus:responseString];
//                }
//                [self.navigationController popViewControllerAnimated:NO];
//            }];
        }else if(_isAddTime){
            [self.navigationController popViewControllerAnimated:NO];
//            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
//            [[HttpService sharedInstance]postOrder:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Order_Del_AddTime,@"OrderEnCrypId":_orderEnCrypId} completionBlock:^(id object) {
//                [SVProgressHUD showSuccessWithStatus:@"删除续时订单成功"];
//                [self.navigationController popViewControllerAnimated:NO];
//            } failureBlock:^(NSError *error, NSString *responseString) {
//                if(!responseString){
//                    [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
//                }else{
//                    [SVProgressHUD showErrorWithStatus:responseString];
//                }
//                [self.navigationController popViewControllerAnimated:NO];
//            }];
            
        }else{
            [self.navigationController popViewControllerAnimated:NO];
        }
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
