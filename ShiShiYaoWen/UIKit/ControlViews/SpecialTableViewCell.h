//
//  SpecialTableViewCell.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/8.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHSpecialCellModel.h"

@interface SpecialTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *specialImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)showDataWithSpecialModel:(ZHSpecialCellModel *)model andFont:(CGFloat)fontSize;

@end
