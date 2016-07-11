//
//  UIView+MBProgressHUD.m
//  XWKit
//
//  Created by xiaowuxiaowu on 16/3/26.
//  Copyright © 2016年 xiaowuxiaowu. All rights reserved.
//

#import "UIView+MBProgressHUD.h"
#import <objc/runtime.h>

@implementation UIView (MBProgressHUD)
static char const hudKey = '\0';

-(MBProgressHUD *)getHUD{
    return objc_getAssociatedObject(self, &hudKey);
}
-(void)setHUD:(MBProgressHUD *)hud{
    objc_setAssociatedObject(self, &hudKey, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void )xw_showHUD{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        [self setHUD:hud];
    });
  
}

-(void)xw_hideHUD{

    dispatch_async(dispatch_get_main_queue(), ^{
         [[self getHUD]hide:YES];
    });
   
}
-(void)xw_showHUDWithTitle:(NSString *)title{
   
    [self xw_showHUD];
    [self getHUD].labelText = title;
}

-(void)xw_showHUDWithProgressTitle:(NSString *)title{
   [self xw_showHUD];
    [self getHUD].labelText = title;
    [self getHUD].mode = MBProgressHUDModeAnnularDeterminate;//MBProgressHUDModeDeterminateHorizontalBar //进度条
}

-(void)xw_showHUDWorkWithProgress:(CGFloat )progress{
    [self getHUD].progress = progress;
}


static const CGFloat xw_HUDafterDelay = 1.5f;
-(void)xw_hideHUDafterDelay:(NSString *)title{
    
   
    MBProgressHUD *hud = [self getHUD];
    if(!hud){
     [self xw_showHUD];
    }
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // Optional label text.
    hud.labelText = title;
   [self xw_hideAfterDelay:xw_HUDafterDelay];

}
-(void)xw_hideTitle:(NSString *)title{

    MBProgressHUD *hud = [self getHUD];
    if(!hud){
        [self xw_showHUD];
    }
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    //hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    [self xw_hideAfterDelay:xw_HUDafterDelay];
    
}

-(void)xw_hideAfterDelay:(CGFloat)delay{
    dispatch_async(dispatch_get_main_queue(), ^{
          [[self getHUD] hide:YES afterDelay:delay];
    });
  
}


@end
