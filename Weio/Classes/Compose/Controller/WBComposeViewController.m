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
#import "WBComposeToolBar.h"


@interface WBComposeViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, WbComposeToolBarDelegate>

@property(nonatomic,strong) WBTextView *textView;
@property(nonatomic,strong) WBComposeToolBar *toolBar;

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
    
    // init compose button with more function
    [self setupComposeToolBar];
    
}
-(void)setupComposeToolBar{
    WBComposeToolBar *toolBar = [[WBComposeToolBar alloc]init];
    CGFloat h = 44;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    toolBar.frame = CGRectMake(0, screenSize.height - h, screenSize.width, h);
    toolBar.delegate =  self;
    [self.view addSubview:toolBar];
    self.toolBar = toolBar;
    
    // 监听键盘改变  而更改微博工具条
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
}

// 实现 toolBar 协议中方法
-(void)toolBarButtonDidClick:(UIButton *)btn{
    switch (btn.tag) {
        case WBComposeToolBarButtonTypeCamera:
            [self openCamera];
            break;
        case WBComposeToolBarButtonTypePicture:
            [self openPicture];
            break;
        default:
            break;
    }
}


// 打开相机  需要真机 调试
-(void)openCamera{
    UIImagePickerController *pickerCon = [[UIImagePickerController alloc]init];
    pickerCon.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerCon.delegate = self;
    [self presentViewController:pickerCon animated:YES completion:nil];
}

// 打开相册
-(void)openPicture{
    UIImagePickerController *pickerCon = [[UIImagePickerController alloc]init];
    pickerCon.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerCon.delegate = self;
    [self presentViewController:pickerCon animated:YES completion:nil];
}

//保留图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
//    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:info[UIImagePickerControllerOriginalImage]];
    imageView.frame = CGRectMake(5, 100, 100, 100);
    [self.textView addSubview:imageView];
//    image
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



//监听键盘 弹出
-(void)keyboardWillShow:(NSNotification *)noti{
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect rect  = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:duration animations:^{
          self.toolBar.transform = CGAffineTransformMakeTranslation(0, - rect.size.height);
    }];
}

//监听键盘 隐藏
-(void)keyboardWillHide:(NSNotification *)noti{
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.toolBar.transform = CGAffineTransformIdentity;
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

-(void)setupTextView{
    WBTextView *textView = [[WBTextView alloc]init];
    textView.font = [UIFont systemFontOfSize:16];
    [textView setTextColor:[UIColor blackColor]];
    textView.frame = self.view.bounds;
    textView.returnKeyType = UIReturnKeySend;
    [textView setHolderText:@"分享趣事..." ];
    textView.delegate = self;
    textView.alwaysBounceVertical = YES;
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
