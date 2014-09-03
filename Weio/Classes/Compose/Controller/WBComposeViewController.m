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
#import "WBComposePhotosView.h"


@interface WBComposeViewController ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, WbComposeToolBarDelegate>

@property(nonatomic,strong) WBTextView *textView;
@property(nonatomic,strong) WBComposeToolBar *toolBar;
@property(nonatomic,strong) WBComposePhotosView *photosView;

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
    
    //图片区域
    [self setupComposePhotosView];
    
    // init compose button with more function
    [self setupComposeToolBar];
   
    
}

-(void)setupComposePhotosView{
    WBComposePhotosView *photosView = [[WBComposePhotosView alloc]init];
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    photosView.frame = CGRectMake(0, 150, w, 300);
    [self.view addSubview:photosView];
    self.photosView = photosView;
    
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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
    [self.photosView addImage:info[UIImagePickerControllerOriginalImage]];
    [self dismissViewControllerAnimated:YES completion:nil];
    if(self.photosView.totalImages.count == 2){
        UIButton *btn1 = self.toolBar.subviews[0];
        UIButton *btn2 = self.toolBar.subviews[1];
         btn1.enabled = NO;
         btn2.enabled = NO;
    }else{
        UIButton *btn1 = self.toolBar.subviews[0];
        UIButton *btn2 = self.toolBar.subviews[1];
        btn1.enabled = NO;
        btn2.enabled = YES;
    }
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
    
     // 3.发送请求 no photo
    if(!self.photosView.totalImages){
        [mgr POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [MBProgressHUD showSuccess:@"发送成功"];
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [MBProgressHUD showError:@"发送失败"];
          }];
    }else{
       [mgr POST:@"https://api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
           NSArray *imageArr = self.photosView.totalImages;
           for(UIImage *image in imageArr){
               NSData *imageData  = UIImageJPEGRepresentation(image, 0.2);
               [formData appendPartWithFileData:imageData name:@"pic" fileName:@"" mimeType:@"image/jpeg"];
           }
        }success:^(AFHTTPRequestOperation *operation, id responseObject) {
           [MBProgressHUD showSuccess:@"发送成功"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           [MBProgressHUD showError:[NSString stringWithFormat:@"发送失败:%@",error]];
        }];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)cancelStatus{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
