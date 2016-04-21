//
//  RecommendViewController.m
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/16.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "RecommendViewController.h"
#import "EvaluteSimpleTableViewController.h"
#import "ServerTimeCell.h"
#import "HttpService.h"
#import "MinStar.h"
#import "Util.h"
#import "ServerViewController.h"

@interface RecommendViewController (){
    IBOutlet UICollectionView *cvChooseTime;
    IBOutlet UIScrollView *svChooseWeek;
    IBOutlet UIView *vcChooseWeek;
    IBOutletCollection(UILabel) NSArray *lbWeeks;
    IBOutletCollection(UILabel) NSArray *lbDates;
    IBOutlet UIView *vcEvalute;
    IBOutlet UIButton *btnCollect;
    
    IBOutlet UIImageView *ivAuntPhoto;
    IBOutlet UILabel *lbName;
    IBOutlet UILabel *lbAge;
    IBOutlet UILabel *lbHometown;
    IBOutlet UILabel *lbServerCount;
    IBOutlet UILabel *IDNumber;
    IBOutlet UILabel *lbEvaCount;
    IBOutlet UIImageView *ivCheckID;
    
    UIImageView *ivChoose;
    
    NSMutableArray *arrData;
    int preTag;
//    NSIndexPath *preIndex;
}

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private Methods

- (void)initUI{
    self.navigationController.navigationBarHidden=NO;
    self.title=@"服务详情";
    NSDictionary *attributes=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName,nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"通用-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];
    
    
    NSArray *arrSevenDay=[Util getSevenDay];
    for(int i=0;i<7;i++){
        ((UILabel*)[lbDates objectAtIndex:i]).text=[[[arrSevenDay objectAtIndex:i] componentsSeparatedByString:@","]objectAtIndex:0];
        ((UILabel*)[lbWeeks objectAtIndex:i]).text=[[[arrSevenDay objectAtIndex:i] componentsSeparatedByString:@","]objectAtIndex:1];
    }
    
    [svChooseWeek addSubview:vcChooseWeek];
    svChooseWeek.contentSize=CGSizeMake(vcChooseWeek.frame.size.width, 0);
    ((UILabel*)[lbDates objectAtIndex:0]).textColor=NavColor;
    ((UILabel*)[lbWeeks objectAtIndex:0]).textColor=NavColor;
    ivChoose = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"黑底小三角"]];
    ivChoose.frame=CGRectMake(0, 0, 15, 8);
    ivChoose.center=CGPointMake(((UILabel*)[lbDates objectAtIndex:0]).frame.size.width/2, 50-3);
    [svChooseWeek addSubview:ivChoose];
    
    cvChooseTime.delegate=self;
    cvChooseTime.dataSource=self;
    
    
    
    ivAuntPhoto.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    ivAuntPhoto.layer.borderWidth=0.1f;
    ivAuntPhoto.layer.cornerRadius=30.0f;
    ivAuntPhoto.layer.masksToBounds = YES;
    
    
    arrData = [[NSMutableArray alloc]init];
    UINib *nib=[UINib nibWithNibName:@"ServerTimeCell" bundle:nil];
    [cvChooseTime registerNib:nib forCellWithReuseIdentifier:@"ServerTimeCell"];
    UIGestureRecognizer *grVcEvalute = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(grVcEvalute)];
    [vcEvalute addGestureRecognizer:grVcEvalute];
    [self initData];

}

