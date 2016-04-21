//
//  RegularVerify.h
//  Poly
//
//  Created by Interest on 14/12/19.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegularVerify : NSObject

+(BOOL)verifyMobilePhone:(NSString *)mobilePhone;
+(BOOL)verify:(NSString *)mobilePhone ByRegular:(NSString *)regular;
@end
