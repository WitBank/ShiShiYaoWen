//
//  ZHInformationViewController.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/8.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHBaseViewController.h"
#import "ZHInformationHeadView.h"
#import "ZHInformationTableViewCell.h"
#import "UIScrollView+PullLoad.h"

typedef enum RequestDataType{
    RequestDataTypeForImage,        //只在下载图片
    RequestDataTypeForNews,         //只在下载新闻
    RequestDataTypeForAllData,      //同时下载图片和新闻
    RequestDataTypeNone,
}RequestDataType;

@interface ZHInformationViewController : ZHBaseViewController<CustomButtonViewDelegate,UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,PullDelegate,UIScrollViewDelegate>
{
    NSMutableArray *_imageArray;
}
@property (nonatomic, strong) NSMutableArray *imageArray;
@property(nonatomic,assign)BOOL reloading;

@end
