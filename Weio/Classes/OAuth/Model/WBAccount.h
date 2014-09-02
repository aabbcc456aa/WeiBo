//
//  WBAccount.h
//  WeiBo
//
//  Created by huxiaolong on 14-8-31.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBAccount : NSObject <NSCoding>

@property (nonatomic,copy) NSString *access_token;
@property (nonatomic,strong) NSDate *expired_time;
@property (nonatomic,assign) long long expires_in;
@property (nonatomic,assign) long long remind_in;
@property (nonatomic,assign) long long uid;
@property (nonatomic,copy) NSString *user_name;


+(instancetype)accountWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;
@end
