//
//  AppMacros.h
//  ZhuZhu
//
//  Created by Carl on 15/1/28.
//  Copyright (c) 2015年 Vison. All rights reserved.
//

#define NavColor [UIColor colorWithRed:246.0/255.0 green:208.0/255.0 blue:75.0/255.0 alpha:1.0]
//#define CommonColor [UIColor colorWithRed:242.0/255.0 green:186.0/255.0 blue:99.0/255.0 alpha:1.0]
#define CommonColor [UIColor colorWithRed:246.0/255.0 green:208.0/255.0 blue:75.0/255.0 alpha:1.0]
//--------------------Http Macros------------------//
#define REQ_CLIENT_TYPE                     @"req_client_type"
#define TOKEN                               @"token"
#define REQ_IS_SECURE                       @"req_is_secure"
#define LANG                                @"lang"

#define Res_URL_Prefix                      @"http://www.usoiso.com/AjaxSources/youxunInterface/"
//#define Res_URL_Prefix                      @"http://192.168.1.112:8081/AjaxSources/youxunInterface/"
//#define Res_URL_Prefix                      @"http://120.24.153.244:8081/AjaxSources/youxunInterface/"
#define Maxlen                              @"10"


//状态码
#define AT_LoginFirst @"1365"//登陆第一步
#define AT_LoginSecond @"1366"//登陆第二步，提供验证码
#define AT_Logout @"1364"//退出登陆
#define AT_Personal_Info @"1361"//获取个人资料
#define AT_Personal_Info_EnCryp @"1367"//获取个人资料(加密)
#define AT_Edit_Personal_Info @"1362"//修改个人资料
#define AT_Money @"1363"//查看余额
#define AT_Recharge @"1368"//充值
#define AT_Begin_Server @"1369"//扫码开始服务
#define AT_MakeSure_Server @"1370"//扫码开始服务
#define AT_Portrait @"1371"//上传头像
#define AT_MyEvaluate @"1372"//我的评论

#define AT_Collection @"100"//获取收藏列表
#define AT_Collection_Detial_EnCryp @"104"//获取收藏列表条目详情(加密)
#define AT_Add_Collection @"101"//添加收藏条目
#define AT_Del_Collection @"103"//删除收藏条目
#define AT_IsCollection @"105"//根据该会员是否已经收藏了该保姆

#define AT_MoneyLog @"1588"//消费记录
#define AT_MoneyLog_Count @"1589"//消费记录条数

#define AT_Add_Evaluate @"1020"//添加评论
#define AT_Evaluate @"1021"//获取评论列表

#define AT_RechargeRecord @"1578"//查看充值记录
#define AT_Change_RechargeRecord_State @"1581"//改变充值记录状态(注：到账成功的时候，需要改变充值记录的状态才能把虚拟币写到会员身上)

#define AT_Share_FirstTime @"880"//首次分享赠送优惠券
#define AT_Coupon @"884"//优惠券列表
#define AT_Coupon_Detial @"885"//优惠券详情
#define AT_Coupon_Use @"886"//使用优惠券

#define AT_OrderNum_Create @"1119"//产生订单号
#define AT_Order_Exact @"1120"//精准下单
#define AT_Order_Allot_Aunt @"1121"//查询家政公司的为该订单已分配的保姆信息
#define AT_Order_Choose_Aunt @"1122"//雇主选中保姆id
#define AT_Order @"1123"//所有订单列表
#define AT_Order_Detial @"1124"//根据会员和订单加密id查询该订单详情信息
#define AT_Order_Edit @"1125"//修改支付方式或者兑换卷使用 即提交订单的操作
#define AT_Order_OneKey @"1126"//快速下单
#define AT_Order_OneKey_Cost @"1127"//显示服务时长单价即 xx元/每小时(为快速下单准备的)
#define AT_Order_Pay_Succes @"1128"//支付成功操作  如果支付成功，则做一下记录和操作  注： state 状态  只支持两个状态： 3.正常服务订单状态改变为已付款 6.加时服务订单状态改变为已付款
#define AT_Order_AllowAddTime @"1130"//会员是否可以加时服务
#define AT_Order_AddTime @"1131"//会员加时
#define AT_Order_ApplyRefund @"1133"//申请退款
#define AT_Order_Del @"1134"//删除订单
#define AT_Order_Del_AddTime @"1137"//删除加时订单

#define AT_Order_Refund @"2530"//处理所有的可以退款的订单操作
#define AT_Order_Refund_State @"2531"//处理退款操作成功之后改变退款状态

#define AT_Nurse_ServerTime @"1280"//根据日期和时长查询服务时间
#define AT_Nurse_Time @"1283"//根据日期查询服务时间（保姆）

#define AT_More_Get @"1860"//获取相关资料
#define AT_More_Opinion @"1861"//意见反馈
#define AT_More_Evaluate @"1862"//评分

#define AT_AddTime_Order_Detial @"3360"//根据加时订单加密id查询加时订单信息
#define AT_AddTime_Order_Edit @"3361"//修改支付方式或者兑换卷使用 即提交加时订单的操作
#define AT_AddTime_Order_Pay_Succes @"3362"//加时订单支付成功操作

#define AT_WeiXin_Pay @"12610"//微信支付
#define AT_WeiXin_Recharge @"12611"//微信充值

//-------------------Http Err Code------------------------//
#define NO_Error 200

//-------------------Key------------------------//
#define MD5KEY @"@#44sDF@#$#@12qwEWQ"
#define APP_ID @"989674437"

#import "FunctionMacros.h"


