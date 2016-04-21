//
//  HttpService.m
//  HWSDK
//
//  Created by Carl on 13-11-28.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import "HttpService.h"
#import "AllModels.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation HttpService

#pragma mark Life Cycle
- (id)init
{
    if ((self = [super init])) {
        
        ((AFNetworkActivityIndicatorManager*)[AFNetworkActivityIndicatorManager sharedManager]).enabled=YES;
    }
    return  self;
}

#pragma mark Class Method
+ (HttpService *)sharedInstance
{
    static HttpService * this = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        this = [[self alloc] init];
    });
    return this;
}

#pragma mark Private Methods
- (NSString *)mergeURL:(NSString *)methodName
{
    NSString * str =[NSString stringWithFormat:@"%@%@",Res_URL_Prefix,methodName];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return str;
}

#pragma mark Instance Method

/**
 @desc 检测APP更新
 */
//TODO:检测APP更新
- (void)checkUpdate:(NSString *)appID compleitionBlock:(void (^)(BOOL hasNew,NSError * error))completionHandle failureBlock:(void (^)(NSError * error,NSString * responseString))failureHandle
{
    if(!appID)
    {
        NSLog(@"The appID is nil.");
        
        if(completionHandle)
        {
            completionHandle(NO,[NSError errorWithDomain:@"The appID is nil" code:100 userInfo:nil]);
        }
        return;
    }
    [self post:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appID] withParams:nil completionBlock:^(id obj) {

        NSArray * results = [obj objectForKey:@"results"];
        
        if([results count] == 0)
        {
            NSLog(@"Check update failed.");
            completionHandle(NO,[NSError errorWithDomain:@"Check update failed." code:100 userInfo:nil]);
            return ;
        }
        
        //取得最新版本信息
        NSDictionary * newInfo = [results objectAtIndex:0];
        NSString * newVersion = [newInfo objectForKey:@"version"];
        //取得本机版本信息
        NSDictionary * nowInfo = [[NSBundle mainBundle] infoDictionary];
        NSString * nowVersion = [nowInfo objectForKey:@"CFBundleVersion"];
        
        //比较版本信息
        if(nowVersion >= newVersion)
        {
            //已经是最新版本了
            NSLog(@"No update.");
            if (completionHandle) {
                
                completionHandle(NO,nil);
            }
        }
        else
        {
            //有更新版本
            NSLog(@"New Version");
            if(completionHandle){
                completionHandle(YES,nil);
            }
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        failureHandle(error,responseString);;
    }];
}

/**
 @desc POST 会员类
 */
//TODO:POST 会员类
- (void)post:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self post:[self mergeURL:Member] withParams:params completionBlock:^(id obj) {
        if([[obj objectForKey:@"IsOk"]isEqual:@(1)]){
            success([obj objectForKey:@"Obj"]);
        }else{
            failure(nil,[obj objectForKey:@"Error"]);
        }
    } failureBlock:failure];
}

/**
 @desc POST 会员类 List
 */
//TODO:POST 会员类 List
- (void)postList:(NSDictionary *)params completionBlock:(void (^)(id object,int count))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    [self post:[self mergeURL:Member] withParams:params completionBlock:^(id obj) {
        if([[obj objectForKey:@"IsOk"]isEqual:@(1)]){
            success([obj objectForKey:@"rows"],[[obj objectForKey:@"total"]intValue]);
        }else{
            failure(nil,[obj objectForKey:@"Error"]);
        }
    } failureBlock:failure];
}

/**
 @desc POST 收藏类
 */
//TODO:POST 收藏类
- (void)postCollection:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    [self post:[self mergeURL:Collection] withParams:params completionBlock:^(id obj) {
        if([[obj objectForKey:@"IsOk"]isEqual:@(1)]){
            success([obj objectForKey:@"Obj"]);
        }else{
            failure(nil,[obj objectForKey:@"Error"]);
        }
    } failureBlock:failure];
}

/**
 @desc POST 收藏类 List
 */
//TODO:POST 收藏类 List
- (void)postCollectionList:(NSDictionary *)params completionBlock:(void (^)(id object,int count))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    [self post:[self mergeURL:Collection] withParams:params completionBlock:^(id obj) {
        if([[obj objectForKey:@"IsOk"]isEqual:@(1)]){
            success([obj objectForKey:@"rows"],[[obj objectForKey:@"total"]intValue]);
        }else{
            failure(nil,[obj objectForKey:@"Error"]);
        }
    } failureBlock:failure];
}

