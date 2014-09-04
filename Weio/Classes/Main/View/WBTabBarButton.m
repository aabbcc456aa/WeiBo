//
//  WBTabBarButton.m
//  Weio
//
//  Created by huxiaolong on 14-8-28.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import "WBTabBarButton.h"

#define imagePro 0.6
// 按钮的默认文字颜色
#define  WBTabBarButtonTitleColor (IOS7 ? [UIColor blackColor] : [UIColor whiteColor])
// 按钮的选中文字颜色
#define  WBTabBarButtonTitleSelectedColor (IOS7 ? WBColor(234, 103, 7) : WBColor(248, 139, 0))

@interface WBTabBarButton()

    @property (nonatomic,weak) UIButton *badgeBtn;

@end

@implementation WBTabBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self setTitleColor:WBTabBarButtonTitleColor forState:UIControlStateNormal];
        [self setTitleColor:WBTabBarButtonTitleSelectedColor forState:UIControlStateSelected];
        if(!IOS7){
            [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_slider"]]];
        }
        
    }
    
   // create badge icon
    UIButton *badgeBtn = [[UIButton alloc]init];
    [badgeBtn setBackgroundImage:[UIImage resizedImageWithName:@"main_badge" ] forState:UIControlStateNormal];
    badgeBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    badgeBtn.userInteractionEnabled = NO;
    badgeBtn.tintColor = [UIColor whiteColor];
    badgeBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin ;
    self.badgeBtn = badgeBtn;
    [self addSubview:badgeBtn];
    return self;
}

-(void)setItem:(UITabBarItem *)item{
    _item = item;
    [self setTitle:item.title forState:UIControlStateNormal];
    [self setImage:item.image forState:UIControlStateNormal];
    [self setImage:item.selectedImage forState:UIControlStateSelected];
    [self setBadgeValue:item.badgeValue];
    
    
    
    [item addObserver:self forKeyPath:@"title" options:0 context:nil];
    [item addObserver:self forKeyPath:@"image" options:0 context:nil];
    [item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
}

- (void)dealloc{
    [self.item removeObserver:self forKeyPath:@"title"];
    [self.item removeObserver:self forKeyPath:@"image"];
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [self setTitle:self.item.title forState:UIControlStateNormal];
    [self setTitle:self.item.title forState:UIControlStateSelected];
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
    
    [self setBadgeValue:self.item.badgeValue];
    
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat h = contentRect.size.height * imagePro;
    CGFloat w = contentRect.size.width;
    return CGRectMake(x, y, w, h);

}
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat x = 0;
    CGFloat y = contentRect.size.height * imagePro ;
    CGFloat h = contentRect.size.height * (1 - imagePro);
    CGFloat w = contentRect.size.width;
    return CGRectMake(x, y, w, h);
}

-(void)setBadgeValue:(NSString *)badgeValue{
    if(badgeValue && [badgeValue intValue] > 0){
        self.badgeBtn.hidden = NO;
        [self.badgeBtn setTitle:badgeValue forState:UIControlStateNormal];
        CGSize titleSize = [badgeValue sizeWithFont:self.badgeBtn.titleLabel.font];
        CGSize imageSize = self.badgeBtn.currentBackgroundImage.size;
        CGFloat margin = 3;
        CGFloat y = margin;
        CGFloat w = imageSize.width;
        if(badgeValue.length > 1){
          w = imageSize.width + titleSize.width - 5;
        }
        CGFloat x = self.frame.size.width - margin - w;
        CGFloat h = imageSize.height;
        
        self.badgeBtn.frame = CGRectMake(x, y, w, h);
         NSLog(@"----%@--:",NSStringFromCGRect(self.badgeBtn.frame));
    }else{
        self.badgeBtn.hidden = YES;
    }
}

@end
