//
//  ZHSettingsViewController.h
//  ShiShiYaoWen
//
//  Created by Mac on 14/12/10.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

/* 
 常见问题地址：http://ssyw.51yaoshi.com/ssyw/cjwt/index.htm
 */
#import "ZHBaseViewController.h"
#import "HJAlertView.h"

@interface ZHSettingsViewController : ZHBaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,HJAlertViewDelegate>
{
    UITableView *_tableView;   //TableView
    UIButton *button;          //切换字体大小
    
    float _cacheSize;          //计算缓存
    UILabel *_cacheLabel;
    NSArray *fontSizes;        //存放字号
    
}

@property (nonatomic, strong) UITableView *tableView;

@end
