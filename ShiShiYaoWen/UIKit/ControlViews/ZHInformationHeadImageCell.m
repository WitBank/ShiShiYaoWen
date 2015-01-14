//
//  ZHInformationHeadImageCell.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/19.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHInformationHeadImageCell.h"

@implementation ZHInformationHeadImageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andModelArray:(NSArray *)modelArray
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setFrame:CGRectMake(0, 0, self.frame.size.width*WIDTHPROPORTION, 140*WIDTHPROPORTION)];
        _imageHeadView = [[ZHInformationImageHeadView alloc] initWithFrame:self.contentView.bounds andModelArray:modelArray];
        [self.contentView addSubview:_imageHeadView];
        [_imageHeadView setAutoPlayWithDelay:3.0f];
    }
    return self;
}

@end
