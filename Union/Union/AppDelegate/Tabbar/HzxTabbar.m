//
//  HzxTabbar.m
//  GPiao
//
//  Created by xiaowuxiaowu on 15/12/27.
//  Copyright © 2015年 xiaowuxiaowu. All rights reserved.
//

#import "HzxTabbar.h"
#import "HzxBarButton.h"

@interface HzxTabbar()
{
    HzxBarButton *tbtn;
    HzxBarButton *tbtn0;

}
@property(nonatomic,strong) HzxBarButton *selButton;
@property(nonatomic,strong) UIImageView *imgView;
@property(nonatomic,strong) HzxBarButton *carButton;
@property (nonatomic,strong)NSMutableArray *btnArray;
@end

@implementation HzxTabbar


- (void)addImageView
{
    UIImageView *imgView = [[UIImageView alloc]init];
    imgView.image = [UIImage imageNamed:@"grid_control_view_bg_black"];
    self.imgView = imgView;
    [self addSubview:imgView];

    self.btnArray = [NSMutableArray new];
}

#pragma mark - /************************* 通过传入数据赋值图片 ***************************/
- (void)addBarButtonWithNorName:(NSString *)nor andDisName:(NSString *)dis andTitle:(NSString *)title
{
    static NSInteger tag = 0;
    tbtn = [[HzxBarButton alloc]init];
    tbtn.tag = tag;
    [tbtn setImage:[UIImage imageNamed:nor] forState:UIControlStateNormal];
    [tbtn setImage:[UIImage imageNamed:dis] forState:UIControlStateSelected];
    [tbtn setBackgroundImage:ImageNamed(@"") forState:UIControlStateNormal];
    [tbtn setBackgroundImage:ImageNamed(@"trade_ex_menu_bg") forState:UIControlStateSelected];
    tbtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [tbtn setTitle:title forState:UIControlStateNormal];
    [tbtn setTitleColor:[UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1] forState:UIControlStateNormal];
     [tbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];

    [tbtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:tbtn];
    tbtn.selected = NO;
    
    [self.btnArray addObject:tbtn];
 
//    // 让第二个按钮默认为选中状态
    if (tbtn.tag == 1) {
    
        [self btnClick:tbtn];
    }
       tag ++;
    if (tbtn.tag==0) {
        tbtn0=tbtn;
//        [tbtn showBadgeOnItemIndex:tbtn.tag];
    }
}


#pragma mark - /************************* 动态加载时设置frame值 ***************************/
- (void)layoutSubviews
{
    [super layoutSubviews];

    UIImageView *imgView = self.subviews[0];
    imgView.frame = self.bounds;
    
    for (int i = 0; i<self.btnArray.count; i++) { // $$$$$
        
     
        
        UIButton *btn = self.btnArray[i];//self.subviews[i];
        CGFloat btnW = IPHONE_WIDTH/4;
        CGFloat btnH = 49;
        CGFloat btnX = (i) * btnW;
        CGFloat btnY = 0;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        // 绑定tag 便于后面使用
    //    btn.tag = i-1;
    }
}

-(void)selectButtonIndex:(NSInteger)toIndex normal:(NSInteger)formIndex{
    HzxBarButton *button = self.btnArray[toIndex];
    [self btnClick:button];
}
#pragma mark - /************************* 按钮点下方法 ***************************/
- (void)btnClick:(HzxBarButton *)btn
{


    // 将要跳转
    if ([self.delegate respondsToSelector:@selector(ChangSelIndexForm:to:)]) {
        if(![self.delegate willChangSelIndexForm:_selButton.tag to:btn.tag]){
            return;
        }
    }
    
    
    
    // 响应代理方法 实现页面跳转
    if ([self.delegate respondsToSelector:@selector(ChangSelIndexForm:to:)]) {
        [self.delegate ChangSelIndexForm:_selButton.tag to:btn.tag];
    }
    // 设置按钮显示状态 并切换选中按钮
   _selButton.selected = NO;
    
  
    btn.selected =YES;
      _selButton = btn;
}



@end
