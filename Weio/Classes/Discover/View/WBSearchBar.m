//
//  WBSearchBar.m
//  WeiBo
//
//  Created by huxiaolong on 14-8-29.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import "WBSearchBar.h"

@implementation WBSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackground:[UIImage resizedImageWithName:@"searchbar_textfield_background"]];
        
        // 左边图标
        UIImageView *searchIcon = [[UIImageView alloc]initWithImage:[UIImage imageWithName:@"searchbar_textfield_search_icon"]];
        searchIcon.contentMode = UIViewContentModeCenter;
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        //右边图标
        self.clearButtonMode = UITextFieldViewModeAlways;
        
        // 默认文字
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[UITextAttributeTextColor]  =[UIColor grayColor];
        self.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"search" attributes:dict];
        
        // return button
        self.returnKeyType = UIReturnKeySearch;
        self.enablesReturnKeyAutomatically  =YES;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.leftView.frame = CGRectMake(0, 0, 30, self.frame.size.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
