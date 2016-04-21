//
//  ServerTimeViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/16.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "ServerTimeViewController.h"
#import "ServerTimeCell.h"
#import "Util.h"
#import "HttpService.h"

@interface ServerTimeViewController (){
    IBOutlet UIScrollView *svMian;
    IBOutlet UICollectionView *cvChooseTime;
    IBOutlet UIScrollView *svChooseWeek;
    IBOutlet UIView *vcChooseWeek;
    IBOutletCollection(UILabel) NSArray *lbWeeks;
    IBOutletCollection(UILabel) NSArray *lbDates;
    IBOutlet UILabel *lbServerTime;
    IBOutlet NSLayoutConstraint *lcHour;
    
    ZHPickView *countPicker;
    UIImageView *ivChoose;
    
    NSMutableArray *arrData;
    float hours;
    int preTag;
    
    NSIndexPath *preIndex;
}

@end

@implementation ServerTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    [self initData];
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

- (void)initUI{
    self.navigationController.navigationBarHidden=NO;
    self.title=@"选择服务时间";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"通用-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    
    svMian.contentSize=CGSizeMake(0, cvChooseTime.frame.origin.y+cvChooseTime.frame.size.height);
    //获取一周时间
    NSArray *arrSevenDay=[Util getSevenDay];
    for(int i=0;i<7;i++){
        ((UILabel*)[lbDates objectAtIndex:i]).text=[[[arrSevenDay objectAtIndex:i] componentsSeparatedByString:@","]objectAtIndex:0];
        ((UILabel*)[lbWeeks objectAtIndex:i]).text=[[[arrSevenDay objectAtIndex:i] componentsSeparatedByString:@","]objectAtIndex:1];
    }
    hours=2.0;
    [svChooseWeek addSubview:vcChooseWeek];
    svChooseWeek.contentSize=CGSizeMake(vcChooseWeek.frame.size.width, 0);
    ((UILabel*)[lbDates objectAtIndex:0]).textColor=NavColor;
    ((UILabel*)[lbWeeks objectAtIndex:0]).textColor=NavColor;
    
    arrData = [[NSMutableArray alloc]init];
    ivChoose = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"黑底小三角"]];
    ivChoose.frame=CGRectMake(0, 0, 15, 8);
    ivChoose.center=CGPointMake(((UILabel*)[lbDates objectAtIndex:0]).frame.size.width/2, 50-3);
    [svChooseWeek addSubview:ivChoose];
    
    cvChooseTime.delegate=self;
    cvChooseTime.dataSource=self;
    UINib *nib=[UINib nibWithNibName:@"ServerTimeCell" bundle:nil];
    [cvChooseTime registerNib:nib forCellWithReuseIdentifier:@"ServerTimeCell"];
}

-(void)initData{
    [SVProgressHUD show];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:(preTag+1)*60*60*24];
    NSString *strDate= [dateFormatter stringFromDate:date];
    [[HttpService sharedInstance]postNurseList:@{@"activetype":AT_Nurse_ServerTime,@"hour":[NSString stringWithFormat:@"%.1f",hours],@"dateTime":strDate,@"EnCrypId":_EnCrypId?_EnCrypId:@""} completionBlock:^(id object, int count) {
        [arrData removeAllObjects];
        for(int i=0;i<((NSArray*)object).count;i++){
            [arrData addObject:@{@"isldle":[[object objectAtIndex:i] valueForKey:@"isldle"],@"startHour":[[[object objectAtIndex:i] valueForKey:@"startHour"]substringToIndex:5],@"endHour":[[[object objectAtIndex:i] valueForKey:@"endHour"]substringToIndex:5]}];
        }
        [cvChooseTime reloadData];
        [SVProgressHUD dismiss];
    } failureBlock:^(NSError *error, NSString *responseString) {
        if(!responseString){
            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
        }else{
            [SVProgressHUD showErrorWithStatus:responseString];
        }
    }];
}

#pragma mark - IBOutlet Methods

