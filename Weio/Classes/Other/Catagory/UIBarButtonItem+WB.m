//
//  UIView+WB.m
//  WeiBo
//
//  Created by huxiaolong on 14-8-29.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import "UIBarButtonItem+WB.h"

@implementation UIBarButtonItem (WB)

+(UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageWithName:highIcon] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, 0, btn.currentImage.size.width, btn.currentImage.size.height);

    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem  *btnItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    return btnItem;
}
@end
