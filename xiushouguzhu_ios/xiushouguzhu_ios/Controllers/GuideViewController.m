//
//  GuideViewController.m
//  Poly
//
//  Created by Interest on 15/1/31.
//  Copyright (c) 2015年 helloworld. All rights reserved.
//

#import "GuideViewController.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface GuideViewController (){
    
    IBOutlet UIImageView* ivBg;
    IBOutlet UIScrollView* scrollView;
    UIImageView* imgView;
    UIButton* startButton;
    
}

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    int count=3;
    ivBg.image = [UIImage imageNamed:@"LaunchImage"];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces=NO;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*count, SCREEN_HEIGHT);
    scrollView.pagingEnabled = YES;

    
    for (int i=1; i<=count; i++) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i-1)*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat: @"start%d",i]];
        [scrollView addSubview:imageView];
        if (i == count) {
            imgView=imageView;
            UIButton* start = [UIButton buttonWithType:UIButtonTypeCustom];
            start.frame = CGRectMake(0, 0, 100, 100);
            [start setCenter:CGPointMake(SCREEN_WIDTH*2.5,SCREEN_HEIGHT/5*4)];
            //[start setBackgroundColor:[UIColor colorWithRed:0 green:134.0/255.0 blue:210.0/255.0 alpha:1.0]];
            [start setBackgroundColor:[UIColor clearColor]];
            [start setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [start addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
            //[start setTitle:@"立即体验" forState:UIControlStateNormal];
            [scrollView addSubview:start];
            startButton=start;
        }
    }
}

- (void)closeView{
    [UIView animateWithDuration:1.5 animations:^{
        imgView.frame=CGRectMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 0, 0);
        imgView.alpha=0.2;
        startButton.alpha=0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:YES completion:nil];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:@"YES" forKey:@"AppStartFirstTime"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
