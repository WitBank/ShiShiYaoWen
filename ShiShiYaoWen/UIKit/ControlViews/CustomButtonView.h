//
//  CustomButtonView.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/5.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomButtonViewDelegate <NSObject>

- (void)selectTitleButtonTag:(NSInteger)tag;

@end

@interface CustomButtonView : UIView
{
    NSInteger _lastTag;
}

@property (nonatomic, weak) id <CustomButtonViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame andTitleArray:(NSArray *)titleArray;

- (void)titleBtnClicked:(UIButton *)button;

@end
