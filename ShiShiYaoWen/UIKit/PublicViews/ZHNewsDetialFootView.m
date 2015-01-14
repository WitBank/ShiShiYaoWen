//
//  ZHNewsDetialFootView.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/8.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHNewsDetialFootView.h"

@implementation ZHNewsDetialFootView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        [_sizeButton setBackgroundImage:[UIImage imageNamed:@"ZH_tabbar_Magnifier_add_select"] forState:UIControlStateHighlighted];
        [_collectButton setImage:[UIImage imageNamed:@"ZH_tabbar_Collect_select"] forState:UIControlStateHighlighted];
        [_praiseButton setImage:[UIImage imageNamed:@"ZH_tabbar_Praise_select"] forState:UIControlStateHighlighted];
        [_stepButton setImage:[UIImage imageNamed:@"ZH_tabbar_Share_select"] forState:UIControlStateHighlighted];
        [_shareButton setImage:[UIImage imageNamed:@"ZH_tabbar_Step_select"] forState:UIControlStateHighlighted];
        
    }
    return self;
}

//点击button所返回的代理
- (IBAction)selectButtonClicked:(UIButton *)sender {
    if (sender.tag <1006 && sender.tag > 1000 && _delegate && [_delegate respondsToSelector:@selector(selectFootButtonWithType:andButton:)]) {
        ZHFootSelectType selectType;
        switch (sender.tag) {
//            case 1001:
//                selectType = ZHFootSelectTypeSize;
//                break;
            case 1002:
                selectType = ZHFootSelectTypeCollect;
                if (_collectSelect == YES) {
                    [self setCollectButtonSelected:NO];
                }else{
                    [self setCollectButtonSelected:YES];
                }
                break;
            case 1003:
                selectType = ZHFootSelectTypePraise;
                [self setPraiseButtonSelected];
                break;
            case 1004:
                selectType = ZHFootSelectTypeStep;
                [self setSetpButtonSelected];
                break;
            case 1005:
                selectType = ZHFootSelectTypeShare;
                break;
            default:
                break;
        }
        [_delegate selectFootButtonWithType:selectType andButton:sender];
    }
}

- (void)setCollectButtonSelected:(BOOL)selected
{
    _collectSelect = selected;
    if (selected == YES) {
        [_collectButton setImage:[UIImage imageNamed:@"ZH_tabbar_Collect_select"] forState:UIControlStateNormal];
    }else{
        [_collectButton setImage:[UIImage imageNamed:@"ZH_tabbar_Collect_normal"] forState:UIControlStateNormal];
    }
}

- (void)setPraiseButtonSelected
{
    [_praiseButton setSelected:YES];
    [_praiseButton setEnabled:NO];
    [_stepButton setEnabled:NO];
    [_praiseButton setImage:[UIImage imageNamed:@"ZH_tabbar_Praise_select"] forState:UIControlStateNormal];
}

- (void)setSetpButtonSelected
{
    [_stepButton setSelected:YES];
    [_stepButton setEnabled:NO];
    [_praiseButton setEnabled:NO];
    [_stepButton setImage:[UIImage imageNamed:@"ZH_tabbar_Step_select"] forState:UIControlStateNormal];
}


@end
