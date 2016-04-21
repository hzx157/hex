//
//  NFXIntroViewController.h
//
//  Created by Sawyer on 2015/01/04.
//  Copyright (c) 2015年 Sawyer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^NFXIntroBlock)(NSMutableArray *);

@interface NFXIntroViewController : UIViewController<UIAlertViewDelegate>
@property (strong, nonatomic) NFXIntroBlock block;
-(id)initWithViews:(NSArray*)images atIndex:(int)index browseMode:(BOOL)isBrowseMode urlMode:(BOOL)isUrlMode receiveBlock:(NFXIntroBlock)receiveBlock;
@end
