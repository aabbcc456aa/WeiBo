//
//  WBTabBar.m
//  Weio
//
//  Created by huxiaolong on 14-8-28.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import "WBTabBar.h"
#import "WBTabBarButton.h"
#import "UIImage+WB.h"

@interface WBTabBar()
 @property (nonatomic,weak) WBTabBarButton *selectButton;
 @property (nonatomic,strong) NSMutableArray *tabBarButtons;
 @property (nonatomic,weak) UIButton *centerBtn;
@end

@implementation WBTabBar

- (NSMutableArray *)tabBarButtons{
    if(!_tabBarButtons){
        _tabBarButtons = [NSMutableArray array];
    }
    return _tabBarButtons;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        if (!IOS7){
            self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"tabbar_background"]];
        }
    }
    
    // 加号 button
    UIButton *centenBtn = [[UIButton alloc]init];
    [centenBtn setImage:[UIImage imageWithName:@"tabbar_compose_icon_add"] forState:UIControlStateNormal];
    [centenBtn setImage:[UIImage imageWithName:@"tabbar_compose_icon_add_highlighted"] forState:UIControlStateHighlighted];
    [centenBtn setBackgroundImage:[UIImage imageWithName:@"tabbar_compose_button"] forState:UIControlStateNormal];
    [centenBtn setBackgroundImage:[UIImage imageWithName:@"tabbar_compose_button_hightlighted"] forState:UIControlStateHighlighted];
    if(!IOS7){
        [centenBtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_slider"]]];
    }
    self.centerBtn = centenBtn;
    [self addSubview:centenBtn];
    return self;
}


-(void)addTarBarButton:(UITabBarItem *)item{
    WBTabBarButton *btn = [[WBTabBarButton alloc]init];
    [self.tabBarButtons addObject:btn];
    [self addSubview:btn];
    btn.item = item;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if(self.tabBarButtons.count == 1){
        btn.selected = YES;
        self.selectButton = btn;
    }
   
}

-(void)btnClick:(WBTabBarButton *)button{
    if([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]){
        [self.delegate tabBar:self didSelectedButtonFrom:self.selectButton.tag to:button.tag];
    }
    self.selectButton.selected = NO;
    button.selected = YES;
    self.selectButton = button;
  
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
 
    CGFloat h = self.frame.size.height;
    CGFloat w = self.frame.size.width / self.subviews.count;
    CGFloat y = 0;
    self.centerBtn.bounds = CGRectMake(0,0,w, h);
    self.centerBtn.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
//    NSLog(@"----%@--:",NSStringFromCGRect(self.centerBtn.frame));
    for(int i = 0; i < self.tabBarButtons.count ; i++){
        UIButton *btn = self.tabBarButtons[i];
        btn.tag = i;
        CGFloat x = i * w;
        if (i > 1){
            x = x + w;
        }
        btn.frame = CGRectMake(x, y, w, h);
    }
   
}

@end
