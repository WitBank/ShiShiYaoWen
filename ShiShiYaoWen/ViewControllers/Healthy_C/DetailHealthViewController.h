//
//  DetailHealthViewController.h
//  zixun
//
//  Created by pro on 14/12/5.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "BaseHealthController.h"

@interface DetailHealthViewController : BaseHealthController
@property (nonatomic,copy)NSString *channelId;
@property (nonatomic,assign) int type; //1 ,2 食物营养成分查询,产品成分配料查询
@end
