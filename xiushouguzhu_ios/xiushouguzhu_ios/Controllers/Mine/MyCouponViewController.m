//
//  MyCouponViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/12.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "MyCouponViewController.h"
#import "Util.h"
#import "CouponCell.h"
#import "HttpService.h"
#import "MJRefresh.h"
#import "Util.h"

@interface MyCouponViewController (){
    IBOutlet UITableView *tvCoupon;
    IBOutlet UITextField *txtCode;
    
    NSMutableArray *arrData;
    int Page;
}

@end

@implementation MyCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    txtCode.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 14, 0)];
    //设置显示模式为永远显示(默认不显示)
    txtCode.leftViewMode = UITextFieldViewModeAlways;
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

#pragma mark - Private Methods

- (void)initUI
{
    
    Page=1;
    self.navigationController.navigationBarHidden=NO;
    self.title=@"我的袖手券";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"通用-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    
    arrData=[[NSMutableArray alloc]init];
    
    [Util setExtraCellLineHidden:tvCoupon];
    [tvCoupon clearSeperateLine];
    UINib *nib = [UINib nibWithNibName:@"CouponCell" bundle:[NSBundle bundleWithIdentifier:@"CouponCell"]];
    [tvCoupon registerNib:nib forCellReuseIdentifier:@"CouponCell"];
    nib=nil;
    [tvCoupon registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [tvCoupon addHeaderWithTarget:self action:@selector(headerRereshing)];
    [tvCoupon addFooterWithTarget:self action:@selector(footerRereshing)];
    [SVProgressHUD show];
    [self initData];
}

- (void)initData {
    [[HttpService sharedInstance]postCouponList:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Coupon,@"state":@"0",@"Maxlen":@"10",@"Page":[NSString stringWithFormat:@"%d",Page]} completionBlock:^(id object,int count) {
        if ([object isKindOfClass:[NSNull class]]) {
            [SVProgressHUD showErrorWithStatus:@"您还没有袖手券哦"];
            [arrData removeAllObjects];
            [tvCoupon reloadData];
        }else{
            if(((NSArray*)object).count==0&&Page!=1){
                [SVProgressHUD showErrorWithStatus:@"已没有更多袖手券"];
                Page--;
            }else{
                [SVProgressHUD dismiss];
                if (Page==1) {
                    [arrData removeAllObjects];
                }
                for (int i=0; i<((NSArray*)object).count; i++) {
                    NSDictionary *dic=[object objectAtIndex:i];
                    [arrData addObject:dic];
                }
                [tvCoupon reloadData];
            }
            [tvCoupon headerEndRefreshing];
            [tvCoupon footerEndRefreshing];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        if(!responseString){
            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
        }else{
            [SVProgressHUD showErrorWithStatus:responseString];
        }
        [tvCoupon headerEndRefreshing];
        [tvCoupon footerEndRefreshing];
    }];
}

#pragma mark - IBOutlet Methods
- (IBAction)useCouponCode:(id)sender {
    [SVProgressHUD show];
    [[HttpService sharedInstance]postCoupon:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Coupon_Use,@"hao":@"123456"} completionBlock:^(id object) {
        [SVProgressHUD showSuccessWithStatus:@"成功获取袖手券"];
        [self initData];
    } failureBlock:^(NSError *error, NSString *responseString) {
        if(!responseString){
            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
        }else{
            [SVProgressHUD showErrorWithStatus:responseString];
        }
    }];
}

- (IBAction)btnExchangePressed:(id)sender {

    NSString *hao = [txtCode.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (!hao || hao.length <=0) {
        [SVProgressHUD showErrorWithStatus:@"请输入兑换号"];
        return;
    }
    
    [SVProgressHUD show];
    [[HttpService sharedInstance]postCoupon:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":@"887", @"hao":hao} completionBlock:^(id object) {
        
        [SVProgressHUD showSuccessWithStatus:@"您已经成功兑换了一张袖手劵"];
        txtCode.text = @"";
        [self initData];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        if(!responseString){
            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
        }else{
            [SVProgressHUD showErrorWithStatus:responseString];
        }
    }];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    if (txtCode == textField){
        //检测是否为纯数字
        if ([self isPureInt:string]) {
            //添加空格，每4位之后，4组之后不加空格，格式为xxxx xxxx xxxx xxxx xxxxxxxxxxxxxx
            if (textField.text.length % 5 == 4 && textField.text.length < 22) {
                textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
            }
            //只要12位数字
            if ([toBeString length] >= 14)
            {
                toBeString = [toBeString substringToIndex:14];
                txtCode.text = toBeString;
                return NO;
            }
        }
        else if ([string isEqualToString:@""]) { // 删除字符
            if ((textField.text.length - 2) % 5 == 4 && textField.text.length < 22) {
                textField.text = [textField.text substringToIndex:textField.text.length - 1];
            }
            return YES;
        }
        else{
            return NO;
        }
        return YES;
    }
    return YES;
}

- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CouponCell *cell= [tableView dequeueReusableCellWithIdentifier:@"CouponCell"];
    NSDictionary *dicData=[arrData objectAtIndex:indexPath.row];
    cell.lbMoney.text=[NSString stringWithFormat:@"%@元",[dicData valueForKey:@"Money"]];
    
    cell.lbTime.text=[NSString stringWithFormat:@"有效期%@至%@",[[dicData valueForKey:@"InitTime"]substringToIndex:10],[[dicData valueForKey:@"OverTime"]substringToIndex:10]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dicData=[arrData objectAtIndex:indexPath.row];
    if (self.CouponCodeBlock) {
        self.CouponCodeBlock([dicData valueForKey:@"Hao"],[[dicData valueForKey:@"Money"]floatValue]);
        [self pop];
    }
}

-(void)headerRereshing{
    Page=1;
    [SVProgressHUD show];
    [self initData];
}

-(void)footerRereshing{
    Page++;
    [SVProgressHUD show];
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
