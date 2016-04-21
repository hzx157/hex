//
//  ServerTimeViewController.h
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/16.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "CommonViewController.h"
#import "ZHPickView.h"

@interface ServerTimeViewController : CommonViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ZHPickViewDelegate>

@property (nonatomic,assign) BOOL isPush;
@property (strong,nonatomic) NSString *EnCrypId;
@property (strong,nonatomic) void (^IntervalTimeBlock)(NSString *str);

@end
