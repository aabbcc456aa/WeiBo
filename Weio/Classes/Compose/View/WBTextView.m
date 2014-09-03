//
//  WBTextView.m
//  WeiBo
//
//  Created by huxiaolong on 14-9-3.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import "WBTextView.h"

@interface WBTextView()
@property (nonatomic,weak) UILabel *textViewHolder;

@end


@implementation WBTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel *label = [[UILabel alloc]init];
        [label setTextColor:[UIColor lightGrayColor]];
        [label setFont:[UIFont systemFontOfSize:16]];
        [label setBackgroundColor:[UIColor clearColor]];
        label.numberOfLines = 0;
        label.hidden = YES;
        [self insertSubview:label belowSubview:self];
        self.textViewHolder = label;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(polderChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}


// listen notification
-(void)polderChange:(NSNotification *)noti{
    if(self.text){
        self.textViewHolder.hidden = YES;
    }else{
        self.textViewHolder.hidden = NO;
    }
}

-(void)setHolderText:(NSString *)text{
    self.textViewHolder.hidden = (text.length == 0);
    if(text){
        self.textViewHolder.hidden = NO;
        self.textViewHolder.text = text;
        CGFloat x = 5;
        CGFloat y = 5;
        CGFloat maxW = [UIScreen mainScreen].bounds.size.width - 2 * x;
        CGFloat maxH = [UIScreen mainScreen].bounds.size.height - 2 * y;
        CGSize size = [text sizeWithFont:self.textViewHolder.font constrainedToSize:(CGSize){maxW,maxH}];
        self.textViewHolder.frame = CGRectMake(x, y, size.width, size.height);
    }else{
       self.textViewHolder.hidden = YES;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
