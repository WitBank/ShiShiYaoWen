//
//  ZHNewsDetailViewController.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/8.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//
//新闻类详情页面的基类

#import "ZHBaseViewController.h"
#import "ZHDetailTitleView.h"
#import "ZHNewsDetialFootView.h"
#import "ZHShareView.h"

@interface ZHNewsDetailViewController : ZHBaseViewController<ZHNewsDetialFootViewDelegate,UIWebViewDelegate>
{
    ZHNewsDetialFootView *_footView;
    ZHShareView *_shareView;
    UIWebView *_webView;
}

@property (nonatomic, strong) ZHNewsDetialFootView *footView;
//@property (nonatomic, strong) UIWebView *webView;

- (void)showDataWithHtmlString:(NSString *)htmlString;

@end
