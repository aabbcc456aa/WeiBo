//
//  WBPhotosView.m
//  WeiBo
//
//  Created by huxiaolong on 14-9-2.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import "WBPhotosView.h"
#import "WBPhoto.h"
#import "WBPhotoImage.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define WBPhotoW 70
#define WBPhotoH 70
#define WBPhotoMargin 10

@implementation WBPhotosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        // create 9 imageView for photo
        for(int i = 0 ; i < 9 ; i++){
            WBPhotoImage *photoView = [[WBPhotoImage alloc]init];
            photoView.userInteractionEnabled = YES;
            photoView.tag = i;
           [photoView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
            [self addSubview:photoView];
        }
    }
    return self;
}

- (void)setPhotos:(NSArray *)photos{
    _photos = photos;
    
    CGFloat width = WBPhotoW;
    CGFloat height = WBPhotoH;
    CGFloat margin = WBPhotoMargin;
    CGFloat startX = (self.frame.size.width - 3 * width - 2 * margin) * 0.5;
    CGFloat startY = 0;
    for (int i = 0; i< 9; i++) {
        WBPhotoImage *photoView = self.subviews[i];
        // 计算位置
        int row = i/3;
        int column = i%3;
        CGFloat x = startX + column * (width + margin);
        CGFloat y = startY + row * (height + margin);
     
        photoView.frame = CGRectMake(x, y, width, height);
        
        if (i < photos.count){
            photoView.photo = photos[i];
            photoView.clipsToBounds = YES;
            photoView.contentMode = UIViewContentModeScaleAspectFill;
            photoView.hidden = NO;

        }else{
            photoView.hidden = YES;
        }
    }
}


- (void)tapImage:(UITapGestureRecognizer *)tap
{
    int count = self.photos.count;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        WBPhotoImage *photoView = self.subviews[i];
        // 替换为中等尺寸图片
        NSString *url = [photoView.photo.thumbnail_pic stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = self.subviews[i]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

+ (CGSize)photosViewSizeWithPhotosCount:(int)count
{
    // 一行最多有3列
    int maxColumns = (count == 4) ? 2 : 3;
    
    //  总行数
    int rows = (count + maxColumns - 1) / maxColumns;
    // 高度
    CGFloat photosH = rows * WBPhotoH + (rows - 1) * WBPhotoMargin;
    
    // 总列数
    int cols = (count >= maxColumns) ? maxColumns : count;
    // 宽度
    CGFloat photosW = cols * WBPhotoW + (cols - 1) * WBPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
    /**
     一共60条数据 == count
     一页10条 == size
     总页数 == pages
     pages = (count + size - 1)/size;
     */
}

@end
