//
//  WBStatusTopView.m
//  WeiBo
//
//  Created by huxiaolong on 14-9-2.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import "WBStatusTopView.h"
#import "WBStatusFrame.h"
#import "WBStatus.h"
#import "WBUser.h"
#import "UIImageView+WebCache.h"
#import "WBPhotosView.h"

@interface WBStatusTopView()
/** 头像 */
@property (nonatomic, weak) UIImageView *iconView;
/** 会员图标 */
@property (nonatomic, weak) UIImageView *vipView;
/** 配图 */
@property (nonatomic, strong) WBPhotosView *photoView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 来源 */
@property (nonatomic, weak) UILabel *sourceLabel;
/** 正文\内容 */
@property (nonatomic, weak) UILabel *contentLabel;

/** 被转发微博的view(父控件) */
@property (nonatomic, weak) UIImageView *retweetView;
/** 被转发微博作者的昵称 */
@property (nonatomic, weak) UILabel *retweetNameLabel;
/** 被转发微博的正文\内容 */
@property (nonatomic, weak) UILabel *retweetContentLabel;
/** 被转发微博的配图 */
@property (nonatomic, weak) UIImageView *retweetPhotoView;

@end

@implementation WBStatusTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.userInteractionEnabled = YES;
    if (self) {
        [self setupTopView];
        [self setupRetweetSubviews];
    }
    return self;
}

/** 1.顶部的view */
-(void)setupTopView{
    self.image = [UIImage resizedImageWithName:@"timeline_card_top_background"];
    self.highlightedImage = [UIImage resizedImageWithName:@"timeline_card_top_background_highlighted"];

    /** 2.头像 */
    UIImageView *iconView = [[UIImageView alloc] init];
    [self addSubview:iconView];
    self.iconView = iconView;

    /** 3.会员图标 */
    UIImageView *vipView = [[UIImageView alloc] init];
    [self addSubview:vipView];
    self.vipView = vipView;

    /** 4.配图 */
//    UIImageView *photoView = [[UIImageView alloc] init];
    WBPhotosView *photoView = [[WBPhotosView alloc]init];
    [self addSubview:photoView];
    self.photoView = photoView;

    /** 5.昵称 */
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = WBStatusNameFont;
    nameLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:nameLabel];
    self.nameLabel = nameLabel;

    /** 6.时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = WBStatusTimeFont;
    timeLabel.textColor = WBColor(240, 140, 19);
    timeLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;

    /** 7.来源 */
    UILabel *sourceLabel = [[UILabel alloc] init];
    sourceLabel.font = WBStatusSourceFont;
    sourceLabel.textColor = WBColor(135, 135, 135);
    sourceLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:sourceLabel];
    self.sourceLabel = sourceLabel;

    /** 8.正文\内容 */
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = WBColor(39, 39, 39);
    contentLabel.font = WBStatusContentFont;
    contentLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:contentLabel];
    self.contentLabel = contentLabel;
}

/**
 *  添加被转发微博内部的子控件
 */
- (void)setupRetweetSubviews
{
    /** 1.被转发微博的view(父控件) */
    UIImageView *retweetView = [[UIImageView alloc] init];
    retweetView.image = [UIImage resizedImageWithName:@"timeline_retweet_background" left:0.9 top:0.5];
    [self addSubview:retweetView];
    self.retweetView = retweetView;
    
    /** 2.被转发微博作者的昵称 */
    UILabel *retweetNameLabel = [[UILabel alloc] init];
    retweetNameLabel.font = WBRetweetStatusNameFont;
    retweetNameLabel.textColor = WBColor(67, 107, 163);
    retweetNameLabel.backgroundColor = [UIColor clearColor];
    [self.retweetView addSubview:retweetNameLabel];
    self.retweetNameLabel = retweetNameLabel;
    
    /** 3.被转发微博的正文\内容 */
    UILabel *retweetContentLabel = [[UILabel alloc] init];
    retweetContentLabel.font = WBRetweetStatusContentFont;
    retweetContentLabel.backgroundColor = [UIColor clearColor];
    retweetContentLabel.numberOfLines = 0;
    retweetContentLabel.textColor = WBColor(90, 90, 90);
    [self.retweetView addSubview:retweetContentLabel];
    self.retweetContentLabel = retweetContentLabel;
    
    /** 4.被转发微博的配图 */
    UIImageView *retweetPhotoView = [[UIImageView alloc] init];
    [self.retweetView addSubview:retweetPhotoView];
    self.retweetPhotoView = retweetPhotoView;
}


