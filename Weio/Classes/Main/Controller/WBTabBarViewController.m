//
//  WBTabBarViewController.m
//  Weio
//
//  Created by huxiaolong on 14-8-28.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import "WBTabBarViewController.h"
#import "WBHomeViewController.h"
#import "WBMessageViewController.h"
#import "WBDiscoverViewController.h"
#import "WBMeViewController.h"
#import "UIImage+WB.h"
#import "WBTabBar.h"
//#import "WBTabBarButton.h"
#import "WBNavigationViewController.h"

@interface WBTabBarViewController () <WBTabBarDelegate>
@property (nonatomic,strong) WBTabBar *tabBarView;

@end

@implementation WBTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTabBar];
    [self initChildController];
	
}


-(void)initTabBar{
    WBTabBar *tabBarView = [[WBTabBar alloc]init];
    tabBarView.frame = self.tabBar.bounds;
    tabBarView.delegate = self;
    [self.tabBar addSubview:tabBarView];
    self.tabBarView = tabBarView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    for(UIView *child in self.tabBar.subviews){
        if ([child isKindOfClass:[UIControl class]]){
            [child removeFromSuperview];
        }
    }

}

-(void)initChildController{
    WBHomeViewController *homeCon = [[WBHomeViewController alloc]init];
    WBMessageViewController *messageCon = [[WBMessageViewController alloc]init];
    WBDiscoverViewController *discoverCon = [[WBDiscoverViewController alloc]init];
    WBMeViewController *meCon = [[WBMeViewController alloc]init];
    [self setUpChildController:homeCon title:@"首页" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected" badgeValue:@"11"];
    [self setUpChildController:messageCon title:@"消息" imageName:@"tabbar_message_center" selectedImageName:@"tabbar_message_center_selected" badgeValue:@"11"];
    [self setUpChildController:discoverCon title:@"广场" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected" badgeValue:@"111"];
    [self setUpChildController:meCon title:@"我" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected" badgeValue:nil];
}

-(void) setUpChildController:(UIViewController *)controller title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName badgeValue:(NSString *)badgeValue{
//    navCon.tabBarItem.title = title;
//    navCon.navigationItem.title = title;
    controller.title = title;
    controller.tabBarItem.image = [UIImage imagewithName:imageName];
    controller.tabBarItem.badgeValue = badgeValue;
    if(IOS7){
        controller.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        controller.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    }
    WBNavigationViewController *navCon = [[WBNavigationViewController alloc]initWithRootViewController:controller];
    [self addChildViewController:navCon];
    [self.tabBarView addTarBarButton:controller.tabBarItem];
}

-(void)tabBar:(WBTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to{
     NSLog(@"--------set Index %d",to);
    [self setSelectedIndex:to];
}



@end
