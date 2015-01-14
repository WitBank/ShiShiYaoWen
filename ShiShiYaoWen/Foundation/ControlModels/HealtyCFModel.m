//
//  HealtyCFModel.m
//  ShiShiYaoWen
//
//  Created by pro on 14/12/14.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "HealtyCFModel.h"

@implementation HealtyCFModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.Sid = value;
    }
}
@end
