//
//  WBAppDelegate.m
//  Weio
//
//  Created by huxiaolong on 14-8-28.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import "WBAppDelegate.h"
#import "WBTabBarViewController.h"
#import  "WBNewfeatureViewController.h"
#import  "WBOAuthViewController.h"
#import "WBAccountTool.h"
#import "WBOAuthViewController.h"
#import "WBActionChose.h"
#import "SDWebImageManager.h"

@implementation WBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    BOOL showNewFeature = [WBActionChose showNewFeature];
    if(showNewFeature){
        NSString *KEY = @"CFBundleVersion";
        NSString *currentVersion  = [NSBundle mainBundle].infoDictionary[KEY];
        NSUserDefaults *useDefaults = [NSUserDefaults standardUserDefaults];
        application.statusBarHidden = NO;
        [useDefaults setValue:currentVersion forKey:KEY];
        [useDefaults synchronize];
        self.window.rootViewController = [[WBNewfeatureViewController alloc]init];
    }else{
        if([WBActionChose showLogin]){
            self.window.rootViewController = [[WBOAuthViewController alloc]init];
//            self.window.rootViewController = [[WBTabBarViewController alloc]init];
        }else{
//            self.window.rootViewController = [[WBOAuthViewController alloc]init];
            self.window.rootViewController = [[WBTabBarViewController alloc]init];
          
        }
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application{
    [[SDWebImageManager sharedManager] cancelAll];
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

@end
