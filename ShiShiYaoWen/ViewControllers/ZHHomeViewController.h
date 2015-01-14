//
//  ZHHomeViewController.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/8.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHBaseViewController.h"

@interface ZHHomeViewController : UITabBarController
{
    UITabBarController *_tabbarControl;
    NSMutableArray *_titleNameArray;
    NSMutableArray *_normalImageArray;
    NSMutableArray *_selectImageArray;
    UIView *_tabbarView;
}

- (void)setTabBarHidden:(BOOL)isHidden;

@end
