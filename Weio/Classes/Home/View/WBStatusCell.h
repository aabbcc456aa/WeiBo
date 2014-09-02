//
//  WBStatusCell.h
//  WeiBo
//
//  Created by huxiaolong on 14-9-1.
//  Copyright (c) 2014年 huxiaolong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBStatusFrame;

@interface WBStatusCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) WBStatusFrame *statusFrame;

@end
