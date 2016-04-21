//
//  MyCollectionTableViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/12.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "MyCollectionTableViewController.h"
#import "Util.h"
#import "CollectionCell.h"
#import "HttpService.h"
#import "MJRefresh.h"
#import "RecommendViewController.h"

@interface MyCollectionTableViewController (){
    NSMutableArray *arrData;
    int Page;
}

@end

@implementation MyCollectionTableViewController

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

#pragma mark - Private Methods

- (void)initUI
{
    Page=1;
    self.navigationController.navigationBarHidden=NO;
    self.title=@"我的收藏";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"通用-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    
    arrData=[[NSMutableArray alloc]init];
    
    [Util setExtraCellLineHidden:self.tableView];
    UINib *nib = [UINib nibWithNibName:@"CollectionCell" bundle:[NSBundle bundleWithIdentifier:@"CollectionCell"]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"CollectionCell"];
    nib = nil;
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    [self initData];
}

- (void)initData {
    [SVProgressHUD show];
    [[HttpService sharedInstance]postCollectionList:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Collection,@"Maxlen":@"10",@"Page":[NSString stringWithFormat:@"%d",Page]} completionBlock:^(id object,int count) {
        if ([object isKindOfClass:[NSNull class]]) {
            [SVProgressHUD showErrorWithStatus:@"您还没有收藏的阿姨哦"];
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
    return 90.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dicData=[arrData objectAtIndex:indexPath.row];
    CollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectionCell" forIndexPath:indexPath];
    cell.lbName.text=[Util returnNotNull:[[dicData objectForKey:@"Name"] valueForKey:@"Value"]];
    cell.lbAge.text=[NSString stringWithFormat:@"年龄:%@岁",[Util returnNotNull:[[[[[dicData objectForKey:@"NurseMemId"]objectForKey:@"ClassInfo"]objectForKey:@"Age"] valueForKey:@"Value"]stringValue]]];
    cell.lbHometown.text=[Util returnNotNull:[[[[dicData objectForKey:@"NurseMemId"]objectForKey:@"ClassInfo"] objectForKey:@"Hometown"] valueForKey:@"Value"]];
    cell.lbServerCount.text=[NSString stringWithFormat:@"最近服务：%@次",[Util returnNotNull:[[[[dicData objectForKey:@"NurseMemId"]objectForKey:@"ClassInfo"] objectForKey:@"Amount"] valueForKey:@"Value"]]];
    [cell setXj: [[Util returnNotNull:[[[[dicData objectForKey:@"NurseMemId"]objectForKey:@"ClassInfo"] objectForKey:@"Xj"] valueForKey:@"Value"]]floatValue]];
    [cell.ivAuntPhoto setImageWithURL:[NSURL URLWithString:[Util returnNotNull:[[[[dicData objectForKey:@"NurseMemId"]objectForKey:@"ClassInfo"] objectForKey:@"Img"] valueForKey:@"Value"]]] placeholderImage:[UIImage imageNamed:@"我的资料-个人头像"]];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RecommendViewController *vc = [[RecommendViewController alloc] initWithNibName:@"RecommendViewController" bundle:nil];
    vc.EnCrypId=[[arrData objectAtIndex:indexPath.row]valueForKey:@"NurseMemEnCrypId"];
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}

//删除收藏
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [SVProgressHUD show];
        [[HttpService sharedInstance]postCollection:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Del_Collection,@"EnCrypId":[[arrData objectAtIndex:indexPath.row]valueForKey:@"EnCrypId"]} completionBlock:^(id object) {
            [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
            [arrData removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];
        } failureBlock:^(NSError *error, NSString *responseString) {
            if(!responseString){
                [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
            }else{
                [SVProgressHUD showErrorWithStatus:responseString];
            }
        }];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
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
