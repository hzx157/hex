//
//  AboutViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/31.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "AboutViewController.h"
#import "HttpService.h"
#import "Util.h"

@interface AboutViewController (){
    IBOutlet UITextView *tv;
    
}

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    self.title=@"关于我们";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"通用-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    tv.layer.cornerRadius=10.0f;
    
//    [SVProgressHUD show];
//    [[HttpService sharedInstance]postMore:@{@"typeInfo":@"aboutUsApp",@"activetype":AT_More_Get} completionBlock:^(id object) {
//        [SVProgressHUD dismiss];
//         NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[[Util returnNotNull:[object objectForKey:@"Content"]] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//        tv.attributedText=attrStr;
//    } failureBlock:^(NSError *error, NSString *responseString) {
//        if(!responseString){
//            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
//        }else{
//            [SVProgressHUD showErrorWithStatus:responseString];
//        }
//    }];
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
