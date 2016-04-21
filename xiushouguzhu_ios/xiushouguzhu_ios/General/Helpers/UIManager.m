//
//  ControlCenter.m
//  
//
//  Created by Carl on 13-12-31.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LoginViewController.h"
@implementation UIManager
+ (instancetype)sharedManager
{
    static UIManager * this = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        this = [[self alloc] init];
    });
    return this;
}



+ (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
+(BOOL)isLogin{
    return [self appDelegate].sessionId;
}
+ (UIWindow *)keyWindow
{
    return [[UIApplication sharedApplication] keyWindow];
}

+ (UIWindow *)newWindow
{
    UIWindow * window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    return window;
}

+ (void)makeKeyAndVisible
{
    [[self class] customNavAppearance];
    AppDelegate * appDelegate = [[self class] appDelegate];
    appDelegate.window = [[self class] newWindow];
   __block AKTabBarController *akTabBarController= [[AKTabBarController alloc] initWithTabBarHeight:56];
    akTabBarController.tabTitleIsHidden = YES;
    MainViewController * vc = [[MainViewController alloc] initWithNibName:ScreenHeight==480?@"MainViewController_4S":@"MainViewController" bundle:[NSBundle mainBundle]];
    UINavigationController *nav1 = [[self class] navWithRootVC:vc];
    UINavigationController *nav2 =  [[self class] navWithRootVC:[[self class] viewControllerWithName:@"OrderViewController"]];
    
    //ServerViewController //OneKeyOrderViewController
    UINavigationController *nav3 =  [[self class] navWithRootVC:[[self class] viewControllerWithName:@"ServerViewController"]];
    UINavigationController *nav4 =  [[self class] navWithRootVC:[[self class] viewControllerWithName:@"MineViewController"]];
    UINavigationController *nav5 =  [[self class] navWithRootVC:[[self class] viewControllerWithName:@"MoreViewController"]];
    [akTabBarController setViewControllers:[NSMutableArray arrayWithObjects:nav1,nav2,nav3,nav4,nav5,nil]];
//    [akTabBarController setSelectedIconColors:@[[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor]]];
    [akTabBarController setSelectedIconColors:@[[UIColor colorWithRed:242.0/255.0 green:181.0/255.0 blue:77.0/255.0 alpha:1.0],[UIColor colorWithRed:242.0/255.0 green:181.0/255.0 blue:77.0/255.0 alpha:1.0],[UIColor colorWithRed:242.0/255.0 green:181.0/255.0 blue:77.0/255.0 alpha:1.0],[UIColor colorWithRed:242.0/255.0 green:181.0/255.0 blue:77.0/255.0 alpha:1.0],[UIColor colorWithRed:242.0/255.0 green:181.0/255.0 blue:77.0/255.0 alpha:1.0]]];
    [akTabBarController setBackgroundImageName:@"首页-标签栏_下"];
    [akTabBarController setTabEdgeColor:[UIColor clearColor]];
    [akTabBarController setTabStrokeColor:[UIColor clearColor]];
    [akTabBarController setTopEdgeColor:[UIColor clearColor]];
    [akTabBarController setSelectedTabColors:@[[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor]]];
    [akTabBarController setTabColors:@[[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor]]];
    appDelegate.akTabBarController = akTabBarController;
    appDelegate.window.rootViewController = appDelegate.akTabBarController;
    [appDelegate.window makeKeyAndVisible];
    
    akTabBarController.selectBlock = ^BOOL(NSInteger selectIndex){
        if(selectIndex == 2||selectIndex == 1){
            if(![UIManager appDelegate].sessionId){
                LoginViewController *loginVc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
                loginVc.loginSccuessBlock = ^(BOOL isSccuess){
                    if(isSccuess){
                        [akTabBarController didSelectTabAtIndex:selectIndex];
                    }
                };
                [akTabBarController presentViewController:loginVc animated:YES completion:nil];
                return NO;
                
            }
            
            
        }
        return YES;
    };
}

+ (void)showCreateNote
{
    [[self class] showVC:@"CreatNewNoteViewController"];
}

+ (void)showMineDetail
{
    [[self class] showVC:@"MyDetailViewController"];
}

+ (void)showMineNote
{
    [[self class] showVC:@"MyNoteViewController"];
}

+ (void)showWorkerDetail
{
    [[self class] showVC:@"WorkerDetailViewController"];
}

+ (void)showAllDetail
{
    [[self class] showVC:@"AllDetailViewController"];
}

+ (void)showPersonalNote
{
    [[self class] showVC:@"PersonalNoteViewController"];
}

+ (void)showNoteDetail
{
    [[self class] showVC:@"NoteDetailViewController"];
}


+ (void)showAddFriend
{
     [[self class] showVC:@"AddFriendsViewController"];
}

+ (void)showMineDepartment
{
    [[self class] showVC:@"MyDepartMentViewController"];
}

+ (void)showMineNewFriend
{
    [[self class] showVC:@"MyNewFriendViewController"];
}

+ (void)showDepartment
{
    [[self class] showVC:@"DepartmentViewController"];
}

+ (void)showGroup
{
    [[self class] showVC:@"GroupViewController"];
}

+ (void)showZhuZhuChat
{
    [[self class] showVC:@"ZhuZhuChatViewController"];
}

+ (void)showSingleChat
{
    [[self class] showVC:@"SingleChatViewController"];
}

+ (void)showChatNotification
{
    [[self class] showVC:@"ChatNotificationViewController"];
}

+ (void)showToDo
{
    [[self class] showVC:@"ToDoViewController"];
}

+ (void)showSelectRange
{
    [[self class] showVC:@"SelectRangeViewController"];
}

+ (void)showInviteFriend
{
    [[self class] showVC:@"InviteFriendsViewController"];
}

+ (void)showDoneList
{
    [[self class] showVC:@"DoneListViewController"];
}

+ (void)showGroupFiles
{
    [[self class] showVC:@"GroupFilesViewController"];
}

+ (void)showSingleChatSetting
{
    [[self class] showVC:@"SingleChatSettingViewController"];
}



+ (void)showTabBar:(BOOL)animated
{
    AppDelegate * appDelegate = [[self class] appDelegate];
    [appDelegate.akTabBarController showTabBarAnimated:animated];
}

+ (void)hideTabBar:(BOOL)animated
{
    AppDelegate * appDelegate = [[self class] appDelegate];
    [appDelegate.akTabBarController hideTabBarAnimated:animated];
}


+ (void)setNavigationTitleWhiteColor
{
    [[self class] setNavigationTitleColor:[UIColor whiteColor]];
}


+ (void)setNavigationTitleBlackColor
{
    [[self class] setNavigationTitleColor:[UIColor blackColor]];
}


+ (void)setNavigationTitleColor:(UIColor *)clr
{
    if(clr == nil)
    {
        clr = [UIColor blackColor];
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:clr}];
}

