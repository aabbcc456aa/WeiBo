//
//  WBNewfeatureViewController.m
//  WeiBo
//
//  Created by huxiaolong on 14-8-29.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//
#define PageNum 3

#import "WBNewfeatureViewController.h"
#import "WBTabBarViewController.h"
#import "WBActionChose.h"
#import "WBOAuthViewController.h"

@interface WBNewfeatureViewController ()<UIScrollViewDelegate>
@property (nonatomic,weak) UIPageControl *pageCon;

@end

@implementation WBNewfeatureViewController

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
	// Do any additional setup after loading the view.
    [self setupScrollView];
    
    [self setupPageControl];
    
}

-(void)setupPageControl{
    UIPageControl *pageCon = [[UIPageControl alloc]init];
    pageCon.currentPage = 0;
    pageCon.numberOfPages = PageNum;
    pageCon.currentPageIndicatorTintColor = WBColor(253, 98, 42);
    pageCon.pageIndicatorTintColor = WBColor(189, 189, 189);
    pageCon.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height - 30);
    [self.view addSubview:pageCon];
    self.pageCon = pageCon;
    
}

-(void) setupScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = self.view.bounds;
    
    CGFloat screenW = self.view.frame.size.width;
    CGFloat screenH = self.view.frame.size.height;
    for(int i = 0;i < PageNum; i++){
        NSString *imageName = [NSString stringWithFormat:@"new_feature_%d",i + 1];
        UIImageView  *imageView = [[UIImageView alloc]initWithImage:[UIImage imagewithName:imageName]];
        CGFloat x = screenW * i;
        imageView.frame = CGRectMake(x, 0, screenW, screenH);
        if( i  == PageNum - 1){
            [self setupStartBtn:imageView];
        }
        [scrollView addSubview:imageView];
    }
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(screenW * PageNum, 0);
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
}

-(void)setupStartBtn:(UIImageView *)imageView{
    // -----------   开始体验按钮
    imageView.userInteractionEnabled = YES;
    UIButton *startBtn = [[UIButton alloc]init];
    [startBtn setBackgroundImage:[UIImage imagewithName:@"new_feature_finish_button"]  forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imagewithName:@"new_feature_finish_button_highlighted"]  forState:UIControlStateHighlighted];
    startBtn.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height * 0.6);
    startBtn.bounds = CGRectMake(0, 0, 110, 40);
    
    // 按钮文字
    [startBtn setTitle:@"开始体验" forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    [startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
    
  // ------------   分享按钮
    UIButton *shareBtn = [[UIButton alloc]init];
    shareBtn.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height * 0.5);
    shareBtn.bounds = CGRectMake(0, 0, 130, 40);
    
    //  分享按钮文字
    [shareBtn setTitle:@"分享给好友" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    
    // icon
    [shareBtn setImage:[UIImage imagewithName:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imagewithName:@"new_feature_share_true"] forState:UIControlStateSelected];
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:shareBtn];
    
}

-(void)startBtnClick:(UIButton *)startBtn{
    [UIApplication sharedApplication].statusBarHidden = NO;
    if([WBActionChose showLogin]){
//        self.view.window.rootViewController = [[WBOAuthViewController alloc]init];
        [UIApplication sharedApplication].keyWindow.rootViewController  = [[WBOAuthViewController alloc]init];
    }else{
        self.view.window.rootViewController = [[WBTabBarViewController alloc]init];
    }
}

-(void)shareBtnClick:(UIButton *)shareBtn{
    NSLog(@"------share click");
    shareBtn.selected = !shareBtn.selected;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    int page = (offsetX / self.view.frame.size.width + 0.5) / 1;
    self.pageCon.currentPage = page;
}


@end
