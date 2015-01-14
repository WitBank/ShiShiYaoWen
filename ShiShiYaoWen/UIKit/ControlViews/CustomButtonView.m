//
//  CustomButtonView.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/5.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "CustomButtonView.h"
#import "ZHTitleModel.h"

@implementation CustomButtonView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArray
{
    self = [super initWithFrame:frame];
    CGRect rect = CGRectMake(0, 0, self.frame.size.width/[titleArray count], self.frame.size.height);
    if (self) {
        for (int i = 0; i < [titleArray count]; i++) {
            ZHTitleModel *model = [titleArray objectAtIndex:i];
            UIButton *titleButton = [ZHCustomControl _customUIButtonWithTitle:model.titleName
                                                                      andFont:16.0f
                                                                andTitleColor:[UIColor blackColor]
                                                                    andTarget:self
                                                                       andSEL:@selector(titleBtnClicked:)
                                                              andControlEvent:UIControlEventTouchUpInside
                                                                   andBGImage:nil
                                                                     andFrame:rect];
            [titleButton setTag:1000+i];
            [self addSubview:titleButton];
            rect.origin.x += self.frame.size.width/[titleArray count];
            if (i == 0) {
                [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
    }
    return self;
}

- (void)titleBtnClicked:(UIButton *)button
{
    if (_lastTag != (button.tag - 1000)) {
        if (_delegate && [_delegate respondsToSelector:@selector(selectTitleButtonTag:)]) {
            UIButton *lastButton = (UIButton *)[self viewWithTag:(1000+_lastTag)];
            [lastButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_delegate selectTitleButtonTag:button.tag - 1000];
            _lastTag = button.tag - 1000;
        }
    }
}

@end
