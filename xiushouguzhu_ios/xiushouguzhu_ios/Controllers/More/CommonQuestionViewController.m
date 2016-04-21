//
//  CommonQuestionViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/4/9.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "CommonQuestionViewController.h"

@interface CommonQuestionViewController (){
    IBOutlet UIScrollView *sv;
    IBOutlet UIImageView *iv;
}

@end

@implementation CommonQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    sv.contentSize=CGSizeMake(0, iv.frame.size.height
                              );
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
    self.title=@"常见问题";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"通用-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
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
