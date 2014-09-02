//
//  WBNavigationViewController.m
//  WeiBo
//
//  Created by huxiaolong on 14-8-28.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import "WBNavigationViewController.h"

@interface WBNavigationViewController ()

@end

@implementation WBNavigationViewController

// init class: class only invoke one time
+(void)initialize{
    [super initialize];
    
    // setup navbar theme
    [self setupNavBarTheme];
    
    // setup navbar button
    [self setupNavBarButton];
}

+(void)setupNavBarTheme{
    UINavigationBar *navBar = [UINavigationBar appearance];
    if(!IOS7){
      [navBar setBackgroundImage:[UIImage imageWithName:@"navigationbar_background"] forBarMetrics:UIBarMetricsDefault];
      [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[UITextAttributeFont] = [UIFont boldSystemFontOfSize:19];
    dict[UITextAttributeTextColor] = [UIColor blackColor];
    dict[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    
    [navBar setTitleTextAttributes:dict];
}

+(void)setupNavBarButton{
    UIBarButtonItem *btnItem = [UIBarButtonItem appearance];
    if(!IOS7){
        [btnItem setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        [btnItem setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background_disable"] forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
        [btnItem setBackgroundImage:[UIImage imageWithName:@"navigationbar_button_background_pushed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if(IOS7){
        dict[UITextAttributeFont] = [UIFont systemFontOfSize:14];
        dict[UITextAttributeTextColor] = [UIColor orangeColor];
    }else{
        dict[UITextAttributeFont] = [UIFont systemFontOfSize:12];
        dict[UITextAttributeTextColor] = [UIColor blackColor];
    }
    dict[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    [btnItem setTitleTextAttributes:dict forState:UIControlStateNormal];
    [btnItem setTitleTextAttributes:dict forState:UIControlStateHighlighted];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

@end
