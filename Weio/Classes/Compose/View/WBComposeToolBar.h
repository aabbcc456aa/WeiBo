//
//  WBComposeToolBar.h
//  WeiBo
//
//  Created by huxiaolong on 14-9-3.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WBComposeToolBarButtonTypeCamera,
    WBComposeToolBarButtonTypePicture,
    WBComposeToolBarButtonTypeMention,
    WBComposeToolBarButtonTypeTrend,
    WBComposeToolBarButtonTypeEmotion
} WBComposeToolbarButtonType;

@protocol WbComposeToolBarDelegate  <NSObject>

-(void)toolBarButtonDidClick:(UIButton *)btn;

@end


@interface WBComposeToolBar : UIView

@property (nonatomic,assign) id<WbComposeToolBarDelegate> delegate;

@end
