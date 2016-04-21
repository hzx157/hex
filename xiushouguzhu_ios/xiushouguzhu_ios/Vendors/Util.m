//
//  Util.m
//  Poly
//
//  Created by Interest on 14/11/5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "Util.h"

@implementation Util

+(AppDelegate *)shareAppDelegate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+(void)setDataToRom:(NSDictionary*)dic{
    UserInfo *userInfo=[[UserInfo alloc]init];
    userInfo.UserName=[dic valueForKey:@"UserName"];
    userInfo.Name=[dic valueForKey:@"Name"];
    userInfo.Sex=[[dic valueForKey:@"Sex"]stringValue];
    userInfo.Phone=[dic valueForKey:@"UserName"];
//    userInfo.Phone=[[dic valueForKey:@"Phone"]stringValue];
    userInfo.Address=[dic valueForKey:@"Address"];
    userInfo.Email=[dic valueForKey:@"Email"];
    userInfo.Img=[dic valueForKey:@"Img"];
    ((AppDelegate *)[UIApplication sharedApplication].delegate).userInfo= userInfo;
}

+(NSString *)returnNotNull:(id)content{
    if(content==nil){
        return @"";
    }else
        if([content isEqual:[NSNull null]]){
            return @"";
        }else {
            return content;
        }
}
//NSString 转换为date  date  再转换为string；
+(NSString *)StringToDate:(NSString *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date1 = [dateFormatter dateFromString:date];
    return  [Util compareCurrentTime:date1];
}

+(NSDate *)dateFromString:(NSString *)dateString{
    NSArray *arr=[dateString componentsSeparatedByString:@"T"];
    NSString *str= [NSString stringWithFormat:@"%@ %@",[arr objectAtIndex:0],[arr objectAtIndex:1]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *destDate= [dateFormatter dateFromString:str];
    
    return destDate;
}

/**
 * 计算指定时间与当前的时间差
 * @param compareDate   某一指定时间
 * @return 多少(秒or分or天or月or年)+前 (比如，3天前、10分钟前)
 */

+(NSString *) compareCurrentTime:(NSDate*) compareDate
{
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    return  result;
}

+(NSString *) hourFromTime:(NSString*)fTime toTime:(NSString*)tTime{
    NSDate *fromDate = [self dateFromString:fTime];
    NSDate *toDate = [self dateFromString:tTime];
    NSTimeInterval timeInterval= [toDate timeIntervalSinceDate:fromDate];
    float interval = timeInterval/60.0/60.0;
    return [NSString stringWithFormat:@"%.1f小时",interval];
}

+(NSString *) compareTimeFromTime:(NSString*)fTime toTime:(NSString*)tTime{
    if ([[self returnNotNull:fTime]isEqualToString:@""]||[[self returnNotNull:tTime]isEqualToString:@""]) {
        return @"";
    }else{
        NSArray *arrFrom=[fTime componentsSeparatedByString:@"T"];
        NSArray *arrTo=[tTime componentsSeparatedByString:@"T"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat: @"EE"];
        ;
        NSString *destDate= [dateFormatter stringFromDate:[self dateFromString:fTime]];
        return [NSString stringWithFormat:@"%@(%@)%@-%@",[arrFrom objectAtIndex:0],destDate,[[arrFrom objectAtIndex:1]substringToIndex:5],[[arrTo objectAtIndex:1]substringToIndex:5]];
    }
}

+(NSArray *) getSevenDay{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"MM月dd日,EE"];
    NSMutableArray* arr = [[NSMutableArray alloc]init];
    NSDate *now;
    NSString *destDate;
    for (int i=1; i<=7; i++) {
        now = [NSDate dateWithTimeIntervalSinceNow:i*60*60*24];
        destDate= [dateFormatter stringFromDate:now];
        [arr addObject:destDate];
    }
    return arr;
}

////隐藏TabelView下面多余分割线

+ (void)setExtraCellLineHidden: (UITableView *)tableView

{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

+(void)hideHeader:(UITableView*)tableView{
    UIView *vNull=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.00000000000000001, 0.00000000000000001)];
    [tableView setTableHeaderView:vNull];
}

+(void)call:(NSString*)pnoneNum{
    if(pnoneNum==nil||[pnoneNum isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"该号码为空,不可拨打"];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSString alloc]initWithFormat:@"tel://%@",pnoneNum]]];
    }
}

+(NSString *)stateString:(int)state{
    switch (state) {
        case 0:
            return @"待处理";
            break;
        case 1:
            return @"待付款";
            break;
        case 2:
            return @"已付款";
            break;
        case 3:
            return @"待服务";
            break;
        case 4:
            return @"服务中";
            break;
        case 5:
            return @"续时待付款";
            break;
        case 6:
            return @"已付款";
            break;
        case 7:
            return @"待服务";
            break;
        case 8:
            return @"服务中";
            break;
        case 9:
            return @"服务结束";
            break;
        case 12:
            return @"普通订单过期";
            break;
        case 13:
            return @"续时订单过期";
            break;
        case 15:
            return @"订单完成";
            break;
        default:
            return @"";
            break;
    }
}
@end
