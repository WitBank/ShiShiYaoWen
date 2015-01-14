//
//  HeathModel.m
//  zixun
//
//  Created by pro on 14/12/5.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "HeathModel.h"

@implementation HeathModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"description"]) {
        self.descrip = value;
    }
}
@end
