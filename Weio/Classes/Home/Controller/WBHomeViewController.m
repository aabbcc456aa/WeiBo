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
#import "MJRefresh.h"
#import "WBUser.h"
#import "WBStatusTool.h"

@interface WBHomeViewController ()<MJRefreshBaseViewDelegate>

@property (nonatomic,strong) NSMutableArray *statusFrames;
@property (nonatomic,weak) UIRefreshControl *refreshControl;
@property (nonatomic,strong) MJRefreshFooterView *refreshFootView;
@property (nonatomic,strong) WBTitleButton *titleBtn;

@property (nonatomic,assign) BOOL loadingMore;

@end

@implementation WBHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = WBColor(226, 226, 226);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, WBStatusTableBorder, 0);
	
    [self setupNavBar];
    
    // load newest status
    [self setupLoadNew];
    
    // load histroy status
    [self setupLoadMore];
    
    // load username
    [self loadUserInfo];
    
    // 首次数据加载 首先从数据库加载，没有再从网络加载
    [self firstLoadData];
}

-(void)firstLoadData{
    // 首先从数据库查找，然后再到网络查找
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSArray *arrDict = [WBStatusTool statusWithParams:params];
    if(arrDict.count > 0){
        [self refreshNewData:arrDict];
    }else{
        // 从网络加载数据
        [self loadNew ];
    }
}

-(void)loadUserInfo{
    AFHTTPRequestOperationManager *man = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [WBAccountTool account].access_token;
    params[@"uid"] = @([WBAccountTool account].uid);
    
    // 3.发送请求
    [man GET:@"https://api.weibo.com/2/users/show.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        WBUser *user = [WBUser objectWithKeyValues:responseObject];
        [self.titleBtn setTitle:user.name forState:UIControlStateNormal];
        
        // store user name
        WBAccount *account = [WBAccountTool account];
        account.user_name = user.name;
        [WBAccountTool saveAccount:account];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}


-(void)setupLoadMore{
    MJRefreshFooterView *refreshFootView = [[MJRefreshFooterView alloc]init];
    refreshFootView.delegate = self;
    refreshFootView.scrollView = self.tableView;
    self.refreshFootView = refreshFootView;
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    [self loadMore];
}

-(void)loadMore{
    AFHTTPRequestOperationManager *man = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [WBAccountTool account].access_token;
    params[@"uid"] = @([WBAccountTool account].uid);
    if(self.statusFrames){
        WBStatusFrame *lastStatusFrame = [self.statusFrames lastObject];
        params[@"max_id"] = lastStatusFrame.status.idstr;
    }
    NSArray *arrDict = [WBStatusTool statusWithParams:params];
    if(arrDict.count > 0){
         [self refreshMoreData:arrDict];
    }else{
        // 从网络加载数据
        [man GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self refreshMoreData:responseObject[@"statuses"]];
            [WBStatusTool addStatuses:responseObject[@"statuses"]];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.refreshFootView endRefreshing];
        }];
    }
}

-(void)refreshMoreData:(NSArray *)array{
    NSArray *statusArray = [WBStatus objectArrayWithKeyValuesArray:array];
    for(WBStatus *status in statusArray){
        WBStatusFrame *statusFrame = [[WBStatusFrame alloc]init];
        [statusFrame setStatus:status];
        [self.statusFrames addObject:statusFrame];
    }
    [self.tableView reloadData];
    [self.refreshFootView endRefreshing];
    self.loadingMore = NO;
}

-(void)dealloc{
    [self.refreshFootView free];
}

-(void)setupLoadNew{
    UIRefreshControl *con = [[UIRefreshControl alloc]init];
    con.attributedTitle = [[NSAttributedString alloc]initWithString:@"下拉更新"];
    [con addTarget:self action:@selector(loadNew) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:con];
    self.refreshControl = con;
    
    // not invoke listen method
    [self.refreshControl beginRefreshing];
    
    //manual invoke listen method
//    [self loadNew];
}


// 加载最新数据不需要从数据查找，因为数据库永远不会存着最新数据
-(void)loadNew{
    // 0.清除提醒数字
    self.tabBarItem.badgeValue = nil;
    
    AFHTTPRequestOperationManager *man = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [WBAccountTool account].access_token;
    params[@"uid"] = @([WBAccountTool account].uid);
    if(self.statusFrames){
        WBStatusFrame *lastStatusFrame = self.statusFrames[0];
        params[@"since_id"] = lastStatusFrame.status.idstr;
    }
 
    // 3.发送请求
    [man GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//         NSArray *array  =[WBStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        [self refreshNewData:responseObject[@"statuses"]];
         // --- 存储到数据库 ---
        [WBStatusTool addStatuses:responseObject[@"statuses"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.refreshControl endRefreshing];
    }];
}

-(void)refreshNewData:(NSArray *)arrayDict{
    NSArray *array  =[WBStatus objectArrayWithKeyValuesArray:arrayDict];
    NSMutableArray *tempStatusArr = [NSMutableArray array];
    for(WBStatus *status in array){
        WBStatusFrame *statusFrame = [[WBStatusFrame alloc]init];
        [statusFrame setStatus:status];
        [tempStatusArr addObject:statusFrame];
    }
    int updateCount = tempStatusArr.count;
    [tempStatusArr addObjectsFromArray:self.statusFrames];
    self.statusFrames = tempStatusArr;
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
    //上面下拉一个小框 显示更新数量
    [self displayUpdateCount:(int)updateCount];
    
    // 滚到最上面
    NSIndexPath *topPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:topPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

}

-(void)displayUpdateCount:(int)count{
    UIButton *countBtn = [[UIButton alloc]init];
    countBtn.userInteractionEnabled = NO;
    [countBtn setBackgroundImage:[UIImage imageWithName:@"timeline_new_status_background"] forState:UIControlStateNormal];
    if(count > 0){
        [countBtn setTitle:[NSString stringWithFormat:@"更新了%d条内容",count] forState:UIControlStateNormal];
    }else{
        [countBtn setTitle:@"没有新的内容" forState:UIControlStateNormal];
    }
    [countBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    countBtn.titleLabel.font = [UIFont systemFontOfSize:14];
   
    CGFloat btnH = 30;
    CGFloat btnY = 64 - btnH;
    CGFloat btnX = 2;
    CGFloat btnW = self.view.frame.size.width - 2 * btnX;
    countBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    [self.navigationController.view insertSubview:countBtn belowSubview:self.navigationController.navigationBar];
    
    [UIView animateWithDuration:0.5 animations:^{
        countBtn.transform = CGAffineTransformMakeTranslation(0, btnH + 2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 delay:0.8 options:UIViewAnimationOptionCurveLinear animations:^{
            countBtn.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [countBtn removeFromSuperview];
        }];
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
    WBAccount *account = [WBAccountTool account];
     titleBtn.frame = CGRectMake(0, 0, 0, 35);
    if(account.user_name){
        [titleBtn setTitle:account.user_name forState:UIControlStateNormal];
    }else{
       [titleBtn setTitle:@"微博首页" forState:UIControlStateNormal];
    }
    [titleBtn setImage:[UIImage imageWithName:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    self.titleBtn = titleBtn;
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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(self.loadingMore == NO && scrollView.frame.size.height > ScreenH && scrollView.contentOffset.y + scrollView.frame.size.height  > scrollView.contentSize.height){
        self.loadingMore  =YES;
        [self loadMore];
        NSLog(@"----load more");
    }
}

@end
