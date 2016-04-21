//
//  EvaluateTextViewCell.h
//  xiushouguzhu_ios
//
//  Created by Interest on 15/3/16.
//  Copyright (c) 2015年 Interest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluateTextViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UITextView *tvEvaluate;

@property (strong, nonatomic) IntBlock block;

- (void)waitBlock:(IntBlock)block;

@end
