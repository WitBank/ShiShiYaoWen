//
//  AppDelegate.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/5.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHHomeViewController.h"
#import "NotificationDefine.h"
#import "HJAlertView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,HJAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) ZHHomeViewController *homeTabBarControl;
@property (nonatomic, strong) NSArray *informationTitleArray;
@property (nonatomic, strong) NSArray *informationImageArray;
@property (nonatomic, strong) NSArray *informationNewsArray;
@property (nonatomic, strong) NSArray *specialNewsArray;
@property (nonatomic, strong) NSMutableArray *collectionNewsArray;
@property (nonatomic, strong) NSMutableArray *collectionIdArray;
@property (nonatomic, strong) NSMutableArray *praiseArray;
@property (nonatomic, assign) float fontSize;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
//@property (nonatomic, strong) dispatch_queue_t serialQueue;

- (void)goHome;

- (dispatch_queue_t)sharedQueue;

@end

