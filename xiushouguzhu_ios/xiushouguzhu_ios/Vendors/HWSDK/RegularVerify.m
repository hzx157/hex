//
//  RegularVerify.m
//  Poly
//
//  Created by Interest on 14/12/19.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "RegularVerify.h"

@implementation RegularVerify

+(BOOL)verifyMobilePhone:(NSString *)mobilePhone{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"] evaluateWithObject:mobilePhone];
}


+(BOOL)verify:(NSString *)mobilePhone ByRegular:(NSString *)regular{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular] evaluateWithObject:mobilePhone];
}
@end
