//
//  WBStatusCell.m
//  WeiBo
//
//  Created by huxiaolong on 14-9-1.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//
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
#define WBStatusCellBorder 10


#import "WBStatusCell.h"
#import "WBStatusFrame.h"
#import "WBUser.h"
#import "WBStatus.h"
#import "UIImageView+WebCache.h"
#import "WBStatusTopView.h"

@interface WBStatusCell()
/** 顶部的view */
@property (nonatomic, strong) WBStatusTopView *topView;

/** 微博的工具条 */
@property (nonatomic, weak) UIImageView *statusToolbar;

@end

@implementation WBStatusCell
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"WB";
    WBStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[WBStatusCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 1.添加原创微博内部的子控件
        [self setupOriginalSubviews];
        
        
        // 3.添加微博的工具条
        [self setupStatusToolBar];
    }
    return self;
}

/**
 *  添加原创微博内部的子控件
 */
- (void)setupOriginalSubviews
{
    self.selectedBackgroundView = [[UIView alloc]init];
    self.backgroundColor = [UIColor clearColor];
    
    self.topView = [[WBStatusTopView alloc]init];
    [self.contentView addSubview:self.topView];
}


/**
 *  添加微博的工具条
 */
- (void)setupStatusToolBar
{
    /** 1.微博的工具条 */
    UIImageView *statusToolbar = [[UIImageView alloc] init];
    statusToolbar.image = [UIImage resizedImageWithName:@"timeline_card_bottom_background"];
    [self.contentView addSubview:statusToolbar];
    self.statusToolbar = statusToolbar;
}

-(void) setFrame:(CGRect)frame{
    frame.origin.x += 5;
    frame.origin.y += 5;
    frame.size.width -= 10;
    frame.size.height -= WBStatusTableBorder;
    [super setFrame:frame];
}

- (void)setStatusFrame:(WBStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    // 1.原创微博
    [self.topView setStatusFrame:statusFrame];
    
    
    // 3.微博工具条
    [self setupStatusToolbar];
}

/**
 *  微博工具条
 */
- (void)setupStatusToolbar
{
    self.statusToolbar.frame = self.statusFrame.statusToolbarF;
}




@end
