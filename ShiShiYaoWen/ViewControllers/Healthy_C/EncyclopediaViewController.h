//
//  EncyclopediaViewController.h
//  ShiShiYaoWen
//
//  Created by pro on 14/12/12.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "BaseHealthController.h"

@interface EncyclopediaViewController : BaseHealthController
@property (nonatomic,copy)NSString *url;
@property (nonatomic,assign)int type;      //添加剂百科0 营养成分百科3
@end
