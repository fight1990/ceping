//
//  AppDelegate.m
//  qiqiaoban
//
//  Created by mac on 2019/2/19.
//  Copyright © 2019年 mac. All rights reserved.
//
#import "AppDelegate.h"

#import "StartViewController.h"

#import "ViewController.h"

#import "loginViewController.h"
//你值得真正的快乐，你应该脱下你穿的保护色， 为什么失去了，还要被惩罚了。能不能让悲伤全部消失在此刻
#import <SVProgressHUD.h>

@interface AppDelegate ()

//琪诺

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { //wucai fushi yitai
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //暂时用来测试数独
    
    loginViewController *forwoViewController = [[loginViewController alloc] init];
    UINavigationController *navi =[[UINavigationController alloc]initWithRootViewController:forwoViewController];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    //设置HUD的Style
    [SVProgressHUD setDefaultStyle:(SVProgressHUDStyleDark)];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
