//
//  UITextView+Placeholder.m
//  LingTong
//
//  Created by Carl on 14-3-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "UITextView+Placeholder.h"
#import "UIColor+Utils.h"
#import <objc/runtime.h>

static UILabel *PlaceholderLabel;
@implementation UITextView (Placeholder)

- (void)setPlaceholder:(NSString *)placeholder
{
    [PlaceholderLabel removeFromSuperview];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidChange:) name:UITextViewTextDidChangeNotification object:self];
    
    float left=5,top=8;
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    
    PlaceholderLabel=[[UILabel alloc] initWithFrame:CGRectMake(left, top
                                                               , screenHeight*(self.frame.size.height/320.0)-left, screenWidth*(self.frame.size.width/320.0))];
    PlaceholderLabel.font=self.font;
    PlaceholderLabel.textColor=[UIColor lightGrayColor];
    PlaceholderLabel.text=placeholder;
    PlaceholderLabel.numberOfLines = 0;
    [PlaceholderLabel sizeToFit];
    [self addSubview:PlaceholderLabel];
}

-(void)DidChange:(NSNotification*)noti{
    if (PlaceholderLabel.text.length == 0 || [PlaceholderLabel.text isEqualToString:@""]) {
        PlaceholderLabel.hidden=YES;
    }
    if (self.text.length > 0) {
        PlaceholderLabel.hidden=YES;
    }
    else{
        PlaceholderLabel.hidden=NO;
    }
    
    
}

- (void)tapMySelf:(UITapGestureRecognizer *)tap
{
    self.textColor = [UIColor blackColor];
    id holder = objc_getAssociatedObject(self, &@selector(tapMySelf:));
    if([self.text isEqualToString:holder] || [self.text length] == 0)
    {
        [self becomeFirstResponder];
        self.text = nil;
    }
}
@end
