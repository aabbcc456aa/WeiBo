//
//  WBStatusFrame.h
//  ItcastWeibo
//
//  Created by apple on 14-5-9.
//  Copyright (c) 2014年 itcast. All rights reserved.
//  一个cell对应一个WBStatusFrame对象

#import <Foundation/Foundation.h>

/** 昵称的字体 */
#define WBStatusNameFont [UIFont systemFontOfSize:15]
/** 被转发微博作者昵称的字体 */
#define WBRetweetStatusNameFont WBStatusNameFont

/** 时间的字体 */
#define WBStatusTimeFont [UIFont systemFontOfSize:12]
/** 来源的字体 */
#define WBStatusSourceFont WBStatusTimeFont

/** 正文的字体 */
#define WBStatusContentFont [UIFont systemFontOfSize:13]
/** 被转发微博正文的字体 */
#define WBRetweetStatusContentFont WBStatusContentFont

/** 表格的边框宽度 */
#define WBStatusTableBorder 5

/** cell的边框宽度 */
#define WBStatusCellBorder 8

@class WBStatus;
@interface WBStatusFrame : NSObject
@property (nonatomic, strong) WBStatus *status;

/** 顶部的view */
@property (nonatomic, assign, readonly) CGRect topViewF;
/** 头像 */
@property (nonatomic, assign, readonly) CGRect iconViewF;
/** 会员图标 */
@property (nonatomic, assign, readonly) CGRect vipViewF;
/** 配图 */
@property (nonatomic, assign, readonly) CGRect photoViewF;
/** 昵称 */
@property (nonatomic, assign, readonly) CGRect nameLabelF;
/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/** 来源 */
@property (nonatomic, assign) CGRect sourceLabelF;
/** 正文\内容 */
@property (nonatomic, assign, readonly) CGRect contentLabelF;

/** 被转发微博的view(父控件) */
@property (nonatomic, assign, readonly) CGRect retweetViewF;
/** 被转发微博作者的昵称 */
@property (nonatomic, assign, readonly) CGRect retweetNameLabelF;
/** 被转发微博的正文\内容 */
@property (nonatomic, assign, readonly) CGRect retweetContentLabelF;
/** 被转发微博的配图 */
@property (nonatomic, assign, readonly) CGRect retweetPhotoViewF;

/** 微博的工具条 */
@property (nonatomic, assign, readonly) CGRect statusToolbarF;

/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
