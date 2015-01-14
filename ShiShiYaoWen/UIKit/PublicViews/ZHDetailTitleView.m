//
//  ZHDetailTitleView.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/5.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHDetailTitleView.h"

@implementation ZHDetailTitleView

- (void)showTitleDataWithModel:(ZHInformationCellModel *)model
{
    [_titleLabel setText:model.title];
    [_sourceLabel setText:model.author];
    [_timeLabel setText:model.pubdate];
}

@end
