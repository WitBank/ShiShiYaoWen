//
//  ZHSpecialDetailViewController.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/8.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHNewsDetailViewController.h"
#import "ZHCoreDataManage.h"
#import <ShareSDK/ShareSDK.h>

@interface ZHSpecialDetailViewController : ZHNewsDetailViewController<ISSShareViewDelegate>
{
    ZHInformationCellModel *_dataModel;
    UILabel *_titleLabel;
}

- (instancetype)initWithModel:(ZHInformationCellModel *)model;

@end
