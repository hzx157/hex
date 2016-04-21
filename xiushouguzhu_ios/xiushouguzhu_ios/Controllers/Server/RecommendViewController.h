//
//  RecommendViewController.h
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/16.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import "CommonViewController.h"

@interface RecommendViewController : CommonViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) void (^NurseIDBlock)();
@property (nonatomic,strong) NSString * EnCrypId;

@end
