//
//  ZHBaseModel.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/5.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHBaseModel.h"

@implementation ZHBaseModel


NSString * m_return_String(NSString *str)
{
    if(nil == str||[str isEqual:[NSNull null]]){
        return @"--";
    }
    NSString *str1=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if(str1!=nil&&str1.length>0){
        return str;
    }else{
        return @"--";
    }
}

@end
