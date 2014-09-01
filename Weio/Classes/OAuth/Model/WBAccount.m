//
//  WBAccount.m
//  WeiBo
//
//  Created by huxiaolong on 14-8-31.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import "WBAccount.h"


@implementation WBAccount

+(instancetype)accountWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

// 解析
-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super init]){
        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
        self.expires_in = [aDecoder decodeInt64ForKey:@"expires_in"];
        self.remind_in = [aDecoder decodeInt64ForKey:@"remind_in"];
        self.uid = [aDecoder decodeInt64ForKey:@"uid"];
        self.expired_time = [aDecoder decodeObjectForKey:@"expired_time"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeInt64:self.expires_in forKey:@"expires_in"];
    [aCoder encodeInt64:self.remind_in forKey:@"remind_in"];
    [aCoder encodeInt64:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.expired_time forKey:@"expired_time"];
}
@end
