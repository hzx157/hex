//
//  OrderDetailTableViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/16.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "OrderDetailTableViewController.h"
#import "Util.h"
#import "OrderViewController.h"
#import "EvaluateTextViewCell.h"
#import "HttpService.h"
#import "OrderViewController.h"

@interface OrderDetailTableViewController (){
    int setionCount;
    int Xj;
    BOOL IsOrderAdd,IsCoupon,isAll;
}

@end

@implementation OrderDetailTableViewController

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

- (void)pop {
    if (self.isPush==NO) {
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Private Methods

- (void)initUI
{
    self.navigationController.navigationBarHidden=NO;
    self.title=@"订单详情";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"通用-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    setionCount=7;
    if ([[self.dicData valueForKey:@"State"]intValue]==15&&[[self.dicData valueForKey:@"ReviewState"]intValue]==0) {
        setionCount++;
    }
    if ([[self.dicData valueForKey:@"IsOrderAdd"]isEqual:@(1)]||[[self.dicData valueForKey:@"OrderAddYouHuiMoney"]floatValue]>0.0) {
        setionCount++;
        isAll=YES;
        if ([[self.dicData valueForKey:@"IsOrderAdd"]isEqual:@(1)]) {
            setionCount+=2;
            IsOrderAdd=YES;
        }
        if ([[self.dicData valueForKey:@"OrderAddYouHuiMoney"]floatValue]>0.0) {
            setionCount++;
            IsCoupon=YES;
        }
    }
    [Util setExtraCellLineHidden:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    UINib *nib = [UINib nibWithNibName:@"EvaluateTextViewCell" bundle:[NSBundle bundleWithIdentifier:@"EvaluateTextViewCell"]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"EvaluateTextViewCell"];
    nib = nil;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return setionCount;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[self.dicData valueForKey:@"State"]intValue]==15&&[[self.dicData valueForKey:@"ReviewState"]intValue]==0) {
        if (indexPath.row!=setionCount-1) {
            return 50.0f;
        } else {
            return 300.0f;
        }
    } else {
        return 50.0f;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font=[UIFont systemFontOfSize:15.0];
    
    if (indexPath.row==0) {
        cell.textLabel.text=[NSString stringWithFormat:@"订单号：%@",[self.dicData valueForKey:@"Hao"]];
    }else if(indexPath.row==1){
        cell.textLabel.text=[NSString stringWithFormat:@"服务时间：%@",[self.dicData valueForKey:@"ServerTime"]];
    }else if(indexPath.row==(IsOrderAdd?2:-1)){
        if([[self.dicData valueForKey:@"IsOrderAdd"]isEqual:@(1)]){
            cell.textLabel.text=[NSString stringWithFormat:@"续时时间：%@",[self.dicData valueForKey:@"ServerAddTime"]];
        }else{
            cell.textLabel.text=@"续时时间：";
        }
    }else if(indexPath.row==(IsOrderAdd?3:2)){
        cell.textLabel.text=[NSString stringWithFormat:@"服务地点：%@",[self.dicData valueForKey:@"Address"]];
    }else if(indexPath.row==(IsOrderAdd?4:3)){
        cell.textLabel.text=[NSString stringWithFormat:@"服务人员：%@",[Util returnNotNull:[self.dicData valueForKey:@"NurseMemName"]]];
    }else if(indexPath.row==(IsOrderAdd?5:4)){
        cell.textLabel.text=[NSString stringWithFormat:@"服务金额：￥%.2f",[[self.dicData valueForKey:@"Money"]floatValue]];
    }else if(indexPath.row==(IsOrderAdd?6:-1)){
        cell.textLabel.text=[NSString stringWithFormat:@"服务续时金额：￥%.2f",[[self.dicData valueForKey:@"ZjMoney"]floatValue]];
    }else if(indexPath.row==(IsOrderAdd?(IsCoupon?7:-1):(IsCoupon?5:-1))){
        cell.textLabel.text=[NSString stringWithFormat:@"已优惠：￥%.2f",[[self.dicData valueForKey:@"OrderAddYouHuiMoney"]floatValue]];
    }else if(indexPath.row==(IsOrderAdd?(IsCoupon?8:7):(IsCoupon?6:5))){
        cell.textLabel.text=[NSString stringWithFormat:@"订单总金额：￥%.2f",[[self.dicData valueForKey:@"AllMoney"]floatValue]+[[self.dicData valueForKey:@"ZjMoney"]floatValue]];
    }else if(indexPath.row==(IsOrderAdd?(IsCoupon?9:8):(IsCoupon?7:6))){
        cell.textLabel.text=[NSString stringWithFormat:@"备注：%@",[self.dicData valueForKey:@"Claim"]];
    }else if (indexPath.row==(IsOrderAdd?(IsCoupon?10:9):(IsCoupon?8:7))){
        cell.textLabel.text=[NSString stringWithFormat:@"订单状态：%@",
                             [self.dicData valueForKey:@"StateInfo"]];
        if([[self.dicData valueForKey:@"IsRefundState"]intValue]==1){
            cell.textLabel.text=@"订单状态：退款审核中";
        }else if([[self.dicData valueForKey:@"IsRefundState"]intValue]==10){
            cell.textLabel.text=@"订单状态：退款中";
        }else if([[self.dicData valueForKey:@"IsRefundState"]intValue]==20){
            cell.textLabel.text=@"订单状态：退款失败";
        }else if([[self.dicData valueForKey:@"IsRefundState"]intValue]==25){
            cell.textLabel.text=@"订单状态：退款成功";
        }
    }
    if ([[self.dicData valueForKey:@"State"]intValue]==15&&[[self.dicData valueForKey:@"ReviewState"]intValue]==0) {
        if (indexPath.row==setionCount-1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"EvaluateTextViewCell" ];
            [((EvaluateTextViewCell*)cell) waitBlock:^(int tag) {
                if (tag==0) {
                    [SVProgressHUD showWithStatus:@"发表评论中..." maskType:SVProgressHUDMaskTypeBlack];
                    [[HttpService sharedInstance]postEvaluate:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Add_Evaluate,@"EnCrypId":[self.dicData valueForKey:@"EnCrypId"],@"fen":[NSString stringWithFormat:@"%d",Xj],@"content":((EvaluateTextViewCell*)cell).tvEvaluate.text} completionBlock:^(id object) {
                        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"发表成功!还差%@次评论可以获得优惠券喔",[object valueForKey:@"ChaCount"]]];
                        if (self.isPush==NO) {
                            [self.navigationController popViewControllerAnimated:NO];
                        }else{
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    } failureBlock:^(NSError *error, NSString *responseString) {
                        if(!responseString){
                            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
                        }else{
                            [SVProgressHUD showErrorWithStatus:responseString];
                        }
                    }];
                }else{
                    Xj=tag;
                }
            }];
            cell.textLabel.text=@"";
        }
    }
    // Configure the cell...
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
