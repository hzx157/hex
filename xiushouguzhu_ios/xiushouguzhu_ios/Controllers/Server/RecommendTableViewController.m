//
//  RecommendTableViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/16.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "RecommendTableViewController.h"
#import "Util.h"
#import "RecommendCell.h"
#import "RecommendViewController.h"
#import "HttpService.h"

@interface RecommendTableViewController (){
    NSMutableArray *arrData;
}

@end

@implementation RecommendTableViewController

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
    [self initData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI{
    
    self.navigationController.navigationBarHidden=NO;
    self.title=@"推荐服务";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"通用-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    
    arrData=[[NSMutableArray alloc]init];
    
    [Util setExtraCellLineHidden:self.tableView];
    UINib *nib = [UINib nibWithNibName:@"RecommendCell" bundle:[NSBundle bundleWithIdentifier:@"RecommendCell"]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"RecommendCell"];
    nib=nil;

}

- (void)initData {
    [SVProgressHUD show];
//    [[HttpService sharedInstance]postNurseMemberList:@{@"activetype":@"1256"} completionBlock:^(id object,int count) {
//        [SVProgressHUD dismiss];
//        arrData=object;
//        [self.tableView reloadData];
//    } failureBlock:^(NSError *error, NSString *responseString) {
//        if(!responseString){
//            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
//        }else{
//            [SVProgressHUD showErrorWithStatus:responseString];
//        }
//    }];
    [[HttpService sharedInstance]postOrderList:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Order_Allot_Aunt,@"orderEnCrypId":_EnCrypId} completionBlock:^(id object,int count) {
        [SVProgressHUD dismiss];
        arrData=object;
        [self.tableView reloadData];
    } failureBlock:^(NSError *error, NSString *responseString) {
        if(!responseString){
            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
        }else{
            [SVProgressHUD showErrorWithStatus:responseString];
        }
    }];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:NO];
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
    return 86;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendCell" forIndexPath:indexPath];
    NSDictionary *dicData=[arrData objectAtIndex:indexPath.row];
    cell.lbName.text=[[dicData objectForKey:@"Name"] valueForKey:@"Value"];
    cell.lbYears.text=[NSString stringWithFormat:@"工作年限：%@",[[dicData objectForKey:@"WorkExperience"] valueForKey:@"Value"]];
    cell.lbOld.text=[NSString stringWithFormat:@"%@岁",[[[dicData objectForKey:@"Age"] valueForKey:@"Value"]stringValue]];
    cell.lbHometown.text=[[dicData objectForKey:@"Hometown"] valueForKey:@"Value"];
    cell.lbServerCount.text=[NSString stringWithFormat:@"最近服务：%@次",[[dicData objectForKey:@"Amount"] valueForKey:@"Value"]];
    cell.lbDistant.text=@"";
    [cell setXi: [[[dicData objectForKey:@"Xj"] valueForKey:@"Value"]floatValue]];
    
    [cell.ivAuntPhoto setImageWithURL:[NSURL URLWithString:[[dicData objectForKey:@"Img"] valueForKey:@"Value"]] placeholderImage:[UIImage imageNamed:@"我的资料-个人头像"]];
    // Configure the cell...
    
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


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    RecommendViewController *vc = [[RecommendViewController alloc] initWithNibName:@"RecommendViewController" bundle:nil];
    vc.EnCrypId=[[arrData objectAtIndex:indexPath.row]valueForKey:@"EnCrypId"];
    vc.NurseIDBlock=^(){
        if (self.NurseIDBlock) {
            self.NurseIDBlock([[arrData objectAtIndex:indexPath.row]valueForKey:@"EnCrypId"],[[[arrData objectAtIndex:indexPath.row]valueForKey:@"Name"]valueForKey:@"Value"]);
        }
    };
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
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
