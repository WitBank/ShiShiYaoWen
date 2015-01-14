//
//  QuestionViewController.h
//  ShiShiYaoWen
//
//  Created by Mac on 14/12/19.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHBaseViewController.h"

@interface QuestionViewController : ZHBaseViewController<UIWebViewDelegate>
{
    UIWebView *_webView;
    UIActivityIndicatorView *_activityView;

}

@end
