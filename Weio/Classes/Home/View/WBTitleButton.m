//
//  WBTitleButton.m
//  WeiBo
//
//  Created by huxiaolong on 14-8-29.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//
#define WBTitleButtonW 20
#import "WBTitleButton.h"

@implementation WBTitleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.adjustsImageWhenHighlighted = NO;
        [self setBackgroundImage:[UIImage resizedImageWithName:@"navigationbar_filter_background_highlighted"] forState:UIControlStateHighlighted];
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:(18)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat x = contentRect.size.width - WBTitleButtonW;
    CGFloat y = 0;
    CGFloat h = contentRect.size.height;
    CGFloat w = WBTitleButtonW;
    return CGRectMake(x, y, w, h);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat h = contentRect.size.height;
    CGFloat w = contentRect.size.width -  WBTitleButtonW;
    return CGRectMake(x, y, w, h);
}

@end