+ (void)customNavAppearance
{
    [[self class] setNavigationTitleBlackColor];
    [[UINavigationBar appearance] setBackgroundColor:NavColor];
    [[UINavigationBar appearance] setBarTintColor:NavColor];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];

}


+ (void)showVC:(NSString *)vcName
{
    AppDelegate * appDelegate = [[self class] appDelegate];
    UIViewController * vc = [[self class] viewControllerWithName:vcName];
    UINavigationController * nav = (UINavigationController *)appDelegate.akTabBarController.selectedViewController;
    [nav pushViewController:vc animated:YES];
    vc = nil;
}

+ (void)showViewController:(UIViewController *)vc
{
    AppDelegate * appDelegate = [[self class] appDelegate];
    UINavigationController * nav = (UINavigationController *)appDelegate.akTabBarController.selectedViewController;
    [nav pushViewController:vc animated:YES];
}



+ (UIViewController *)viewControllerWithName:(NSString *)vcName
{
    Class cls = NSClassFromString(vcName);
    UIViewController * vc = [[cls alloc] initWithNibName:vcName bundle:[NSBundle mainBundle]];
    return vc;
}

+ (UINavigationController *)navWithRootVC:(UIViewController *)vc
{
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    return nav;
}

+ (UINavigationController *)globleNavController
{
    static UINavigationController * nav  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nav = [[UINavigationController alloc]init];
    });
    return nav;
}


+ (void)openAppStore:(NSString *)appId
{
    NSString *str2 = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%@",  appId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str2]];
}

+ (void)reviewApp:(NSString *)appId
{
    NSString *str = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", appId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+ (void)sendMessage:(NSString *)body withRecipients:(NSArray *)recipients
{
    if(![MFMessageComposeViewController canSendText])
    {
        [[self class] showAlert:@"您的设备不支持短信!"];
        return ;
    }
    
    MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
    controller.recipients = recipients;
    controller.body = body;
    controller.messageComposeDelegate = [[self class] sharedManager];
    AppDelegate * appDelegate = [[self class] appDelegate];
    [appDelegate.window.rootViewController presentViewController:controller animated:YES completion:nil];
                                                
}

+ (void)sendMail:(NSString *)subject withBody:(NSString *)body isHTML:(BOOL)ishtml withRecipients:(NSArray *)recipients
{
    if (![MFMailComposeViewController canSendMail]) {
        // 提示用户设置邮箱
        [[self class] showAlert:@"您的设备不支持邮箱!"];
        return;
    }
    
    MFMailComposeViewController * controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = [[self class] sharedManager];
    [controller setSubject:subject];
    [controller setToRecipients:recipients];
    [controller setMessageBody:body isHTML:ishtml];
    AppDelegate * appDelegate = [[self class] appDelegate];
    [appDelegate.window.rootViewController presentViewController:controller animated:YES completion:nil];
    
}


+ (void)showAlert:(NSString *)message
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
    [alertView show];
    alertView = nil;
}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

+ (void)copy:(NSString *)text
{
    if(text == nil) return ;
    UIPasteboard * board = [UIPasteboard generalPasteboard];
    [board setStrings:@[text]];
}

@end
