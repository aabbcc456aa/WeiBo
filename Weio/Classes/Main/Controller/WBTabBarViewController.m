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
#import "MBProgressHUD+MJ.h"
#import "WBComposeViewController.h"
#import "AFNetworking.h"
#import "WBAccountTool.h"
#import "WBAccount.h"
#import "WBUserUnreadCountResult.h"
#import "MJExtension.h"

@interface WBTabBarViewController () <WBTabBarDelegate>
@property (nonatomic,strong) WBTabBar *tabBarView;
@property (nonatomic,strong) WBHomeViewController *homeCon;
@property (nonatomic,strong) WBMessageViewController *messageCon;
@property (nonatomic,strong) WBMeViewController *meCon;
@property (nonatomic,strong) WBUserUnreadCountResult *unreadResult;

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
    [MBProgressHUD hideHUD];
    [super viewDidLoad];
    [self initTabBar];
    [self initChildController];
    
    //设置定时更新器，定时检查消息和微博
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(checkUnreadMessage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

-(void)checkUnreadMessage{
    AFHTTPRequestOperationManager *man = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [WBAccountTool account].access_token;
    params[@"uid"] = @([WBAccountTool account].uid);
    
    // 3.发送请求
    [man GET:@"https://rm.api.weibo.com/2/remind/unread_count.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WBUserUnreadCountResult *result  =[WBUserUnreadCountResult objectWithKeyValues:responseObject];
        self.unreadResult = result;
        self.homeCon.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",result.status];
        self.messageCon.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",result.messageCount];
        self.meCon.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",result.follower];

        // 4.设置图标右上角的数字
        [UIApplication sharedApplication].applicationIconBadgeNumber = result.count;

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"---get unread message failer");
    }];
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
    self.homeCon = homeCon;
    self.messageCon = messageCon;
    self.meCon = meCon;
    [self setUpChildController:homeCon title:@"首页" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected" badgeValue:nil];
    [self setUpChildController:messageCon title:@"消息" imageName:@"tabbar_message_center" selectedImageName:@"tabbar_message_center_selected" badgeValue:nil];
    [self setUpChildController:discoverCon title:@"广场" imageName:@"tabbar_discover" selectedImageName:@"tabbar_discover_selected" badgeValue:nil];
    [self setUpChildController:meCon title:@"我" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected" badgeValue:nil];
}

-(void) setUpChildController:(UIViewController *)controller title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName badgeValue:(NSString *)badgeValue{
//    navCon.tabBarItem.title = title;
//    navCon.navigationItem.title = title;
    controller.title = title;
    controller.tabBarItem.image = [UIImage imageWithName:imageName];
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


// implement switch view method
-(void)tabBar:(WBTabBar *)tabBar didSelectedButtonFrom:(int)from to:(int)to{
    [self setSelectedIndex:to];
    if(to == 0 && self.unreadResult.status){
        [self.homeCon loadNew];
    }
}

-(void)tabBarDidClickPlusButton:(WBTabBarButton *)btn{
    WBComposeViewController *composeCon = [[WBComposeViewController alloc]init];
    WBNavigationViewController *navCon = [[WBNavigationViewController alloc]initWithRootViewController:composeCon];
    [self presentViewController:navCon animated:YES completion:nil];
}



@end
