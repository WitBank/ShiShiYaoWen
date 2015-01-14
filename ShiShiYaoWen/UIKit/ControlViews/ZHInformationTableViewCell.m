//
//  ZHInformationTableViewCell.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/5.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHInformationTableViewCell.h"
#import <UIImageView+AFNetworking.h>
#import "AppDelegate.h"
#import "ZHCoreDataManage.h"
@implementation ZHInformationTableViewCell
{
    NSString *_newsId;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)switchPraiseClicked:(UIButton *)sender {
    [self setPraiseButtonSelectType:!_praiseButtonSelected];
}

- (void)showDataWithModel:(ZHInformationCellModel *)model andFont:(CGFloat)fontSize
{
    [_praiseButton setImage:[UIImage imageNamed:@"ZH_Information_Praise_select"] forState:UIControlStateSelected];
    if (model.titleimg != nil && ![model.titleimg isEqualToString:@""]) {
        [_headImageView setImageWithURL:[NSURL URLWithString:model.titleimg]];
    }
    _newsId = m_return_String(model.newsid);
    AppDelegate *r_appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (int i =0; i < [r_appDelegate.praiseArray count]; i++) {
        ZHPraiseStepModel *model = [r_appDelegate.praiseArray objectAtIndex:i];
        if ([model.newsId isEqualToString:_newsId]) {
            if ([model.isPraise isEqualToString:@"1"]) {
                [_praiseButton setSelected:YES];
                _praiseButtonSelected = YES;
                [_praiseButton setImage:[UIImage imageNamed:@"ZH_Information_Praise_select"] forState:UIControlStateNormal];
            }
            break;
        }
    }
    [_titleLabel setText:m_return_String(model.title)];
    [_timeLabel setText:m_return_String(model.pubdate)];
    [_praiseNumberLabel setText:m_return_String(model.praise)];
    [_titleLabel setFont:[UIFont systemFontOfSize:17.0f+fontSize]];
    [_timeLabel setFont:[UIFont systemFontOfSize:12.0f+fontSize]];
    [_praiseNumberLabel setFont:[UIFont systemFontOfSize:12.0f+fontSize]];
    
}

- (void)setPraiseButtonSelectType:(BOOL)selected
{
    [_praiseButton setSelected:selected];
    int num = [_praiseNumberLabel.text intValue];
    if (_praiseButtonSelected == NO) {
        _praiseButtonSelected = YES;
        num += 1;
        [_praiseButton setImage:[UIImage imageNamed:@"ZH_Information_Praise_select"] forState:UIControlStateNormal];
        AppDelegate *r_appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        ZHPraiseStepModel *model = [[ZHPraiseStepModel alloc] init];
        model.newsId = _newsId;
        model.isPraise = @"1";
        [r_appDelegate.praiseArray addObject:model];
        [ZHCoreDataManage savePraiseStepWithNewsId:_newsId andPraise:YES];
    }
    [_praiseNumberLabel setText:[NSString stringWithFormat:@"%d",num]];
}

@end
