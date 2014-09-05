//
//  WBStatusTool.h
//  WeiBo
//
//  Created by huxiaolong on 14-9-5.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBStatusTool : NSObject

+(void)addStatuses:(NSArray *)statuses;

+(void)insertStatus:(NSDictionary *)dict;

+(NSArray *)statusWithParams:(NSDictionary *)params;

@end