-(void)setStatusFrame:(WBStatusFrame *)statusFrame{
    _statusFrame = statusFrame;
    // 1.重新计算被改变的元素Frame
    [self reCalChangedF];
    [self setupOriginalData];
    [self setupRetweetData];
}
/**
 *  原创微博
 */
- (void)setupOriginalData
{
    WBStatus *status = self.statusFrame.status;
    WBUser *user = status.user;
    
    // 1.topView
    self.frame = self.statusFrame.topViewF;
    
    // 2.头像
    [self.iconView setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageWithName:@"avatar_default_small"]];
    self.iconView.frame = self.statusFrame.iconViewF;
    
    // 3.昵称
    self.nameLabel.text = user.name;
    self.nameLabel.frame = self.statusFrame.nameLabelF;
    
    // 4.vip
    if (user.isVip) {
        self.vipView.hidden = NO;
        self.vipView.image = [UIImage imageWithName:@"common_icon_membership"];
        self.vipView.frame = self.statusFrame.vipViewF;
    } else {
        self.vipView.hidden = YES;
    }
    
    
    // 5.时间
    self.timeLabel.text = status.created_at ;
    self.timeLabel.frame = self.statusFrame.timeLabelF;
    
    // 6.来源
    self.sourceLabel.text = status.source;
    self.sourceLabel.frame = self.statusFrame.sourceLabelF;
    
    // 7.正文
    self.contentLabel.text = status.text;
    self.contentLabel.frame = self.statusFrame.contentLabelF;
    
    // 8.配图
    if (status.pic_urls) {
        self.photoView.hidden = NO;
        self.photoView.frame = self.statusFrame.photoViewF;
        self.photoView.photos = self.statusFrame.status.pic_urls;
//        [self.photoView setImageWithURL:[NSURL URLWithString:status.thumbnail_pic] placeholderImage:[UIImage imageWithName:@"timeline_image_placeholder"]];
    } else {
        self.photoView.hidden = YES;
    }
}

/**
 *  被转发微博
 */
- (void)setupRetweetData
{
    WBStatus *retweetStatus = self.statusFrame.status.retweeted_status;
    WBUser *user = retweetStatus.user;
    
    // 1.父控件
    if (retweetStatus) {
        self.retweetView.hidden = NO;
        self.retweetView.frame = self.statusFrame.retweetViewF;
        
        // 2.昵称
        self.retweetNameLabel.text = [NSString stringWithFormat:@"@%@", user.name];
        self.retweetNameLabel.frame = self.statusFrame.retweetNameLabelF;
        
        // 3.正文
        self.retweetContentLabel.text = retweetStatus.text;
        self.retweetContentLabel.frame = self.statusFrame.retweetContentLabelF;
        
        // 4.配图
        if (retweetStatus.thumbnail_pic) {
            self.retweetPhotoView.hidden = NO;
            self.retweetPhotoView.frame = self.statusFrame.retweetPhotoViewF;
            [self.retweetPhotoView setImageWithURL:[NSURL URLWithString:retweetStatus.thumbnail_pic] placeholderImage:[UIImage imageWithName:@"timeline_image_placeholder"]];
        } else {
            self.retweetPhotoView.hidden = YES;
        }
    } else {
        self.retweetView.hidden = YES;
    }
}


// beause time ago is changing every time
-(void)reCalChangedF{
    // 5.时间
    CGRect timeLabelF = self.statusFrame.timeLabelF;
    timeLabelF.size = [self.statusFrame.status.created_at sizeWithFont:WBStatusTimeFont];
    self.statusFrame.timeLabelF = timeLabelF;
    
    // source
    CGRect sourceLabelF = self.statusFrame.sourceLabelF;
    sourceLabelF.origin.x = CGRectGetMaxX(timeLabelF) + WBStatusCellBorder;
    self.statusFrame.sourceLabelF = sourceLabelF;
}

@end
