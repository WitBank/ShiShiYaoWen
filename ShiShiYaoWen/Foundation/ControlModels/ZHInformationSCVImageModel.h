//
//  ZHInformationModel.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/11.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHInformationSCVImageModel : NSObject

@property (nonatomic, copy) NSString *categoryName; //新闻类型
@property (nonatomic, copy) NSString *categoryId;   //新闻类型ID
@property (nonatomic, copy) NSString *newsId;       //新闻id
@property (nonatomic, copy) NSString *title;        //新闻标题
@property (nonatomic, copy) NSString *descrip;      //新闻说明
@property (nonatomic, copy) NSString *contentUrl;   //链接地址url
@property (nonatomic, copy) NSString *contentHtmlUrl;//html链接
@property (nonatomic, copy) NSString *Author;       //来源
@property (nonatomic, copy) NSString *praise;       //点赞数
@property (nonatomic, copy) NSString *titleImg;     //图片
@property (nonatomic, copy) NSString *pubDate;      //时间
@property (nonatomic, copy) NSString *belittle;     //

@end
