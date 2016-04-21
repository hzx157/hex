//
//  OneKeyOrderViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/17.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "OneKeyOrderViewController.h"
#import "Util.h"
#import "ServerCell.h"
#import "ServerTimeViewController.h"
#import "AVOrder.h"
#import "PayViewController.h"
#import "HttpService.h"
#import "LoginViewController.h"
#import "MD5Create.h"

@interface OneKeyOrderViewController (){
    IBOutlet UITableView *tvOneKey;
    
    IBOutlet UIImageView *vcBottom;
    HZAreaPickerView *locatePicker;
    
    NSString *strLocate;
    NSString *strLocateDetail;
    NSString *strServerTime;
    NSString *strRemark;
    
    NSString *strId;
    float prices;
    float hours;
}

@end

@implementation OneKeyOrderViewController

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
    self.title=@"立马下单";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"通用-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    
    [Util setExtraCellLineHidden:tvOneKey];
    [Util hideHeader:tvOneKey];
    [tvOneKey registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    UINib *nib = [UINib nibWithNibName:@"ServerCell" bundle:[NSBundle bundleWithIdentifier:@"ServerCell"]];
    [tvOneKey registerNib:nib forCellReuseIdentifier:@"ServerCell"];
    nib = nil;
    if(!((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.Address||[((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.Address isEqualToString:@""]){
        strLocate=@"服务地址";
    }else {
        NSArray *arrLocate=[((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.Address componentsSeparatedByString:@"-"];
        strLocate=[arrLocate objectAtIndex:0];
        NSIndexPath *ip = [NSIndexPath indexPathForRow:1 inSection:1];
        ServerCell *cell = (ServerCell*)[tvOneKey cellForRowAtIndexPath:ip];
        cell.tfServer.text = [arrLocate objectAtIndex:1];
    }
    strServerTime=@"服务时间";
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[HttpService sharedInstance]postOrder:@{@"activetype":AT_Order_OneKey_Cost} completionBlock:^(id object) {
        prices=[[object valueForKey:@"prices"]floatValue];
        [[HttpService sharedInstance]postNurseMemberList:@{@"activetype":@"1254"} completionBlock:^(id object,int count) {
            [SVProgressHUD dismiss];
            strId=[[object objectAtIndex:0] valueForKey:@"Id"];
            [tvOneKey reloadData];
        } failureBlock:^(NSError *error, NSString *responseString) {
            if(!responseString){
                [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
            }else{
                [SVProgressHUD showErrorWithStatus:responseString];
            }
        }];
    } failureBlock:^(NSError *error, NSString *responseString) {
        if(!responseString){
            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
        }else{
            [SVProgressHUD showErrorWithStatus:responseString];
        }
    }];
}

#pragma mark - IBOutlet Methods

- (IBAction)oneKey:(id)sender {
    NSIndexPath *ip = [NSIndexPath indexPathForRow:1 inSection:1];
    ServerCell *cell=(ServerCell*)[tvOneKey cellForRowAtIndexPath:ip];
    strLocateDetail=cell.tfServer.text;
    
    ip = [NSIndexPath indexPathForRow:1 inSection:3];
    cell=(ServerCell*)[tvOneKey cellForRowAtIndexPath:ip];
    strRemark=cell.tfServer.text;
    
    if(!strLocate||!strLocateDetail||!strServerTime||[strLocate isEqualToString:@"服务地址"]||[strLocateDetail isEqualToString:@""]||[strServerTime isEqualToString:@"服务时间"]){
        [SVProgressHUD showErrorWithStatus:@"资料尚未完善"];
    }else{
        [SVProgressHUD show];
        [[HttpService sharedInstance]postOrder:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_OrderNum_Create} completionBlock:^(id object) {
            [SVProgressHUD dismiss];
            CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
            
            // Add some custom content to the alert view
            UIView *v=[((NSArray*)([[NSBundle mainBundle] loadNibNamed:@"AVOrder" owner:nil options:nil])) objectAtIndex:0];
            for (UILabel *lb in ((NSArray*)[v subviews])) {
                switch (lb.tag) {
                    case 1:
                        lb.text=[NSString stringWithFormat:@"订单号:%@",[object valueForKey:@"Hao"]];
                        break;
                    case 2:
                        lb.text=[NSString stringWithFormat:@"服务时间:%@",strServerTime];
                        break;
                    case 3:
                        lb.text=[NSString stringWithFormat:@"服务地点:%@ %@",strLocate,strLocateDetail];
                        break;
                    case 4:
                        lb.text=[NSString stringWithFormat:@"订单金额:%.2f元",prices*hours];
                        break;
                    case 5:
                        lb.text=[NSString stringWithFormat:@"备注:%@", strRemark];
                        break;
                        
                    default:
                        break;
                }
            }
            [alertView setContainerView:v];
            
            
            // Modify the parameters
            [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
            
            // You may use a Block, rather than a delegate.
            [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
                if (buttonIndex==1) {
                    NSArray *arr=[strServerTime componentsSeparatedByString:@"("];
                    
                    NSString *fromDate=[NSString stringWithFormat:@"%@ %@:00",[arr objectAtIndex:0],[[[[arr objectAtIndex:1]componentsSeparatedByString:@")"]objectAtIndex:1]substringToIndex:5]];
                    NSString *toDate=[NSString stringWithFormat:@"%@ %@:00",[arr objectAtIndex:0],[[[[arr objectAtIndex:1]componentsSeparatedByString:@")"]objectAtIndex:1]substringFromIndex:6]];
                    
                    [SVProgressHUD showWithStatus:@"玩命在提交..." maskType:SVProgressHUDMaskTypeBlack];
                    [[HttpService sharedInstance]postOrder:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Order_OneKey,@"address":[NSString stringWithFormat:@"%@ %@",strLocate,strLocateDetail],@"startTime":fromDate,@"endTime":toDate,@"mesdd5enID":[MD5Create stringToMD5Up:[MD5KEY stringByAppendingString:[object valueForKey:@"Hao"]]],@"hao":[object valueForKey:@"Hao"],@"TradesId":strId,@"Claim":strRemark} completionBlock:^(id object) {
                        [SVProgressHUD dismiss];
                        PayViewController *vc = [[PayViewController alloc]initWithNibName:@"PayViewController" bundle:nil];
                        vc.ClearBlock=^(){};
                        vc.orderEnCrypId=[object objectForKey:@"orderEnCrypId"];
                        [vc setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:vc animated:NO];
                    } failureBlock:^(NSError *error, NSString *responseString) {
                        if(!responseString){
                            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
                        }else{
                            [SVProgressHUD showErrorWithStatus:responseString];
                        }
                    }];
                   
                }
                [alertView close];
            }];
            
            [alertView setUseMotionEffects:true];
            
            // And launch the dialog
            [alertView show];
        } failureBlock:^(NSError *error, NSString *responseString) {
            if(!responseString){
                [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
            }else{
                [SVProgressHUD showErrorWithStatus:responseString];
            }
        }];
    }
}

//#pragma mark - CustomIOS7AlertView Methods
//- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
//{
//    NSLog(@"Delegate: Button at position %d is clicked on alertView %d.", (int)buttonIndex, (int)[alertView tag]);
//    [alertView close];
//}

#pragma mark - HZAreaPicker delegate
-(void)pickerDidCommitStatus:(NSString *)locate
{
    if([locate hasPrefix:@"广东省 广州市"]){
        strLocate=locate;
        [tvOneKey reloadData];
        [locatePicker cancelPicker];
    }else{
        [SVProgressHUD showErrorWithStatus:@"该地区暂未开放服务喔~"];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section==1) {
        return 2;
    }
    else if(section == 3) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0f;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {

    if (section == 1) {
        return @"地址信息若填写不详细，会影响上门服务时间";
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font=[UIFont systemFontOfSize:16.0];
    switch (indexPath.section) {
        case 0:
            cell.imageView.image=nil;
            cell.textLabel.text=[NSString stringWithFormat:@"单次%.f元/小时",prices];
            [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
            cell.accessoryType=UITableViewCellAccessoryNone;
            break;
        case 1:
            if (indexPath.row==0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"ServerCell"];
                //cell.imageView.image=[UIImage imageNamed:@"要服务-服务地点"];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                //cell.textLabel.text=strLocate;
                
                ((ServerCell*)cell).ivServer.image=[UIImage imageNamed:@"要服务-服务地点"];
                ((ServerCell*)cell).tfServer.text=strLocate;
                ((ServerCell*)cell).tfServer.enabled = false;
                ((ServerCell*)cell).lblXin.hidden = NO;
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:@"ServerCell"];
                ((ServerCell*)cell).tfServer.placeholder=@"请填写详细街道";
                ((ServerCell*)cell).ivServer.image=nil;
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"ServerCell"];
            //cell.imageView.image=[UIImage imageNamed:@"要服务-服务时间段"];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            //cell.textLabel.text=strServerTime;
            
            ((ServerCell*)cell).ivServer.image=[UIImage imageNamed:@"要服务-服务时间段"];
            ((ServerCell*)cell).tfServer.text=strServerTime;
            ((ServerCell*)cell).tfServer.enabled = false;
            ((ServerCell*)cell).lblXin.hidden = NO;
            break;
        case 3:
            if (indexPath.row==0) {
                cell.imageView.image=[UIImage imageNamed:@"要服务-备注"];
                cell.textLabel.text=@"备注";
                cell.accessoryType=UITableViewCellAccessoryNone;
            }else{
                cell = [tableView dequeueReusableCellWithIdentifier:@"ServerCell"];
                ((ServerCell*)cell).tfServer.placeholder=@"请填写您的其他要求";
                ((ServerCell*)cell).ivServer.image=nil;
                ((ServerCell*)cell).tfServer.keyboardType=UIKeyboardTypeDefault;
            }
            break;
            
        default:
            break;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *vc;
    if (indexPath.section==2) {
        vc = [[ServerTimeViewController alloc]initWithNibName:@"ServerTimeViewController" bundle:nil];
        ((ServerTimeViewController*)vc).isPush=YES;
        ((ServerTimeViewController*)vc).IntervalTimeBlock=^(NSString* str){
            NSArray *arr= [str componentsSeparatedByString:@","];
            strServerTime=[arr objectAtIndex:1];
            hours=[[arr objectAtIndex:0]floatValue];
            [tvOneKey reloadData];
        };
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:YES];
    }
    switch (indexPath.section) {
        case 1:
            if (indexPath.row==0) {
                //                cell.textLabel.text=@"请输入服务地点";
                locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCityAndDistrict delegate:self];
                [locatePicker showInView:[[[UIApplication sharedApplication] windows] firstObject]];
            }else{
                //                ((ServerCell*)cell).tfServer.placeholder=@"请填写详细街道";
            }
            break;
        case 3:
            //            ((ServerCell*)cell).tfServer.placeholder=@"请填写您的联系电话";
            break;
        default:
            break;
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
