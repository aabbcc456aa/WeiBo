//
//  UIImage+WB.h
//  Weio
//
//  Created by huxiaolong on 14-8-28.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WB)

// 自动识别ios7 image
+ (UIImage *)imagewithName:(NSString *)imageName;

// 拉伸图片
+ (UIImage *)resizedImageWithName:(NSString *)imageName;

@end
