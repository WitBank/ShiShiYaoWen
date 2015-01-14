//
//  ZHCollectionCell.h
//  ShiShiYaoWen
//
//  Created by Mac on 14/12/11.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHInformationCellModel;

@interface ZHCollectionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *_imgView;
@property (weak, nonatomic) IBOutlet UILabel *_titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *_praiseButton;
@property (weak, nonatomic) IBOutlet UILabel *_timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *_praiseLabel;

- (void)showDataWithModel:(ZHInformationCellModel *)model;

@end
