//
//  ScanViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/4/8.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "ScanViewController.h"
#import "ZBarSDK.h"
#import "HttpService.h"

@interface ScanViewController ()<ZBarReaderViewDelegate>

@end

@implementation ScanViewController{
    ZBarReaderView *readview;
    UIImageView *discoverView;
    UIImageView *wire;
    UIButton *btnFlash;
    UILabel *lbInfo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI {
    self.navigationItem.title=@"扫描阿姨信息";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"通用-返回.png"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    ZBarImageScanner * scanner = [ZBarImageScanner new];
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    readview = [[ZBarReaderView alloc]initWithImageScanner:scanner]; // 初始化
    readview.readerDelegate = self; // 设置delegate
    readview.allowsPinchZoom = YES; // 使用Pinch手势变焦
    readview.frame=CGRectMake(0, 0, ScreenWidth, ScreenWidth/8*13);
    
    [self.view addSubview:readview];
    discoverView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"二维码-透明板"]];
    discoverView.frame=readview.frame;
    [readview addSubview:discoverView];
    
    wire=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"二维码-扫描条"]];
    
    wire.frame=CGRectMake(discoverView.frame.size.width*0.1719, discoverView.frame.size.height*0.1269, discoverView.frame.size.width*0.6563, 8);
    [readview addSubview:wire];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationRepeatCount:MAXFLOAT];
    [UIView setAnimationDuration:2.5];
    wire.frame=CGRectMake(discoverView.frame.size.width*0.1719, discoverView.frame.size.height*0.5385, discoverView.frame.size.width*0.6563, 8);
    [UIView commitAnimations];
    [readview start];
    readview.torchMode = 0;
}

- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image{ // 得到扫描的条码内容
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    NSString *symbolStr = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)];
    if (zbar_symbol_get_type(symbol) == ZBAR_QRCODE) {
        // 是否QR二维码
        if([symbolStr hasPrefix:@"xiushouApp-{"]&&[symbolStr hasSuffix:@"}-xiushouApp"]){
            NSRange range={12,[symbolStr length]-24};
            symbolStr=[symbolStr substringWithRange:range];
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [[HttpService sharedInstance]post:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Begin_Server,@"userNameCode":symbolStr} completionBlock:^(id object) {
                [SVProgressHUD showSuccessWithStatus:@"扫描成功，开始服务~"];
                [self.navigationController popViewControllerAnimated:NO];
            } failureBlock:^(NSError *error, NSString *responseString) {
                if(!responseString){
                    [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
                }else{
                    [SVProgressHUD showErrorWithStatus:responseString];
                }
            }];
        }else{
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"对不起~这不是阿姨信息二维码~\n扫描到的信息:\n%@",symbolStr]];
        }
    }
}


- (void)pop {
    [self.navigationController popViewControllerAnimated:NO];
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
