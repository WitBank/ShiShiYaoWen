//
//  SpecialTableViewCell.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/8.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "SpecialTableViewCell.h"
#import <UIImageView+AFNetworking.h>

@implementation SpecialTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showDataWithSpecialModel:(ZHSpecialCellModel *)model andFont:(CGFloat)fontSize
{
    [_specialImageView setImageWithURL:[NSURL URLWithString:model.titleimg]];
    [_titleLabel setText:model.title];
    [_titleLabel setFont:[UIFont systemFontOfSize:14.0f+fontSize]];
}

@end
