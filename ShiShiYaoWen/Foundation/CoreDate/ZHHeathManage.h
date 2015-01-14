//
//  ZHHeathManage.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/16.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "HeathModel.h"

@interface ZHHeathManage : NSManagedObject

@property (nonatomic,copy)NSString *categoryName;
@property (nonatomic,copy)NSString *categoryId;
@property (nonatomic,copy)NSString *newsId;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *descrip;
@property (nonatomic,copy)NSString *contentUrl;
@property (nonatomic,copy)NSString *author;
@property (nonatomic,copy)NSString *praise;
@property (nonatomic,copy)NSString *titleImg;
@property (nonatomic,copy)NSString *pubDate;
@property (nonatomic,copy)NSString *mediaPath;

@end
