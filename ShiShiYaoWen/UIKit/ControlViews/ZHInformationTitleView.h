//
//  ZHInformationTitleView.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/10.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHInformationHeadView.h"

@interface ZHInformationTitleView : UIView

@property (nonatomic, strong) ZHInformationHeadView *headView;

- (instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)array;

@end
