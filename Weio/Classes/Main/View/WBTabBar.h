//
//  WBTabBar.h
//  Weio
//
//  Created by huxiaolong on 14-8-28.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBTabBar;
@class WBTabBarButton;

@protocol WBTabBarDelegate <NSObject>

-(void)tabBar:(WBTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to;
-(void)tabBarDidClickPlusButton:(WBTabBarButton *)btn;

@end

@interface WBTabBar : UIView

- (void)addTarBarButton:(UITabBarItem *)item;
@property (nonatomic,weak) id<WBTabBarDelegate> delegate;

@end