- (IBAction)dateChoose:(UIButton*)sender {
    [UIView animateWithDuration:0.3 animations:^{
        ((UILabel*)[lbDates objectAtIndex:preTag]).textColor=[UIColor darkGrayColor];
        ((UILabel*)[lbWeeks objectAtIndex:preTag]).textColor=[UIColor darkGrayColor];
        ((UILabel*)[lbDates objectAtIndex:sender.tag]).textColor=NavColor;
        ((UILabel*)[lbWeeks objectAtIndex:sender.tag]).textColor=NavColor;
        ivChoose.center=CGPointMake(sender.frame.origin.x+sender.frame.size.width/2, 50-3);
    }];
    preTag=(int)sender.tag;
    [self initData];
    preIndex=nil;
}

- (IBAction)scControl:(UIButton*)sender {
    if (sender.tag==0) {
        [UIView animateWithDuration:0.3 animations:^{
            if (svChooseWeek.contentOffset.x-80>0) {
                svChooseWeek.contentOffset=CGPointMake(svChooseWeek.contentOffset.x-80, 0);
            }else {
                svChooseWeek.contentOffset=CGPointMake(0, 0);
            }
            
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            if (svChooseWeek.contentOffset.x+80<560-svChooseWeek.frame.size.width) {
                svChooseWeek.contentOffset=CGPointMake(svChooseWeek.contentOffset.x+80, 0);
            }else {
                svChooseWeek.contentOffset=CGPointMake(560-svChooseWeek.frame.size.width, 0);
            }
        }];
    }
}

- (IBAction)commit:(id)sender {
    if (preIndex) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd(EE)"];
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:(preTag+1)*60*60*24];
        NSString *strDate= [dateFormatter stringFromDate:date];
        _IntervalTimeBlock([NSString stringWithFormat:@"%.1f,%@%@-%@",hours,strDate,[[arrData objectAtIndex:preIndex.row]valueForKey:@"startHour"],[[arrData objectAtIndex:preIndex.row]valueForKey:@"endHour"]]);
        [self pop];
    }else{
        [SVProgressHUD showErrorWithStatus:@"尚未选择服务时间"];
    }
}

#pragma mark - Gesture Methods

- (IBAction)ServerTime:(UITapGestureRecognizer *)sender {
    countPicker=[[ZHPickView alloc] initPickviewWithArray:[NSArray arrayWithObjects:@"2小时",@"2.5小时",@"3小时",@"3.5小时",@"4小时",@"4.5小时",@"5小时",@"5.5小时",@"6小时",@"6.5小时",@"7小时",@"7.5小时",@"8小时",@"8.5小时",@"9小时",@"9.5小时",@"10小时",@"10.5小时",@"11小时",@"11.5小时",@"12小时", nil]isHaveNavControler:NO];
    countPicker.delegate=self;
    [countPicker show];
}

#pragma mark - ZHPickView Methods

//选择器回滚事件
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    lbServerTime.text=resultString;
    hours=[[[resultString componentsSeparatedByString:@"小"]objectAtIndex:0]floatValue];
    [self initData];
    preIndex=nil;
    
}

#pragma mark - UICollection Methods

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return arrData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ServerTimeCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServerTimeCell" forIndexPath:indexPath];
    switch ([[[arrData objectAtIndex:indexPath.row] valueForKey:@"isldle"]intValue]) {
        case 0:
            cell.ivState.image=[UIImage imageNamed:@"推荐服务-服务时间框"];
            break;
        case 1:
            cell.ivState.image=[UIImage imageNamed:@"推荐服务-服务时间约满"];
            break;
        case 2:
            cell.ivState.image=[UIImage imageNamed:@"推荐服务-被预约"];
            break;
        default:
            break;
    }
    cell.startTime.text=[[arrData objectAtIndex:indexPath.row] valueForKey:@"startHour"];
    cell.endTime.text=[NSString stringWithFormat:@"-%@",[[arrData objectAtIndex:indexPath.row] valueForKey:@"endHour"]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([[[arrData objectAtIndex:indexPath.row] valueForKey:@"isldle"]intValue]==0) {
        ServerTimeCell *cell=(ServerTimeCell*)[collectionView cellForItemAtIndexPath:preIndex];
        cell.ivState.image=[UIImage imageNamed:@"推荐服务-服务时间框"];
        cell=(ServerTimeCell*)[collectionView cellForItemAtIndexPath:indexPath];
        cell.ivState.image=[UIImage imageNamed:@"推荐服务-选中框"];
        preIndex=indexPath;
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
