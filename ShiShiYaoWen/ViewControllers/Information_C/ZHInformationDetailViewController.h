//
//  ZHInformationDetailViewController.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/8.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHNewsDetailViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "ZHInformationSCVImageModel.h"

@interface ZHInformationDetailViewController : ZHNewsDetailViewController<NSXMLParserDelegate,ISSShareViewDelegate>
{
    ZHInformationCellModel *_dataModel;
    UILabel *_titleLabel;
}

- (instancetype)initWithModel:(ZHInformationCellModel *)model;

- (instancetype)initWithImageModel:(ZHInformationSCVImageModel *)model;

@end
