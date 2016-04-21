//
//  HttpService.h
//  HWSDK
//
//  Created by Carl on 13-11-28.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import "AFHttp.h"

//会员类
#define Member                     @"MemberCenter.ashx"
//收藏类
#define Collection                 @"CompanyEmployersFavorites.ashx"
//消费记录类
#define Money                      @"MemberMoneyLog.ashx"
//评论类
#define Evaluate                   @"CompanyReview.ashx"
//充值类
#define Recharge                   @"CompanyRechargeRecord.ashx"
//优惠券类
#define Coupon                     @"CompanyCouponInit.ashx"
//订单类
#define OrderClaim                      @"CompanyOrderClaim.ashx"
//退款处理类
#define QuitMoney                  @"MemberOnlineMoneyLog.ashx"
//保姆类
#define Nurse                      @"NurseMemTypesettingRecord.ashx"
//获取保姆列表
#define NurseMember                       @"CompanyNurseMemberCenter.ashx"
//更多类
#define More                      @"OtherInformation.ashx"
//续时类
#define AddTime                      @"CompanyOrderAdditionals.ashx"
//微信支付类
#define WeiXin                      @"CompanyWeiPay.ashx"

@interface HttpService : AFHttp
@property (nonatomic,strong) NSString* userName;

+ (HttpService *)sharedInstance;

/**
 @desc 检测APP更新
 */
//TODO:检测APP更新
- (void)checkUpdate:(NSString *)appID compleitionBlock:(void (^)(BOOL hasNew,NSError * error))completionHandle failureBlock:(void (^)(NSError * error,NSString * responseString))failureHandle;

/**
 @desc POST 会员类
 */
//TODO:POST 会员类
- (void)post:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc POST 会员类 List
 */
//TODO:POST 会员类 List
- (void)postList:(NSDictionary *)params completionBlock:(void (^)(id object,int count))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc POST 收藏类
 */
//TODO:POST 收藏类
- (void)postCollection:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc POST 收藏类 List
 */
//TODO:POST 收藏类 List
- (void)postCollectionList:(NSDictionary *)params completionBlock:(void (^)(id object,int count))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc POST 消费记录类
 */
//TODO:POST 消费记录类
- (void)postMoney:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc POST 消费记录类 List
 */
//TODO:POST 消费记录类 List
- (void)postMoneyList:(NSDictionary *)params completionBlock:(void (^)(id object,int count))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc POST 评论类
 */
//TODO:POST 评论类
- (void)postEvaluate:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc POST 评论类 List
 */
//TODO:POST 评论类 List
- (void)postEvaluateList:(NSDictionary *)params completionBlock:(void (^)(id object,int count))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc POST 充值类
 */
//TODO:POST 充值类
- (void)postRecharge:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc POST 充值类 List
 */
//TODO:POST 充值类 List
- (void)postRechargeList:(NSDictionary *)params completionBlock:(void (^)(id object,int count))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc POST 优惠券类
 */
//TODO:POST 优惠券类
- (void)postCoupon:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

 /**
 @desc POST 优惠券类 List
 */
//TODO:POST 优惠券类 List
- (void)postCouponList:(NSDictionary *)params completionBlock:(void (^)(id object,int count))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc POST 订单类
 */
//TODO:POST 订单类
- (void)postOrder:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc POST 订单类 List
 */
//TODO:POST 订单类 List
- (void)postOrderList:(NSDictionary *)params completionBlock:(void (^)(id object,int count))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc POST 退款处理类
 */
//TODO:POST 退款处理类
- (void)postQuitMoney:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc POST 保姆类 List
 */
//TODO:POST 保姆类 List
- (void)postNurseList:(NSDictionary *)params completionBlock:(void (^)(id object,int count))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc POST 保姆
 */
//TODO:POST 保姆
- (void)postNurseMember:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc POST 保姆 List
 */
//TODO:POST 保姆 List
- (void)postNurseMemberList:(NSDictionary *)params completionBlock:(void (^)(id object,int count))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc POST 更多
 */
//TODO:POST 更多
- (void)postMore:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc POST 续时
 */
//TODO:POST 续时
- (void)postAddTime:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc POST 微信
 */
//TODO:POST 微信
- (void)postWeiXin:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

@end