//
//  UIView+WB.h
//  WeiBo
//
//  Created by huxiaolong on 14-8-29.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (WB)

+(UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action;

@end
