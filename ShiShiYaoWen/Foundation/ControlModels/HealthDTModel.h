//
//  HealthDTModel.h
//  ShiShiYaoWen
//
//  Created by pro on 14/12/12.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthDTModel : NSObject
//营养百科
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *en_name;
@property (nonatomic,copy)NSString *listorder;
//详情
@property (nonatomic,copy)NSString *introduction;
@property (nonatomic,copy)NSString *effect;
@property (nonatomic,copy)NSString *cz;
//添加剂百科

@property (nonatomic,copy)NSString *adi;
@property (nonatomic,copy)NSString *as;
@property (nonatomic,copy)NSString *func;
@property (nonatomic,copy)NSString *ins;
@property (nonatomic,copy)NSString *note;
@property (nonatomic,copy)NSString *Sid;
@end
