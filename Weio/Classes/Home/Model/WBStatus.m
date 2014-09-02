//
//  IWStatus.m
//  ItcastWeibo
//
//  Created by apple on 14-5-8.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "WBStatus.h"
#import "NSDate+TimeAgo.h"
#import "WBPhoto.h"


@implementation WBStatus

-(NSDictionary *)objectClassInArray{
    return @{@"pic_urls": [WBPhoto class]};
}


-(NSString *)created_at{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
//    formatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh-CN"];
    
    NSDate *createDate = [formatter dateFromString:_created_at];
    return [createDate timeAgo];
}

-(void)setSource:(NSString *)source{
    int from = [source rangeOfString:@">"].location + 1;
    int len = [source rangeOfString:@"</"].location - from;
    
    source = [source substringWithRange:NSMakeRange(from, len)];
    _source = [NSString stringWithFormat:@"来自%@",source];
}

@end
