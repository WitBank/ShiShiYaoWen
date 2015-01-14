//
//  ZHInitializationData.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/16.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "ZHCoreDataManage.h"

//void (^printBlock)(NSString *x);
@interface ZHInitializationData : NSObject

- (NSArray *)returnCacheTitle;
- (void)RequestTitleData:(void (^)(NSArray *titleArray))success failure:(void (^)(NSError *error))failure;

- (NSArray *)getImageDataWithTitleArray:(NSArray *)titleArray;
- (NSArray *)getNewsDataWithTitleArray:(NSArray *)titleArray;

//- (void)initializationData;

@end
