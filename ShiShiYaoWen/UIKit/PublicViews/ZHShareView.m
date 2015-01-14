//
//  ZHShareView.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/15.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHShareView.h"

@implementation ZHShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)selectButtonClicked:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(shareSelectButtonWithType:)]) {
        ZHShareViewSelectType type;
        switch (sender.tag) {
            case 1001:
                type = ZHShareViewSelectTypeWithTXWeibo;
                break;
            case 1002:
                type = ZHShareViewSelectTypeWithEmail;
                break;
            case 1003:
                type = ZHShareViewSelectTypeWithSinaWeibo;
                break;
            case 1004:
                type = ZHShareViewSelectTypeWithTxQQ;
                break;
            case 1005:
                type = ZHShareViewSelectTypeWithTxQQZone;
                break;
            case 2001:
                type = ZHShareViewSelectTypeWithCancel;
                break;
            default:
                break;
        }
        [_delegate shareSelectButtonWithType:type];
    }
}
@end
