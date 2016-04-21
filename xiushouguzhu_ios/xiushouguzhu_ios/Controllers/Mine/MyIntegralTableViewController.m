//
//  MyIntegralTableViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/12.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "MyIntegralTableViewController.h"
#import "Util.h"
#import "MyIntegralCell.h"
#import "IntegralTimeCell.h"
#import "IntegralCell.h"

@interface MyIntegralTableViewController (){
    IBOutlet UIView *vcSectionHead;
    IBOutletCollection(UIButton) NSArray *integralCategory;
    
    UIImageView *ivChoose;
}

@end

@implementation MyIntegralTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
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
    self.title=@"我的积分";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"通用-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    
    [Util setExtraCellLineHidden:self.tableView];
    UINib *nib = [UINib nibWithNibName:@"MyIntegralCell" bundle:[NSBundle bundleWithIdentifier:@"MyIntegralCell"]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MyIntegralCell"];
    nib = [UINib nibWithNibName:@"IntegralTimeCell" bundle:[NSBundle bundleWithIdentifier:@"IntegralTimeCell"]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"IntegralTimeCell"];
    nib = [UINib nibWithNibName:@"IntegralCell" bundle:[NSBundle bundleWithIdentifier:@"IntegralCell"]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"IntegralCell"];
    nib = nil;
}

#pragma mark - IBOutlet Methods
- (IBAction)orderCategory:(UIButton*)sender {
    [UIView animateWithDuration:0.3 animations:^{
        ivChoose.center=CGPointMake(sender.frame.origin.x+sender.frame.size.width/2, ivChoose.center.y);
    }];
    for (UIButton *btn in integralCategory) {
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    [[integralCategory objectAtIndex:sender.tag]setTitleColor:CommonColor forState:UIControlStateNormal];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        return 94;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==2) {
        ivChoose = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"黑底小三角"]];
        ivChoose.frame=CGRectMake(0, 0, 15, 8);
        ivChoose.center=CGPointMake(ScreenWidth/4, 50-4);
        [vcSectionHead addSubview:ivChoose];
        return vcSectionHead;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 2:
            return 10;
            break;
        default:
            return 1;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 50;
            break;
        case 1:
            return 120;
            break;
        default:
            return 37;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    switch (indexPath.section) {
        case 0:
            cell=[tableView dequeueReusableCellWithIdentifier:@"MyIntegralCell"];
            break;
        case 1:
            cell=[tableView dequeueReusableCellWithIdentifier:@"IntegralTimeCell"];
            break;
        case 2:
            cell=[tableView dequeueReusableCellWithIdentifier:@"IntegralCell"];
            break;
        default:
            break;
    }
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
