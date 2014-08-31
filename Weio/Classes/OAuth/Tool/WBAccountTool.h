//
//  WBAccountTool.h
//  WeiBo
//
//  Created by huxiaolong on 14-8-31.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "WBAccount.h"
@class  WBAccount;

@interface WBAccountTool : NSObject

+(void)saveAccount:(WBAccount *)account;
+(WBAccount *)account;

@end
