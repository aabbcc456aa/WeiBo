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

@interface WBHomeViewController ()

@property (nonatomic,strong) NSMutableArray *statusLines;

@end

@implementation WBHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setupNavBar];
    
    [self setupStatusTimeLine];

    
}


// 设置 微博 TimeLine
-(void)setupStatusTimeLine{
    AFHTTPRequestOperationManager *man = [AFHTTPRequestOperationManager manager];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [WBAccountTool account].access_token;
    
    [man GET:@"https://api.weibo.com/2/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"---status:---:%@",responseObject);
        self.statusLines = responseObject[@"statuses"];
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
    [titleBtn setTitle:@"哈哈哈哈" forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imagewithName:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    titleBtn.frame = CGRectMake(0, 0, 120, 35);
    [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
}

-(void)titleBtnClick:(WBTitleButton *)titleBtn{
    if(titleBtn.currentImage == [UIImage imagewithName:@"navigationbar_arrow_down"]){
         [titleBtn setImage:[UIImage imagewithName:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
    }else{
         [titleBtn setImage:[UIImage imagewithName:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    }
}

-(void)leftAdd{
    NSLog(@"-----left");
}

-(void)rightPop{
    NSLog(@"-----rightpop");
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.statusLines.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"WB";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.textLabel.text = self.statusLines[indexPath.row][@"user"][@"name"];
    cell.detailTextLabel.text = self.statusLines[indexPath.row][@"text"];
    [cell.imageView setImageWithURL:[NSURL URLWithString:self.statusLines[indexPath.row][@"user"][@"profile_image_url"]] placeholderImage:[UIImage imagewithName:@"app"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *viewCon = [[UIViewController alloc]init];
    viewCon.view.backgroundColor = [UIColor redColor];
    [self.navigationController pushViewController:viewCon animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

@end
