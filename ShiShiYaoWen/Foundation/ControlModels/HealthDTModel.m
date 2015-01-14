//
//  HealthDTModel.m
//  ShiShiYaoWen
//
//  Created by pro on 14/12/12.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "HealthDTModel.h"

@implementation HealthDTModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.Sid = value;
    }
}
@end
