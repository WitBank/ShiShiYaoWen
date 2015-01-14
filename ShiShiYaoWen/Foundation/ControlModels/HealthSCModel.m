//
//  HealthSCModel.m
//  ShiShiYaoWen
//
//  Created by pro on 14/12/13.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "HealthSCModel.h"

@implementation HealthSCModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@", _bzq,_chandi,_cjtime,_itemid,_jinghl,_peiliao,_title];
}
@end
