//
//  WBComposeViewController.m
//  WeiBo
//
//  Created by huxiaolong on 14-9-3.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import "WBComposeViewController.h"
#import "WBTextView.h"
#import "AFNetworking.h"
#import "WBAccountTool.h"
#import "MBProgressHUD+MJ.h"
#import "WBAccount.h"

@interface WBComposeViewController ()

@property(nonatomic,strong) WBTextView *textView;

@end

@implementation WBComposeViewController

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
    
    [self setupNavItem];
    
    [self setupTextView];

}
-(void)setupTextView{
    WBTextView *textView = [[WBTextView alloc]init];
    textView.frame = self.view.bounds;
   [self.view addSubview:textView];
    self.textView = textView;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewChange) name:UITextViewTextDidChangeNotification object:textView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}

-(void)textViewChange{
    self.navigationItem.rightBarButtonItem.enabled = (self.textView.text.length > 0);
}

-(void)setupNavItem{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelStatus)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(sendStatus)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.title = @"发微博";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendStatus{
    
    // 1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"status"] = self.textView.text;
    params[@"access_token"] = [WBAccountTool account].access_token;
    
    // 3.发送请求
    [mgr POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          [MBProgressHUD showSuccess:@"发送成功"];
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [MBProgressHUD showError:@"发送失败"];
      }];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)cancelStatus{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
