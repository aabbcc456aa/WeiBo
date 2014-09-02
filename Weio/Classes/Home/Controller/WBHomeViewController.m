//
//  WBHomeViewController.m
//  Weio
//
//  Created by huxiaolong on 14-8-28.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import "WBHomeViewController.h"
#import "WBTitleButton.h"
#import "AFNetworking.h"
#import "WBAccountTool.h"
#import "WBAccount.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "WBStatusCell.h"
#import "WBStatusFrame.h"
#import "WBStatus.h"
#import "WBPhoto.h"

@interface WBHomeViewController ()

@property (nonatomic,strong) NSMutableArray *statusFrames;

@end

@implementation WBHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setupNavBar];
    
    [self setupStatusTimeLine];
    
    self.tableView.backgroundColor = WBColor(226, 226, 226);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, WBStatusTableBorder, 0);
    
}


// 设置 微博 TimeLine
-(void)setupStatusTimeLine{
    AFHTTPRequestOperationManager *man = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [WBAccountTool account].access_token;
    
    [man GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"---status:---:%@",responseObject[@"pic_urls"]);
        
        NSArray *array  =[WBStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        self.statusFrames = [NSMutableArray array];
        for(WBStatus *status in array){
            WBStatusFrame *statusFrame = [[WBStatusFrame alloc]init];
            [statusFrame setStatus:status];
            [self.statusFrames addObject:statusFrame];
        }
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


// 设置导航 标题 等
-(void)setupNavBar{
    UIBarButtonItem  *rightBtnItem = [UIBarButtonItem itemWithIcon:@"navigationbar_pop" highIcon:@"navigationbar_pop_highlighted" target:self action:@selector(rightPop)];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    //
    UIBarButtonItem  *leftBtnItem = [UIBarButtonItem itemWithIcon:@"navigationbar_friendsearch" highIcon:@"navigationbar_friendsearch_highlighted" target:self action:@selector(leftAdd)];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    
    // 设置中间 标题
    WBTitleButton *titleBtn = [[WBTitleButton alloc]init];
    [titleBtn setTitle:@"微博首页" forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageWithName:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    titleBtn.frame = CGRectMake(0, 0, 120, 35);
    [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
}

-(void)titleBtnClick:(WBTitleButton *)titleBtn{
    if(titleBtn.currentImage == [UIImage imageWithName:@"navigationbar_arrow_down"]){
         [titleBtn setImage:[UIImage imageWithName:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
    }else{
         [titleBtn setImage:[UIImage imageWithName:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    }
}

-(void)leftAdd{
    NSLog(@"-----left");
}

-(void)rightPop{
    NSLog(@"-----rightpop");
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.statusFrames.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WBStatusCell *cell = [WBStatusCell cellWithTableView:tableView];
    [cell setStatusFrame: self.statusFrames[indexPath.row]];
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UIViewController *viewCon = [[UIViewController alloc]init];
//    viewCon.view.backgroundColor = [UIColor redColor];
//    [self.navigationController pushViewController:viewCon animated:YES];
//    
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.statusFrames[indexPath.row] cellHeight];
}

@end
