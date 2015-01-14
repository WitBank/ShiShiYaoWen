//
//  ZHPraiseStepManage.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/15.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ZHPraiseStepModel.h"

typedef enum ZHPraiseStepType
{
    ZHPraiseStepTypeWithNone,       //没有踩和赞
    ZHPraiseStepTypeWithPraise,     //赞了一下
    ZHPraiseStepTypeWithStep,       //踩了一下
}ZHPraiseStepType;

@interface ZHPraiseStepManage : NSManagedObject

@property (nonatomic, copy) NSString *newId;
@property (nonatomic, copy) NSString *isPraise;

@end
