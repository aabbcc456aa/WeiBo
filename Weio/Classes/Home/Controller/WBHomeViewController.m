//
//  WBHomeViewController.m
//  Weio
//
//  Created by huxiaolong on 14-8-28.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import "WBHomeViewController.h"
#import "WBTitleButton.h"

@interface WBHomeViewController ()

@end

@implementation WBHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"WB";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = @"hello";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIViewController *viewCon = [[UIViewController alloc]init];
    viewCon.view.backgroundColor = [UIColor redColor];
    [self.navigationController pushViewController:viewCon animated:YES];
    
}

@end
