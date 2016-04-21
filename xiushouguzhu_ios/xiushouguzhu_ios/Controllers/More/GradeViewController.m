//
//  GradeViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/31.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "GradeViewController.h"
#import "HttpService.h"

@interface GradeViewController (){
    
    IBOutletCollection(UIButton) NSArray *star;
    IBOutlet UITextView *tvGradeText;
    
    int Fen;
}

@end

@implementation GradeViewController

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
    self.title=@"给我们评分";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"通用-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    [tvGradeText setPlaceholder:@"请填写您的评分内容"];
}

#pragma mark - IBOutlet Methods

- (IBAction)starClick:(UIButton *)sender {
    Fen=(int)sender.tag+1;
    for (int i=0; i<star.count; i++) {
        if (i<(int)sender.tag+1) {
            [((UIButton*)[star objectAtIndex:i]) setBackgroundImage:[UIImage imageNamed:@"评价-星1"] forState:UIControlStateNormal];
        }else{
            [((UIButton*)[star objectAtIndex:i]) setBackgroundImage:[UIImage imageNamed:@"评价-星2"] forState:UIControlStateNormal];
        }
    }
}

- (IBAction)commit:(id)sender {
    if (Fen==0) {
        [SVProgressHUD showErrorWithStatus:@"请先进行评分"];
    }else{
        [SVProgressHUD show];
        [[HttpService sharedInstance]postMore:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_More_Evaluate,@"fen":[NSString stringWithFormat:@"%d",Fen],@"content":tvGradeText.text} completionBlock:^(id object) {
            [SVProgressHUD showSuccessWithStatus:@"评分成功！感谢您的宝贵意见！我们会做得更好！"];
            [self pop];
        } failureBlock:^(NSError *error, NSString *responseString) {
            if(!responseString){
                [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
            }else{
                [SVProgressHUD showErrorWithStatus:responseString];
            }
        }];
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
