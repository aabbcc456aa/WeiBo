//
//  WBOAuthViewController.m
//  WeiBo
//
//  Created by huxiaolong on 14-8-31.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import "WBOAuthViewController.h"
#import "AFNetworking.h"
#import "WBAccount.h"
#import "WBAccountTool.h"
#import "WBNewfeatureViewController.h"
#import "MBProgressHUD+MJ.h"
#import "WBTabBarViewController.h"

@interface WBOAuthViewController () <UIWebViewDelegate>

@end

@implementation WBOAuthViewController

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
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    webView.delegate = self;
    [self.view addSubview:webView];
    [self.view setBackgroundColor:[UIColor redColor]];
    NSString *urlStr = @"https://api.weibo.com/oauth2/authorize?client_id=3474468577&redirect_uri=http://www.baidu.com";
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlStr = request.URL.absoluteString;
    NSRange range = [urlStr rangeOfString:@"code="];
    if(range.length){
//        NSLog(@"----enter - -,%@:  ",urlStr);
        int loc = range.location + range.length;
        NSString *code = [urlStr substringFromIndex:loc];
        [self exchangeAccessorToken:code];
    }else{
//        NSLog(@"%@",range.length);
    }
    return YES;
}


//USERNAME huxiaolong100@126.com
-(void) exchangeAccessorToken:(NSString *)code{
    [MBProgressHUD showError:@"正在加载..."];
//    NSLog(@"-----CODE:%@",code);
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // 2.封装请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = @"3474468577";
    params[@"client_secret"] = @"87304db2bc8416b37c606310d0a56e2c";
    params[@"grant_type"] = @"authorization_code";
    params[@"code"] = code;
    params[@"redirect_uri"] = @"http://www.baidu.com";
    
    // 3.发送请求
    [manger POST:@"https://api.weibo.com/oauth2/access_token" parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          // 4.先将字典转为模型
          WBAccount *account = [WBAccount accountWithDict:responseObject];
          
          // 5.存储模型数据
          [WBAccountTool saveAccount:account];
          
          // 6.新特性\去首页
          self.view.window.rootViewController = [[WBTabBarViewController alloc]init];
               } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          NSLog(@"请求失败:%@", error);
      }];
    [MBProgressHUD hideHUD];

}

//- (void)webViewDidStartLoad:(UIWebView *)webView{
//   [MBProgressHUD showMessage:@"正在加载"];
//}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
   [MBProgressHUD hideHUD];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD showError:@"加载失败"];
}


@end
