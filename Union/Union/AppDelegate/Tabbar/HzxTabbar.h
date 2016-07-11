//
//  HzxTabbar.h
//  GPiao
//
//  Created by xiaowuxiaowu on 15/12/27.
//  Copyright © 2015年 xiaowuxiaowu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HzxTabBarDelegate <NSObject>

@optional

- (void)ChangSelIndexForm:(NSInteger)from to:(NSInteger)to;
- (BOOL)willChangSelIndexForm:(NSInteger)from to:(NSInteger)to;
@end


@interface HzxTabbar : UIView
@property (nonatomic,weak) id<HzxTabBarDelegate> delegate;

- (void)addImageView;
- (void)addBarButtonWithNorName:(NSString *)nor andDisName:(NSString *)dis andTitle:(NSString *)title;
- (void)selectButtonIndex:(NSInteger )toIndex normal:(NSInteger )formIndex;
@end
