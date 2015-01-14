//
//  ZHPolularViewController.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/8.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHBaseViewController.h"
#import "BaseHealthController.h"
#import "HJAlertView.h"

@interface ZHPolularViewController : BaseHealthController<HJAlertViewDelegate>
@property (nonatomic,copy)NSString *channelId;
+ (void)deleteCache;
@end
