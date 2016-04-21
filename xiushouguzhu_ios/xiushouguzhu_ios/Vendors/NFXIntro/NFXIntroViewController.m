//
//  NFXIntroViewController.m
//
//  Created by Sawyer on 2015/01/04.
//  Copyright (c) 2015年 Sawyer. All rights reserved.
//

#import "NFXIntroViewController.h"
//#import "UIImageView+AFNetworking.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define nextText @"next"
#define startText @"start"

@interface NFXIntroViewController ()<UIScrollViewDelegate>{
    UIScrollView*_scrollview;
    UIButton*_buttondel;
    UIButton*_buttonreturn;
    UIPageControl*_pgcontrol;
//    NSArray*_images;
    UIImageView*_backgroundimageview;
    NSMutableArray*imageViewArr;
    NSMutableArray*delTagArr;
    BOOL isUrl;
}

@end

@implementation NFXIntroViewController

-(id)initWithViews:(NSArray*)images atIndex:(int)index browseMode:(BOOL)isBrowseMode urlMode:(BOOL)isUrlMode receiveBlock:(NFXIntroBlock)receiveBlock{
    self = [super init];
    if (self) {
        isUrl=isUrlMode;
        delTagArr=[[NSMutableArray alloc]init];
        imageViewArr=[[NSMutableArray alloc]init];
        self.block = receiveBlock;
        //check views length
        NSAssert(images.count!=0, @".views's length is zero.");
        
        /**
         *  setup viewcontroller
         */
        self.view.backgroundColor = [UIColor blackColor];
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        /**
         *  positions
         */
        CGRect svrect_ = CGRectZero;
        svrect_.size.height = self.view.bounds.size.height/5*4;
        svrect_.size.width = self.view.bounds.size.width;
        CGPoint svcenter_ = CGPointZero;
        svcenter_.x = self.view.center.x;
        svcenter_.y = self.view.center.y-30;
        CGSize svconsize = CGSizeZero;
        svconsize.height = svrect_.size.height;
        svconsize.width = svrect_.size.width * images.count;
        
        CGPoint pgconcenter_ = CGPointZero;
        pgconcenter_.x = self.view.center.x;
        pgconcenter_.y = svcenter_.y + (svrect_.size.height/2) + 15;
        
        CGRect btndelrect_ = CGRectZero;
        btndelrect_.size.width = 100;
        btndelrect_.size.height = 40;
        CGPoint btndelcenter_ = CGPointZero;
        btndelcenter_.x = self.view.center.x/2;
        btndelcenter_.y = self.view.bounds.size.height-30;
        
        CGRect btnreturnrect_ = CGRectZero;
        btnreturnrect_.size.width = 100;
        btnreturnrect_.size.height = 40;
        CGPoint btnreturncenter_ = CGPointZero;
        btnreturncenter_.x = self.view.center.x/2*3;
        btnreturncenter_.y = self.view.bounds.size.height-30;
        
        UIImage* fill = createImageFromUIColor([UIColor colorWithWhite:0.9 alpha:1]);
        
        
        /*
         Views
         */
        _backgroundimageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_backgroundimageview];
        
        _scrollview = [[UIScrollView alloc] initWithFrame:svrect_];
        _scrollview.center = svcenter_;
        _scrollview.backgroundColor = [UIColor blackColor];
        _scrollview.contentSize = svconsize;
        _scrollview.pagingEnabled = true;
        _scrollview.bounces = false;
        _scrollview.delegate = self;
        _scrollview.showsHorizontalScrollIndicator = false;
        _scrollview.layer.cornerRadius = 2;
        [self.view addSubview:_scrollview];
        
        _pgcontrol = [[UIPageControl alloc] initWithFrame:CGRectZero];
        _pgcontrol.pageIndicatorTintColor = [UIColor colorWithWhite:0.2 alpha:1];
        _pgcontrol.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.6 alpha:1];
        _pgcontrol.numberOfPages = images.count;
        _pgcontrol.currentPage = 0;
        [_pgcontrol sizeToFit];
        _pgcontrol.center = pgconcenter_;
        [self.view addSubview:_pgcontrol];
        
        _buttondel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttondel addTarget:self action:@selector(ButtonDelPushed:) forControlEvents:UIControlEventTouchDown];
        [_buttondel setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateNormal];
        [_buttondel setTitle:@"删除" forState:UIControlStateNormal];
        [_buttondel setBackgroundImage:fill forState:UIControlStateHighlighted];
        _buttondel.clipsToBounds = true;
        _buttondel.frame = btndelrect_;
        _buttondel.center = btndelcenter_;
        _buttondel.layer.cornerRadius = 4;
        _buttondel.layer.borderWidth = 0.5f;
        _buttondel.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
        if (!isBrowseMode) {
            [self.view addSubview:_buttondel];
        }else{
            btnreturnrect_.size=CGSizeMake(200, 40);
            btnreturncenter_.x=self.view.center.x;
        }
        
        _buttonreturn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonreturn addTarget:self action:@selector(ButtonReturnPushed:) forControlEvents:UIControlEventTouchDown];
        [_buttonreturn setTitleColor:[UIColor colorWithWhite:1 alpha:0.7] forState:UIControlStateNormal];
        [_buttonreturn setTitle:@"返回" forState:UIControlStateNormal];
        [_buttonreturn setBackgroundImage:fill forState:UIControlStateHighlighted];
        _buttonreturn.clipsToBounds = true;
        _buttonreturn.frame = btnreturnrect_;
        _buttonreturn.center = btnreturncenter_;
        _buttonreturn.layer.cornerRadius = 4;
        _buttonreturn.layer.borderWidth = 0.5f;
        _buttonreturn.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
        
        [self.view addSubview:_buttonreturn];
        
        int index_ = 0;
        CGPoint imgCenter_= CGPointZero;
        UIImage *placeholderImage=[UIImage imageNamed:@"载入中"];
        placeholderImage=[self scaleFromImage:placeholderImage toSize:CGSizeMake(svrect_.size.width, svrect_.size.height)];
        if (isUrlMode){
            for (NSURL *url in images) {
                float coefficient=0;
                
                UIImageView*iv_ = [[UIImageView alloc] init];
                iv_.contentMode = UIViewContentModeScaleAspectFill;
                iv_.clipsToBounds = true;
//                [iv_ setImageWithURL:url placeholderImage:placeholderImage];
                coefficient=iv_.image.size.width/svrect_.size.width;
                coefficient=iv_.image.size.height/svrect_.size.height>coefficient?iv_.image.size.height/svrect_.size.height:coefficient;
                NSAssert([iv_.image isKindOfClass:[UIImage class]],@".views are not only UIImage.");
                CGRect ivrect_ = CGRectMake(0,0,
                                            iv_.image.size.width/coefficient,
                                            iv_.image.size.height/coefficient);
                imgCenter_.x=_scrollview.bounds.size.width * (index_+0.5);
                imgCenter_.y=_scrollview.bounds.size.height/2;
                [iv_ setFrame:ivrect_];
                iv_.center = imgCenter_;
                [_scrollview addSubview:iv_];
                index_++;
                [imageViewArr addObject:iv_];
            }

        }else{
            for (UIImage*image_ in images) {
                float coefficient=0;
                coefficient=image_.size.width/svrect_.size.width;
                coefficient=image_.size.height/svrect_.size.height>coefficient?image_.size.height/svrect_.size.height:coefficient;
//                NSAssert([image_ isKindOfClass:[UIImage class]],@".views are not only UIImage.");
                CGRect ivrect_ = CGRectMake(0,0,
                                            image_.size.width/coefficient,
                                            image_.size.height/coefficient);
                UIImageView*iv_ = [[UIImageView alloc] initWithFrame:ivrect_];
                imgCenter_.x=_scrollview.bounds.size.width * (index_+0.5);
                imgCenter_.y=_scrollview.bounds.size.height/2;
                iv_.center = imgCenter_;
                iv_.contentMode = UIViewContentModeScaleAspectFill;
                iv_.clipsToBounds = true;
                iv_.image = image_;
                [_scrollview addSubview:iv_];
                index_++;
                [imageViewArr addObject:iv_];
            }

        }
        CGRect rect = _scrollview.frame;
        rect.origin.x = rect.size.width * (index);
        [_scrollview scrollRectToVisible:rect animated:YES];
    }
    return self;
}

