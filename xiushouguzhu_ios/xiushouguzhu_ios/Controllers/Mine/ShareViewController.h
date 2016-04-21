//
//  ShareViewController.h
//  xiushouguzhu_ios
//
//  Created by Interest on 15/4/8.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "CommonViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface ShareViewController : CommonViewController

@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *imagePath;
@property(nonatomic,strong)NSString *theTitle;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,assign)SSPublishContentMediaType mediaType;

@end
