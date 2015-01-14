//
//  ZHTitleManage.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/11.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ZHTitleModel.h"

@interface ZHTitleManage : NSManagedObject

@property (nonatomic, copy) NSString *titleName;
@property (nonatomic, copy) NSString *titleId;

@end
