//
//  UIImage+WB.m
//  Weio
//
//  Created by huxiaolong on 14-8-28.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import "UIImage+WB.h"

@implementation UIImage (WB)
+(UIImage *)imageWithName:(NSString *)imageName{
    NSString *newImageName = imageName;
    if(IOS7){
        newImageName = [imageName stringByAppendingString:@"_os7"];
    }
    UIImage *image = [UIImage imageNamed:newImageName];
    if (!image){
        image = [UIImage imageNamed:imageName];
    }
    return  image;
}

+ (UIImage *)resizedImageWithName:(NSString *)imageName{
    UIImage *image = [UIImage imageWithName:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
}

+ (UIImage *)resizedImageWithName:(NSString *)imageName left:(CGFloat)left top:(CGFloat)top{
    UIImage *image = [UIImage imageWithName:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}

@end
