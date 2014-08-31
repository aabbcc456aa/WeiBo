//
//  WBAccountTool.m
//  WeiBo
//
//  Created by huxiaolong on 14-8-31.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import "WBAccountTool.h"
#import "WBAccount.h"

#define AccountPath   [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"WeiBo.account"]

@implementation WBAccountTool

+(void)saveAccount:(WBAccount *)account{
    NSDate *now = [NSDate date];
    account.expired_time = [now dateByAddingTimeInterval:account.expires_in];
    [NSKeyedArchiver archiveRootObject:account toFile:AccountPath];
    
}
+(WBAccount *)account{
    NSLog(@"-------accountPath：%@",AccountPath);
    WBAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountPath];
    NSDate *now = [NSDate date];
    if([now compare:account.expired_time] == NSOrderedAscending){
        return account;
    }
    else{
        return nil;
    }
    
}

@end
