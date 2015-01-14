//
//  ZHInformationDetailModel.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/9.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHBaseModel.h"

@interface ZHNewsDetailModel : ZHBaseModel

@property (nonatomic, copy) NSString *newsType;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *scource;
@property (nonatomic, copy) NSString *timeString;
@property (nonatomic, copy) NSString *newsUrl;
@property (nonatomic, copy) NSString *contentString;

@end
