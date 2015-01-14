//
//  ZHInformationHeadView.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/5.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHInformationHeadView.h"

@implementation ZHInformationHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArray
{
    self = [super initWithFrame:frame andTitleArray:titleArray];
    titleCount = [titleArray count];
//    _lineRect = CGRectMake(0, self.frame.size.height-2, self.frame.size.width/titleCount, 2);
    if (self) {
//        _selectLineView = [[UIView alloc] initWithFrame:_lineRect];
//        [_selectLineView setBackgroundColor:[UIColor orangeColor]];
//        [self addSubview:_selectLineView];
    }
    return self;
}

- (void)titleBtnClicked:(UIButton *)button
{
    if (_lastTag != button.tag - 1000) {
        [super titleBtnClicked:button];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.1 animations:^{
            [_selectLineView setFrame:_lineRect];
        } completion:^(BOOL finished) {
            _lineRect.origin.x = (self.frame.size.width/titleCount)*_lastTag;
            [_selectLineView setFrame:_lineRect];
        }];
    }
}

@end
