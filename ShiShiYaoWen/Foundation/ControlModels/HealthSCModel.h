//
//  HealthSCModel.h
//  ShiShiYaoWen
//
//  Created by pro on 14/12/13.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HealthSCModel : NSObject
@property (nonatomic,copy) NSString*bzq;
@property (nonatomic,copy) NSString*chandi;
@property (nonatomic,copy) NSString*cjtime;
@property (nonatomic,copy) NSString*itemid;
@property (nonatomic,copy) NSString*jinghl;
@property (nonatomic,copy) NSString*peiliao;
@property (nonatomic,copy) NSString*title;

//详情新增
@property (nonatomic,copy) NSString*cn_comname;
@property (nonatomic,copy) NSString*cn_ppname;
@property (nonatomic,copy) NSString*company;
@property (nonatomic,copy) NSString*proimg;
@property (nonatomic,copy) NSString*sctime;
@property (nonatomic,copy) NSString*chengfen;
@property (nonatomic,retain)NSArray *additives;
@end
