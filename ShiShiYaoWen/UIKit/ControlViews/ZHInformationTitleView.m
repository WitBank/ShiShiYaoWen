//
//  ZHInformationTitleView.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/10.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHInformationTitleView.h"

@implementation ZHInformationTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addViewWithTitleArray:array];
    }
    return self;
}

- (void)addViewWithTitleArray:(NSArray *)array
{
    UIScrollView *titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - 40, self.frame.size.height)];
    [titleScrollView setShowsHorizontalScrollIndicator:NO];
    [titleScrollView setShowsVerticalScrollIndicator:NO];
    [titleScrollView setBounces:NO];
    [self addSubview:titleScrollView];
    UIImageView *morwImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 40, 0, 40, self.frame.size.height)];
    [morwImageView setImage:[UIImage imageNamed:@"ZH_Information_arrow_right_black"]];
    [self addSubview:morwImageView];
    CGSize headSize;
    if ([array count] <= 4) {
//        headSize =
    }
//    _headView = [[ZHInformationHeadView alloc] initWithFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>) andTitleArray:<#(NSArray *)#>];
    
}

@end
