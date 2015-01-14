//
//  ZHSpecialCellModel.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/8.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHBaseModel.h"

@interface ZHSpecialCellModel : ZHBaseModel

@property (nonatomic, copy) NSString *titleimg;  //图片
@property (nonatomic, copy) NSString *title;  //标题
@property (nonatomic, copy) NSString *pubdate;   //时间
@property (nonatomic, copy) NSString *descripString;//描述
@property (nonatomic, copy) NSString *contentString;//内容
@property (nonatomic, copy) NSString *categoryname; //
@property (nonatomic, copy) NSString *categoryid;   //
@property (nonatomic, copy) NSString *newsid;       //
@property (nonatomic, copy) NSString *contenturl;   //详情连接xml
@property (nonatomic, copy) NSString *contentHtmlUrl;//html
@property (nonatomic, copy) NSString *author;       //来源
@property (nonatomic, copy) NSString *praise;       //点赞
@property (nonatomic, copy) NSString *belittle;     //踩

@end
