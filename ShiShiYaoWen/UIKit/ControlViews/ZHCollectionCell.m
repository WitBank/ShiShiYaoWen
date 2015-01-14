//
//  ZHCollectionCell.m
//  ShiShiYaoWen
//
//  Created by Mac on 14/12/11.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHCollectionCell.h"
#import "ZHInformationCellModel.h"
#import <UIImageView+AFNetworking.h>

#define SCREENHEIGHT    ([UIScreen mainScreen].bounds.size.height)
#define SCREENWIDTH     ([UIScreen mainScreen].bounds.size.width)

@implementation ZHCollectionCell

- (void)awakeFromNib {
    // Initialization code
//    [self showDataWithModel];
//    self.frame = CGRectMake(0, 0,SCREENWIDTH, SCREENHEIGHT);
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)showDataWithModel:(ZHInformationCellModel *)model
{
    if (model.titleimg != nil && ![model.titleimg isEqualToString:@""]) {
        [__imgView setImageWithURL:[NSURL URLWithString:model.titleimg]];
    }
//    __imgView.image = [NSString stringWithFormat:<#(NSString *), ...#>]
    
    __titleLabel.frame = CGRectMake(110, 10, SCREENWIDTH-110-10, 50);
    __titleLabel.numberOfLines = 2;
    
    __titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
    
    __timeLabel.text = [NSString stringWithFormat:@"%@",model.pubdate];
    
    __praiseButton.frame = CGRectMake((SCREENWIDTH-60), 60, 20, 20);
    __praiseLabel.frame = CGRectMake((SCREENWIDTH-40), 60, 20, 20);
    __praiseLabel.text = [NSString stringWithFormat:@"%@",model.praise];
    
}
@end
