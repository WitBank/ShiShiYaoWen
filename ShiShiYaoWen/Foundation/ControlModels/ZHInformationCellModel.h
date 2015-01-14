//
//  ZHInformationCellModel.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/5.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHBaseModel.h"

@interface ZHInformationCellModel : ZHBaseModel

@property (nonatomic, strong) NSString *titleimg;  //图片
@property (nonatomic, strong) NSString *title;  //标题
@property (nonatomic, strong) NSString *pubdate;   //时间
@property (nonatomic, strong) NSString *descripString;//描述
@property (nonatomic, strong) NSString *contentString;//内容
@property (nonatomic, strong) NSString *categoryname; //
@property (nonatomic, strong) NSString *categoryid;   //
@property (nonatomic, strong) NSString *newsid;       //
@property (nonatomic, strong) NSString *contenturl;   //详情连接xml
@property (nonatomic, strong) NSString *contentHtmlUrl;//html
@property (nonatomic, strong) NSString *author;       //来源
@property (nonatomic, strong) NSString *praise;       //点赞
@property (nonatomic, strong) NSString *belittle;     //踩

@end
