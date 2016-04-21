//
//  ShareViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/4/8.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "ShareViewController.h"
#import "HttpService.h"

@interface ShareViewController ()<UIAlertViewDelegate>

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _content=@"家政用袖手，我用真顺手，您不妨也来试试！";
    UIImage *image = [UIImage imageNamed:@"share"];
    NSData *imageViewData = UIImagePNGRepresentation(image);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"share.png"];
    // 将图片写入文件
    [imageViewData writeToFile:fullPath atomically:NO];
    _imagePath=fullPath;
    _theTitle=@"袖手";
    _url=@"https://appsto.re/cn/fVt_6.i";
    _mediaType=SSPublishContentMediaTypeNews;
    
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
    self.title=@"分享";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"通用-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
}

/**
 *分享调用的函数
 *content为分享的内容
 *type为分享的类型
 *path为分享他的图片地址
 **/
-(void)showShare:(NSString *)content ShareType:(int)type ImagePath:(NSString *)path{
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [screenWindow.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageViewData = UIImageJPEGRepresentation(image, 1);
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"screenWindow.jpg"];
    // 将图片写入文件
    [imageViewData writeToFile:fullPath atomically:NO];
    
    if (path==nil) {
        path=fullPath;
    }
    //构造分享内容
//    if (type==ShareTypeSinaWeibo) {
//        content=[content stringByAppendingString:_url];
//    }
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:content
                                                image:[ShareSDK imageWithPath:path]
                                                title:_theTitle
                                                  url:_url
                                          description:@"人人专用"
                                            mediaType:_mediaType];
    
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:content
                                           title:_theTitle
                                             url:_url
                                      thumbImage:[ShareSDK imageWithPath:path]
                                           image:[ShareSDK imageWithPath:path]
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    //    [publishContent addFacebookWithContent:content image:[ShareSDK imageWithPath:fullPath]];
    [ShareSDK shareContent:publishContent type:type authOptions:nil shareOptions:nil statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        
        if (!(type==22||type==23||type==24)) {
            [SVProgressHUD showWithStatus:@"新浪微博分享中...\n请勿再次点击，避免重复分享"];
        }
        NSLog(@"state：%d",state);
        if (state == SSResponseStateSuccess)
        {
            [SVProgressHUD showSuccessWithStatus:@"分享成功"];
            if(((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId){
                [[HttpService sharedInstance]postCoupon:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Share_FirstTime} completionBlock:^(id object) {
                    if ([[object valueForKey:@"isHaveCoupon"]intValue]==1) {
                        [SVProgressHUD showSuccessWithStatus:@"感谢您的分享！成功获取首次分享袖手券!"];
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
        else if (state == SSResponseStateFail)
        {
            NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
            [SVProgressHUD showErrorWithStatus:(@"分享失败:%@", [error errorCode], [error errorDescription])];
        }else{
            [SVProgressHUD dismiss];
        }
    }];
}

#pragma mark - IOutlet Methods
- (IBAction)share:(UIButton*)sender {
    if (sender.tag==0) {
//        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"是否分享袖手至新浪微博？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//        [av show];
        [self showShare:_content ShareType:ShareTypeSinaWeibo ImagePath:_imagePath];
    }else if (sender.tag==1) {
        [self showShare:_content ShareType:ShareTypeWeixiTimeline ImagePath:_imagePath];
    }else if (sender.tag==2) {
        [self showShare:_content ShareType:ShareTypeWeixiSession ImagePath:_imagePath];
    }else if (sender.tag==3) {
        [self showShare:_content ShareType:ShareTypeQQ ImagePath:_imagePath];
    }
}

#pragma mark - AlertView Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self showShare:_content ShareType:ShareTypeSinaWeibo ImagePath:_imagePath];
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
