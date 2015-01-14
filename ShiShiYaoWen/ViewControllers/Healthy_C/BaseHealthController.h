//
//  BaseHealthController.h
//  zixun
//
//  Created by pro on 14/12/5.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import <UIKit/UIKit.h>
//rgb颜色转化   UIColorFromRGB(0x34465C);
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define winSize [UIScreen mainScreen].bounds.size

//添加剂url
#define TJJURL @"http://bjapp.foodvip.net/json.php?app=additives&page=%d"
#define TJJDTURL @"http://bjapp.foodvip.net/json.php?app=additives&ac=show&id=%@"
//营养成分百科
#define YYBKURL @"http://bjapp.foodvip.net/json.php?app=ele&all=1"
#define YYBKDTURL @"http://bjapp.foodvip.net/json.php?app=ele&s=%@"

//配料搜索
#define PLURL @"http://bjapp.foodvip.net/json.php?app=jp&s=%@"
#define PLDTURL @"http://bjapp.foodvip.net/json.php?app=jp&id=%@"
//营养成分搜索
#define CFURL @"http://bjapp.foodvip.net/json.php?app=yyss&ac=search&s=%@"
#define CFDTURL @"http://bjapp.foodvip.net/json.php?app=yyss&ac=show&id=%@"

#import "ZHBaseViewController.h"


@interface BaseHealthController : ZHBaseViewController
- (UIFont *)getBoldFontWithSize:(float)size;
- (UIFont *)getSysFontWithSize:(float)size;
- (CGSize)getTextSize:(UILabel *)lb;
- (void)setBack;
- (NSString *)convertString:(NSString *)string;
@end
