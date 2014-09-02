//
//  WBPhotosView.h
//  WeiBo
//
//  Created by huxiaolong on 14-9-2.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBPhotosView : UIView

@property (nonatomic,weak) NSArray *photos;

+ (CGSize)photosViewSizeWithPhotosCount:(int)count;
@end
