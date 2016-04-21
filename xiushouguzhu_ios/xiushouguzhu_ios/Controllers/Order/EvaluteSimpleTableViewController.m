//
//  EvaluteSimpleTableViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/16.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "EvaluteSimpleTableViewController.h"
#import "Util.h"
#import "EvaluteSimpleTableViewCell.h"
#import "HttpService.h"
#import "MJRefresh.h"


@interface EvaluteSimpleTableViewController (){
    NSMutableArray *arrData;
    int Page;
}

@end

@implementation EvaluteSimpleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI{
    
    self.navigationController.navigationBarHidden=NO;
    self.title=@"服务评价";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"通用-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    
    arrData=[[NSMutableArray alloc]init];
    
    [Util setExtraCellLineHidden:self.tableView];
    UINib *nib = [UINib nibWithNibName:@"EvaluteSimpleTableViewCell" bundle:[NSBundle bundleWithIdentifier:@"EvaluteSimpleTableViewCell"]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"EvaluteSimpleTableViewCell"];
    nib=nil;
    Page=1;
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self initData];
}

-(void)initData{
    [SVProgressHUD show];
    [[HttpService sharedInstance]postEvaluateList:@{@"nurseMemEnCrypId":_nurseMemEnCrypId,@"activetype":AT_Evaluate,@"Maxlen":@"10",@"Page":[NSString stringWithFormat:@"%d",Page]} completionBlock:^(id object,int count) {
        if ([object isKindOfClass:[NSNull class]]) {
            [SVProgressHUD showErrorWithStatus:@"该保姆还没有评论哦"];
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
            }
            [self.tableView headerEndRefreshing];
            [self.tableView footerEndRefreshing];;
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

- (void)pop {
//    if (self.isPush==NO) {
//        [self.navigationController popViewControllerAnimated:NO];
//    }else{
        [self.navigationController popViewControllerAnimated:YES];
//    }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dicData=[arrData objectAtIndex:indexPath.row];
    EvaluteSimpleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluteSimpleTableViewCell" forIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (![[Util returnNotNull:[[dicData valueForKey:@"ReplyContent"]valueForKey:@"Value"]]isEqualToString:@""]&&[[[dicData valueForKey:@"ReplyContent"]valueForKey:@"Value"] length]>=4) {
        cell.lbPhone.text=[NSString stringWithFormat:@"%@****",[[[dicData valueForKey:@"ReplyContent"]valueForKey:@"Value"]substringToIndex:[[[dicData valueForKey:@"ReplyContent"]valueForKey:@"Value"] length]-4]];
    }else{
        cell.lbPhone.text=@"匿名用户";
    }
    cell.lbContent.text=[[dicData valueForKey:@"Content"]valueForKey:@"Value"];
    cell.lbDate.text=[[[[dicData valueForKey:@"AddTime"]valueForKey:@"Value"]componentsSeparatedByString:@"T"]objectAtIndex:0];
    [cell setStars:[[[dicData valueForKey:@"Fen"]valueForKey:@"Value"]intValue]];
    // Configure the cell...
    
    return cell;
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