- (void)initData {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[HttpService sharedInstance]postNurseMember:@{@"activetype":@"1257",@"EnCrypId":_EnCrypId} completionBlock:^(id object) {
        
        [ivAuntPhoto setImageWithURL:[NSURL URLWithString:[[object objectForKey:@"Img"] valueForKey:@"Value"]] placeholderImage:[UIImage imageNamed:@"我的资料-个人头像"]];
        
         lbName.text=[[object objectForKey:@"Name"] valueForKey:@"Value"];
        
         lbAge.text=[NSString stringWithFormat:@"年龄：%@岁",[[[object objectForKey:@"Age"] valueForKey:@"Value"]stringValue]];
         lbHometown.text=[[object objectForKey:@"Hometown"] valueForKey:@"Value"];
        ;
//        IDNumber.text=[NSString stringWithFormat:@"身份证：%@",[Util returnNotNull:[[object objectForKey:@"IDNumber"] valueForKey:@"Value"]]];
        
        if ([[Util returnNotNull:[[object objectForKey:@"IDNumber"] valueForKey:@"Value"]]isEqualToString:@""]){
             IDNumber.text=@"";
        }else{
            IDNumber.text=[NSString stringWithFormat:@"身份证：%@****",[[[object objectForKey:@"IDNumber"] valueForKey:@"Value"]substringToIndex:[[[object objectForKey:@"IDNumber"] valueForKey:@"Value"]length]-4]];
        }
        lbServerCount.text=[NSString stringWithFormat:@"最近服务：%@次",[[object objectForKey:@"Amount"] valueForKey:@"Value"]];
        MinStar *vcStar=[[MinStar alloc]initWithFrame:CGRectMake(89, 18, 75, 15)];
        [vcStar setStarCount:(int)[[[object objectForKey:@"Fen"]valueForKey:@"Value"]floatValue]];
        if ([[[object objectForKey:@"IsRealName"] valueForKey:@"Value"]intValue]==0){
            ivCheckID.image=nil;
        }else{
            ivCheckID.image=[UIImage imageNamed:@"推荐服务-身份验证"];
        }
        [vcStar setStarCount:(int)[[[object objectForKey:@"Xj"] valueForKey:@"Value"]floatValue]];
        [vcEvalute addSubview:vcStar];
        
        lbEvaCount.text=[NSString stringWithFormat:@"(%@人评价)",[object objectForKey:@"ReviewCount"]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"yyyy-MM-dd"];
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:(preTag+1)*60*60*24];
        NSString *strDate= [dateFormatter stringFromDate:date];
        [[HttpService sharedInstance]postCollection:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"EnCrypId":_EnCrypId,@"activetype":AT_IsCollection,@"dateTime":strDate} completionBlock:^(id object) {
            if ([[object valueForKey:@"IsHaveCollects"]intValue]==1) {
                [btnCollect setTitle:@"已收藏" forState:UIControlStateNormal];
                [btnCollect setEnabled:NO];
            }
        } failureBlock:^(NSError *error, NSString *responseString) {
            if(!responseString){
                [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
            }else{
                [SVProgressHUD showErrorWithStatus:responseString];
            }
        }];
        [[HttpService sharedInstance]postNurseList:@{@"EnCrypId":_EnCrypId,@"activetype":AT_Nurse_Time,@"dateTime":strDate} completionBlock:^(id object, int count) {
            [SVProgressHUD dismiss];
            [arrData removeAllObjects];
            for(int i=0;i<((NSArray*)object).count;i++){
                [arrData addObject:@{@"isldle":[[object objectAtIndex:i] valueForKey:@"isldle"],@"startHour":[[[object objectAtIndex:i] valueForKey:@"startHour"]substringToIndex:5],@"endHour":[[[object objectAtIndex:i] valueForKey:@"endHour"]substringToIndex:5]}];
            }
            [cvChooseTime reloadData];
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

- (void) grVcEvalute{
    EvaluteSimpleTableViewController *vc= [[EvaluteSimpleTableViewController alloc]initWithNibName:@"EvaluteSimpleTableViewController" bundle:nil];
    [vc setHidesBottomBarWhenPushed:YES];
    vc.nurseMemEnCrypId=_EnCrypId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - IBOutlet Methods

- (IBAction)collect:(id)sender {
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    [[HttpService sharedInstance]postCollection:@{@"userName":((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo.UserName,@"sessionId":((AppDelegate *)[UIApplication sharedApplication].delegate).sessionId,@"activetype":AT_Add_Collection,@"EnCrypId":_EnCrypId} completionBlock:^(id object) {
        [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
        [btnCollect setTitle:@"已收藏" forState:UIControlStateNormal];
        [btnCollect setEnabled:NO];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        if(!responseString){
            [SVProgressHUD showErrorWithStatus:@"获取数据失败"];
        }else{
            [SVProgressHUD showErrorWithStatus:responseString];
        }
    }];
}

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
    if (self.NurseIDBlock) {
        self.NurseIDBlock();
        NSArray *views=self.navigationController.viewControllers;
        [self.navigationController popToViewController:[views objectAtIndex:views.count-3] animated:NO];
    }else{
        ServerViewController *vc=[[ServerViewController alloc]init];
        vc.isPush=YES;
        vc.NurseMemEnCrypId=_EnCrypId;
        vc.NurseMemName=lbName.text;
        [vc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:vc animated:NO];
    }
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
            cell.ivState.image=[UIImage imageNamed:@"推荐服务-服务时间约满"];
            break;
        default:
            break;
    }
    cell.startTime.text=[[arrData objectAtIndex:indexPath.row] valueForKey:@"startHour"];
    cell.endTime.text=[NSString stringWithFormat:@"-%@",[[arrData objectAtIndex:indexPath.row] valueForKey:@"endHour"]];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    if ([[[arrData objectAtIndex:indexPath.row] valueForKey:@"isldle"]intValue]==0) {
//        ServerTimeCell *cell=(ServerTimeCell*)[collectionView cellForItemAtIndexPath:preIndex];
//        cell.ivState.image=[UIImage imageNamed:@"推荐服务-服务时间框"];
//        cell=(ServerTimeCell*)[collectionView cellForItemAtIndexPath:indexPath];
//        cell.ivState.image=[UIImage imageNamed:@"推荐服务-选中框"];
//        preIndex=indexPath;
//    }
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