/**
 @desc POST 消费记录类 List
 */
//TODO:POST 消费记录类 List
- (void)postMoneyList:(NSDictionary *)params completionBlock:(void (^)(id object,int count))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    [self post:[self mergeURL:Money] withParams:params completionBlock:^(id obj) {
        if([[obj objectForKey:@"IsOk"]isEqual:@(1)]){
            success([obj objectForKey:@"rows"],[[obj objectForKey:@"total"]intValue]);
        }else{
            failure(nil,[obj objectForKey:@"Error"]);
        }
    } failureBlock:failure];
}

/**
 @desc POST 消费记录类
 */
//TODO:POST 消费记录类
- (void)postMoney:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    [self post:[self mergeURL:Money] withParams:params completionBlock:^(id obj) {
        if([[obj objectForKey:@"IsOk"]isEqual:@(1)]){
            success([obj objectForKey:@"Obj"]);
        }else{
            failure(nil,[obj objectForKey:@"Error"]);
        }
    } failureBlock:failure];
}

/**
 @desc POST 评论类
 */
//TODO:POST 评论类
- (void)postEvaluate:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    [self post:[self mergeURL:Evaluate] withParams:params completionBlock:^(id obj) {
        if([[obj objectForKey:@"IsOk"]isEqual:@(1)]){
            success([obj objectForKey:@"Obj"]);
        }else{
            failure(nil,[obj objectForKey:@"Error"]);
        }
    } failureBlock:failure];
}


/**
 @desc POST 评论类 List
 */
//TODO:POST 评论类 List
- (void)postEvaluateList:(NSDictionary *)params completionBlock:(void (^)(id object,int count))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    [self post:[self mergeURL:Evaluate] withParams:params completionBlock:^(id obj) {
        if([[obj objectForKey:@"IsOk"]isEqual:@(1)]){
            success([obj objectForKey:@"rows"],[[obj objectForKey:@"total"]intValue]);
        }else{
            failure(nil,[obj objectForKey:@"Error"]);
        }
    } failureBlock:failure];
}

/**
 @desc POST 充值类
 */
//TODO:POST 充值类
- (void)postRecharge:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    [self post:[self mergeURL:Recharge] withParams:params completionBlock:^(id obj) {
        if([[obj objectForKey:@"IsOk"]isEqual:@(1)]){
            success([obj objectForKey:@"Obj"]);
        }else{
            failure(nil,[obj objectForKey:@"Error"]);
        }
    } failureBlock:failure];
}

/**
 @desc POST 充值类 List
 */
//TODO:POST 充值类 List
- (void)postRechargeList:(NSDictionary *)params completionBlock:(void (^)(id object,int count))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    [self post:[self mergeURL:Recharge] withParams:params completionBlock:^(id obj) {
        if([[obj objectForKey:@"IsOk"]isEqual:@(1)]){
            success([obj objectForKey:@"rows"],[[obj objectForKey:@"total"]intValue]);
        }else{
            failure(nil,[obj objectForKey:@"Error"]);
        }
    } failureBlock:failure];
}

/**
 @desc POST 优惠券类
 */
//TODO:POST 优惠券类
- (void)postCoupon:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    [self post:[self mergeURL:Coupon] withParams:params completionBlock:^(id obj) {
        if([[obj objectForKey:@"IsOk"]isEqual:@(1)]){
            success([obj objectForKey:@"Obj"]);
        }else{
            failure(nil,[obj objectForKey:@"Error"]);
        }
    } failureBlock:failure];
}

/**
 @desc POST 优惠券类 List
 */
//TODO:POST 优惠券类 List
- (void)postCouponList:(NSDictionary *)params completionBlock:(void (^)(id object,int count))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    [self post:[self mergeURL:Coupon] withParams:params completionBlock:^(id obj) {
        if([[obj objectForKey:@"IsOk"]isEqual:@(1)]){
            success([obj objectForKey:@"rows"],[[obj objectForKey:@"total"]intValue]);
        }else{
            failure(nil,[obj objectForKey:@"Error"]);
        }
    } failureBlock:failure];
}

/**
 @desc POST 订单类
 */
