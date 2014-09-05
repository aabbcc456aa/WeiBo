//
//  WBStatusTool.m
//  WeiBo
//
//  Created by huxiaolong on 14-9-5.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//  存储数据到数据库
//  字段： id access_token  idstr  dict

#import "WBStatusTool.h"
#import "FMDB.h"
#import "WBStatus.h"
#import "WBAccount.h"
#import "WBAccountTool.h"


@implementation WBStatusTool

static FMDatabaseQueue *_queue;
static NSString *accessToken;

+(void)initialize{
    accessToken = [WBAccountTool  account].access_token;
    NSString *dbPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"weibo.sqlite"];
    _queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"create table if not exists statuses(id integer primary key autoincrement,access_token text, idstr text,dict blob);"];
        NSLog(@"create table successful!");
    }];
}

+(void)addStatuses:(NSArray *)statuses{
    for(NSDictionary *status in statuses){
        [self insertStatus:status];
    }
}

+(void)insertStatus:(NSDictionary *)dict{
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *idstr = dict[@"idstr"];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dict];
        
        // 2.存储数据
        [db executeUpdate:@"insert into  statuses(access_token, idstr, dict) values(?, ? , ?)", accessToken, idstr, data];
    }];
}

+(NSArray *)statusWithParams:(NSDictionary *)params{
    __block NSMutableArray *arrResult = [NSMutableArray array];
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *setResult = nil;
        NSString *count = params[@"count"] ? params[@"count"] : @"20";
        if(params[@"max_id"]){
            setResult = [db executeQuery:@"select dict from statuses where access_token = ? and idstr < ? order by idstr desc limit ?;",accessToken,params[@"max_id"], count];
        }else{
            setResult = [db executeQuery:@"select * from statuses where access_token = ? order by idstr desc limit ?;",accessToken, count ];
        }
        while (setResult.next) {
            NSData *data  =[setResult dataForColumn:@"dict"];
            NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [arrResult addObject:dict];
        }
    }];
    return arrResult;
}

@end
