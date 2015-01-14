//
//  ZHDetailTitleView.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/5.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHInformationCellModel.h"

@interface ZHDetailTitleView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (void)showTitleDataWithModel:(ZHInformationCellModel *)model;

@end