//TODO:POST 订单类
- (void)postOrder:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    [self post:[self mergeURL:OrderClaim] withParams:params completionBlock:^(id obj) {
        if([[obj objectForKey:@"IsOk"]isEqual:@(1)]){
            success([obj objectForKey:@"Obj"]);
        }else{
            failure(nil,[obj objectForKey:@"Error"]);
        }
    } failureBlock:failure];
}

/**
 @desc POST 订单类 List
 */
//TODO:POST 订单类 List
- (void)postOrderList:(NSDictionary *)params completionBlock:(void (^)(id object,int count))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    [self post:[self mergeURL:OrderClaim] withParams:params completionBlock:^(id obj) {
        if([[obj objectForKey:@"IsOk"]isEqual:@(1)]){
            success([obj objectForKey:@"rows"],[[obj objectForKey:@"total"]intValue]);
        }else{
            failure(nil,[obj objectForKey:@"Error"]);
        }
    } failureBlock:failure];
}

/**
 @desc POST 退款处理类
 */
//TODO:POST 退款处理类
- (void)postQuitMoney:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    [self post:[self mergeURL:QuitMoney] withParams:params completionBlock:^(id obj) {
        if([[obj objectForKey:@"IsOk"]isEqual:@(1)]){
            success([obj objectForKey:@"Obj"]);
        }else{
            failure(nil,[obj objectForKey:@"Error"]);
        }
    } failureBlock:failure];
}

/**
 @desc POST 保姆类 List
 */
//TODO:POST 保姆类 List
- (void)postNurseList:(NSDictionary *)params completionBlock:(void (^)(id object,int count))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    [self post:[self mergeURL:Nurse] withParams:params completionBlock:^(id obj) {
        if([[obj objectForKey:@"IsOk"]isEqual:@(1)]){
            success([obj objectForKey:@"rows"],[[obj objectForKey:@"total"]intValue]);
        }else{
            failure(nil,[obj objectForKey:@"Error"]);
        }
    } failureBlock:failure];
}

/**
 @desc POST 保姆
 */
//TODO:POST 保姆
- (void)postNurseMember:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    
    [self post:[self mergeURL:NurseMember] withParams:params completionBlock:^(id obj) {
        if([[obj objectForKey:@"IsOk"]isEqual:@(1)]){
            success([obj objectForKey:@"Obj"]);
        }else{
            failure(nil,[obj objectForKey:@"Error"]);
        }
    } failureBlock:failure];
}

/**
 @desc POST 保姆 List
 */
//TODO:POST 保姆 List
- (void)postNurseMemberList:(NSDictionary *)params completionBlock:(void (^)(id object,int count))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    
    [self post:[self mergeURL:NurseMember] withParams:params completionBlock:^(id obj) {
        if([[obj objectForKey:@"IsOk"]isEqual:@(1)]){
            success([obj objectForKey:@"rows"],[[obj objectForKey:@"total"]intValue]);
        }else{
            failure(nil,[obj objectForKey:@"Error"]);
        }
    } failureBlock:failure];
}

/**
 @desc POST 更多
 */
//TODO:POST 更多
- (void)postMore:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    [self post:[self mergeURL:More] withParams:params completionBlock:^(id obj) {
        if([[obj objectForKey:@"IsOk"]isEqual:@(1)]){
            success([obj objectForKey:@"Obj"]);
        }else{
            failure(nil,[obj objectForKey:@"Error"]);
        }
    } failureBlock:failure];
    
}

/**
 @desc POST 续时
 */
//TODO:POST 续时
- (void)postAddTime:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    [self post:[self mergeURL:AddTime] withParams:params completionBlock:^(id obj) {
        if([[obj objectForKey:@"IsOk"]isEqual:@(1)]){
            success([obj objectForKey:@"Obj"]);
        }else{
            failure(nil,[obj objectForKey:@"Error"]);
        }
    } failureBlock:failure];
}

/**
 @desc POST 微信
 */
//TODO:POST 微信
- (void)postWeiXin:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure{
    
    [self post:[self mergeURL:WeiXin] withParams:params completionBlock:^(id obj) {
        if([[obj objectForKey:@"IsOk"]isEqual:@(1)]){
            success([obj objectForKey:@"Obj"]);
        }else{
            failure(nil,[obj objectForKey:@"Error"]);
        }
    } failureBlock:failure];
}
@end