-(void)ButtonDelPushed:(UIButton*)button{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"不发表这张照片?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"是的", nil];
    [alertView show];
   
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        int page_ = (int)round(_scrollview.contentOffset.x / _scrollview.frame.size.width);
        [UIView animateWithDuration:0.3 animations:^{
            [[imageViewArr objectAtIndex:page_]removeFromSuperview];
            [imageViewArr removeObjectAtIndex:page_];
            CGRect rect;
            for (int i=page_; i<imageViewArr.count; i++) {
                rect=((UIImageView*)[imageViewArr objectAtIndex:i]).frame;
                ((UIImageView*)[imageViewArr objectAtIndex:i]).frame=CGRectMake(rect.origin.x-_scrollview.frame.size.width, rect.origin.y, rect.size.width, rect.size.height);
            }
            [delTagArr addObject:[NSString stringWithFormat:@"%d",page_]];
            _scrollview.contentSize = CGSizeMake(_scrollview.contentSize.width-_scrollview.frame.size.width, _scrollview.contentSize.height);
            _pgcontrol.numberOfPages-=1;
        }completion:^(BOOL finished) {
            if (imageViewArr.count==0) {
                if(self.block)
                {
                    self.block(delTagArr);
                }
                [self dismissViewControllerAnimated:true completion:nil];
            }
        }];
    }
}

-(void)ButtonReturnPushed:(UIButton*)button{
    if(self.block)
    {
        self.block(delTagArr);
    }
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page_ = (int)round(scrollView.contentOffset.x / scrollView.frame.size.width);
    _pgcontrol.currentPage = page_;
    if(isUrl){
        float coefficient;
        coefficient=((UIImageView*)[imageViewArr objectAtIndex:page_]).image.size.width/_scrollview.frame.size.width;
        coefficient=((UIImageView*)[imageViewArr objectAtIndex:page_]).image.size.height/_scrollview.frame.size.height>coefficient?((UIImageView*)[imageViewArr objectAtIndex:page_]).image.size.height/_scrollview.frame.size.height:coefficient;
//        NSAssert([image_ isKindOfClass:[UIImage class]],@".views are not only UIImage.");
        CGRect ivrect_ = CGRectMake(0,0,
                                    ((UIImageView*)[imageViewArr objectAtIndex:page_]).image.size.width/coefficient,
                                    ((UIImageView*)[imageViewArr objectAtIndex:page_]).image.size.height/coefficient);
        CGPoint imgCenter_= CGPointZero;
        imgCenter_.x=_scrollview.bounds.size.width * (page_+0.5);
        imgCenter_.y=_scrollview.bounds.size.height/2;
        ((UIImageView*)[imageViewArr objectAtIndex:page_]).frame=ivrect_;
        ((UIImageView*)[imageViewArr objectAtIndex:page_]).center=imgCenter_;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

UIImage *(^createImageFromUIColor)(UIColor *) = ^(UIColor *color)
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [color CGColor]);
    CGContextFillRect(contextRef, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
};

// 改变图像尺寸
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
