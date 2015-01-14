//
//  ZHInformationTableViewCell.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/5.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHInformationCellModel.h"

@interface ZHInformationTableViewCell : UITableViewCell
{
    BOOL _praiseButtonSelected;
}
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *praiseButton;
@property (weak, nonatomic) IBOutlet UILabel *praiseNumberLabel;

- (IBAction)switchPraiseClicked:(UIButton *)sender;
- (void)showDataWithModel:(ZHInformationCellModel *)model andFont:(CGFloat)fontSize;

- (void)setPraiseButtonSelectType:(BOOL)selected;

@end
