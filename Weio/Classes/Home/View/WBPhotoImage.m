//
//  WBPhotoImage.m
//  WeiBo
//
//  Created by huxiaolong on 14-9-2.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import "WBPhotoImage.h"
#import "WBPhoto.h"
#import "UIImageView+WebCache.h"

@interface WBPhotoImage()

@property (nonatomic,weak) UIImageView *gifView;

@end

@implementation WBPhotoImage

-(id)initWithFrame:(CGRect)frame{
    self.userInteractionEnabled = YES;
    if(self = [super initWithFrame:frame]){
        UIImage *image = [UIImage imageWithName:@"timeline_image_gif"];
        UIImageView *gifView = [[UIImageView alloc]initWithImage:image];
        self.gifView = gifView;
        [self addSubview:gifView];
    }
    return self;
}

-(void)setPhoto:(WBPhoto *)photo{
    _photo = photo;
//    NSLog(@"---url:---:%@",photo.thumbnail_pic);
    self.gifView.hidden = ![photo.thumbnail_pic hasSuffix:@"gif"];
    [self setImageWithURL:[NSURL URLWithString:photo.thumbnail_pic] placeholderImage:[UIImage imageWithName:@"timeline_image_placeholder"]];

}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.gifView.layer.anchorPoint = CGPointMake(1, 1);
    self.gifView.layer.position = CGPointMake(self.frame.size.width, self.frame.size.height);
}



@end
