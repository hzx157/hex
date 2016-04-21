//
//  ControlCenter.h
//  ClairAudient
//
//  Created by Carl on 13-12-31.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//


#import "AllControllers.h"
#import "AKTabBarController.h"
#import "AppDelegate.h"
@import MessageUI;
@interface UIManager : NSObject <MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
+ (instancetype)sharedManager;

+ (AppDelegate *)appDelegate;
+ (BOOL)isLogin;
+ (UIWindow *)keyWindow;
+ (UIWindow *)newWindow;
+ (void)makeKeyAndVisible;
//-------------------//
+ (void)showCreateNote;
+ (void)showMineDetail;
+ (void)showMineNote;
+ (void)showWorkerDetail;
+ (void)showAllDetail;
+ (void)showPersonalNote;
+ (void)showNoteDetail;
+ (void)showAddFriend;
+ (void)showMineDepartment;
+ (void)showMineNewFriend;
+ (void)showDepartment;
+ (void)showGroup;
+ (void)showZhuZhuChat;
+ (void)showSingleChat;
+ (void)showChatNotification;
+ (void)showToDo;
+ (void)showSelectRange;
+ (void)showInviteFriend;
+ (void)showDoneList;
+ (void)showGroupFiles;
+ (void)showSingleChatSetting;
//----------------//

+ (void)showTabBar:(BOOL)animated;
+ (void)hideTabBar:(BOOL)animated;
//---------------//
+ (void)showVC:(NSString *)vcName;
+ (UIViewController *)viewControllerWithName:(NSString *)vcName;
+ (UINavigationController *)navWithRootVC:(UIViewController *)vc;
+ (UINavigationController *)globleNavController;
//----------------//
+ (void)openAppStore:(NSString *)appId;
+ (void)reviewApp:(NSString *)appId;
+ (void)sendMessage:(NSString *)body withRecipients:(NSArray *)recipients;
+ (void)sendMail:(NSString *)subject withBody:(NSString *)body isHTML:(BOOL)ishtml withRecipients:(NSArray *)recipients;
+ (void)copy:(NSString *)text;
+ (void)showAlert:(NSString *)message;
@end
