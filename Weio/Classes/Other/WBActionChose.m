//
//  WBWindowChose.m
//  WeiBo
//
//  Created by huxiaolong on 14-8-31.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import "WBActionChose.h"
#import "WBAccountTool.h"

@implementation WBActionChose

// 1. 新特性chose
+(BOOL)showNewFeature{
    NSString *KEY = @"CFBundleVersion";
    NSString *currentVersion  = [NSBundle mainBundle].infoDictionary[KEY];
    NSUserDefaults *useDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [useDefaults stringForKey:KEY];
    // areadly newest version
    if( [lastVersion isEqualToString:currentVersion]){
        return NO;
    }else{
        return YES;
    }

}

// 2. 是否登录
+(BOOL) showLogin{
    WBAccount *account = [WBAccountTool account];

    if(account){
        return NO;
    }else{
        return YES;
    }
}

@end
