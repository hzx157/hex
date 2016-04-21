//
//  MyEvaluateTableViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/12.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "MyEvaluateTableViewController.h"
#import "Util.h"
#import "EvaluateCell.h"
#import "HttpService.h"
#import "MJRefresh.h"
#import "RecommendViewController.h"

@interface MyEvaluateTableViewController (){
    NSMutableArray *arrData;
    int Page;
}

@end

@implementation MyEvaluateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self initData];
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
    self.title=@"我的评论";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"通用-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    
    arrData=[[NSMutableArray alloc]init];
    
    [Util setExtraCellLineHidden:self.tableView];
    UINib *nib = [UINib nibWithNibName:@"EvaluateCell" bundle:[NSBundle bundleWithIdentifier:@"EvaluateCell"]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"EvaluateCell"];
    nib = nil;
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self initData];
}

- (void)initData{
    [SVProgressHUD show];
    [[HttpService sharedInstance]postList:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_MyEvaluate,@"Maxlen":@"10",@"Page":[NSString stringWithFormat:@"%d",Page]} completionBlock:^(id object,int count) {
        if ([object isKindOfClass:[NSNull class]]) {
            [SVProgressHUD showErrorWithStatus:@"您还没有评论哦"];
        }else{
            if(((NSArray*)object).count==0&&Page!=1){
                [SVProgressHUD showErrorWithStatus:@"已没有更多数据"];
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
                NSLog(@"%@",arrData);
            }
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        if(!responseString){
            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
        }else{
            [SVProgressHUD showErrorWithStatus:responseString];
        }
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 193.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dicData=[arrData objectAtIndex:indexPath.row];
    EvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluateCell" forIndexPath:indexPath];
    cell.lbName.text=[Util returnNotNull:[dicData objectForKey:@"NurseMenName"]];
    NSArray *arrTime=[((NSString *)[[dicData objectForKey:@"AddTime"]valueForKey:@"Value"]) componentsSeparatedByString:@"T"];
    cell.lbAddTime.text=[Util returnNotNull:[NSString stringWithFormat:@"%@ %@",[arrTime objectAtIndex:0],[[arrTime objectAtIndex:1]substringToIndex:5]]];
    cell.lbAge.text=[Util returnNotNull:[NSString stringWithFormat:@"年龄:%d岁",[[dicData valueForKey:@"Age"]intValue]]];
    cell.lbContext.text=[Util returnNotNull:[[dicData valueForKey:@"Content"]valueForKey:@"Value"]];
    cell.lbHometown.text=[Util returnNotNull:[dicData valueForKey:@"Hometown"]];
    cell.lbServerTime.text=[NSString stringWithFormat:@"最近服务:%@次",[Util returnNotNull:[dicData valueForKey:@"Amount"]]];
    ;
    [cell setStars:[[Util returnNotNull:[[dicData valueForKey:@"Fen"]valueForKey:@"Value"]]intValue]];
    [cell.ivAunt setImageWithURL:[NSURL URLWithString:[Util returnNotNull:[dicData objectForKey:@"Img"]]] placeholderImage:[UIImage imageNamed:@"我的资料-个人头像"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    NSDictionary *dicData=[arrData objectAtIndex:indexPath.row];
    if ([[Util returnNotNull:[dicData valueForKey:@"NurseMemEnCrypId"]]isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"此阿姨已经离职咯"];
    }else{
        RecommendViewController *vc = [[RecommendViewController alloc] initWithNibName:@"RecommendViewController" bundle:nil];
        vc.EnCrypId=[dicData valueForKey:@"NurseMemEnCrypId"];
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)headerRereshing{
    Page=1;
    [self initData];
}

-(void)footerRereshing{
    Page++;
    [self initData];
}

@end
