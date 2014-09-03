//
//  WBComposePhotosView.m
//  WeiBo
//
//  Created by huxiaolong on 14-9-3.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import "WBComposePhotosView.h"

@implementation WBComposePhotosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage resizedImageWithName:@"common_card_background_highlighted"]];;
    }
    return self;
}

-(void)addImage:(UIImage *)image{
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
//    imageView.contentMode = UIViewContentModeCenter;
    [self addSubview:imageView];
    
}

-(NSArray *)totalImages{
    NSMutableArray *arr = [NSMutableArray array];
    for(UIImageView *imageView in self.subviews){
        [arr addObject:imageView.image];
    }
    return arr;
}

-(void)layoutSubviews{
    CGFloat w = 70;
    CGFloat h = 70;
    int maxN = 4;
    CGFloat margin = (self.frame.size.width - maxN * w) / (maxN + 1);
    for(int i = 0; i < self.subviews.count; i++){
        UIImageView *imageView = self.subviews[i];
        int col = i % maxN;
        int row = i / maxN;
        CGFloat x = margin + (w + margin) * col;
        CGFloat y = (h + margin) * row;
        imageView.frame = CGRectMake(x, y, w, h);
    }
}

@end
