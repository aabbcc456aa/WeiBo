//
//  WBComposeToolBar.m
//  WeiBo
//
//  Created by huxiaolong on 14-9-3.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import "WBComposeToolBar.h"

@implementation WBComposeToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"compose_toolbar_background"]];
        
        
        // 2.添加按钮
        [self addButtonWithIcon:@"compose_camerabutton_background" highIcon:@"compose_camerabutton_background_highlighted" tag:WBComposeToolBarButtonTypeCamera];
        [self addButtonWithIcon:@"compose_toolBar_picture" highIcon:@"compose_toolbar_picture_highlighted" tag:WBComposeToolBarButtonTypePicture];
        [self addButtonWithIcon:@"compose_mentionbutton_background" highIcon:@"compose_mentionbutton_background_highlighted" tag:WBComposeToolBarButtonTypeMention];
        [self addButtonWithIcon:@"compose_trendbutton_background" highIcon:@"compose_trendbutton_background_highlighted" tag:WBComposeToolBarButtonTypeTrend];
        [self addButtonWithIcon:@"compose_emoticonbutton_background" highIcon:@"compose_emoticonbutton_background_highlighted" tag:WBComposeToolBarButtonTypeEmotion];
    }
    return self;
}

- (void)addButtonWithIcon:(NSString *)icon highIcon:(NSString *)highIcon tag:(int)tag
{
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageWithName:icon] forState:UIControlStateNormal];
    [button setImage:[UIImage imageWithName:highIcon] forState:UIControlStateHighlighted];
    [self addSubview:button];
}

-(void)buttonClick:(UIButton *)btn{
    NSLog(@"------btnClick ---%@",btn);
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat y = 0;
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width / self.subviews.count;
    for(int i = 0 ;i < self.subviews.count ; i ++){
        UIButton *btn = self.subviews[i];
        CGFloat x = w*i;
        btn.frame = CGRectMake(x, y, w, h);
    }
}



@end
