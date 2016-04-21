//
//  ShowImageView.m
//  Poly
//
//  Created by Interest on 15/1/28.
//  Copyright (c) 2015年 helloworld. All rights reserved.
//

#import "ShowImageView.h"

static CGRect oldframe;
static UIImageView *imageView;
@implementation ShowImageView
+(void)showImage:(UIImageView *)avatarImageView{
    UITapGestureRecognizer *magnifyImage=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(magnifyImage:)];
    avatarImageView.userInteractionEnabled=YES;
    [avatarImageView addGestureRecognizer:magnifyImage];
    imageView=avatarImageView;
}

+(void)magnifyImage:(id)sender{
    UIImage *image=imageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    oldframe=[imageView convertRect:imageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *closeTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: closeTap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-[UIScreen mainScreen].bounds.size.width)/2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

+(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}
@end
