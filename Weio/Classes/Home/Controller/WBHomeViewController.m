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

@interface WBHomeViewController ()<MJRefreshBaseViewDelegate>

@property (nonatomic,strong) NSMutableArray *statusFrames;
@property (nonatomic,weak) UIRefreshControl *refreshControl;
@property (nonatomic,strong) MJRefreshFooterView *refreshFootView;

@end

@implementation WBHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setupNavBar];
    
    [self setupLoadNew];
    
    [self setupLoadMore];
    
    self.tableView.backgroundColor = WBColor(226, 226, 226);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, WBStatusTableBorder, 0);
    
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
    
    // 3.发送请求
    [man GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array  =[WBStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
        for(WBStatus *status in array){
            WBStatusFrame *statusFrame = [[WBStatusFrame alloc]init];
            [statusFrame setStatus:status];
            [self.statusFrames addObject:statusFrame];
        }
        [self.tableView reloadData];
        [self.refreshFootView endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.refreshFootView endRefreshing];
    }];
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
    [self loadNew];
}


-(void)loadNew{
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
        NSArray *array  =[WBStatus objectArrayWithKeyValuesArray:responseObject[@"statuses"]];
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.refreshControl endRefreshing];
    }];
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
