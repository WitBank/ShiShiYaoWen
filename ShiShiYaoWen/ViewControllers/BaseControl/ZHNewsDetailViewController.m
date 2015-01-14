//
//  ZHNewsDetailViewController.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/8.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHNewsDetailViewController.h"
#import "HJAlertView.h"

@interface ZHNewsDetailViewController ()

@end

@implementation ZHNewsDetailViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    _titleView = [[[NSBundle mainBundle] loadNibNamed:@"ZHDetailTitleView" owner:self options:nil] objectAtIndex:0];
//    [_titleView setFrame:CGRectMake(0, _nNavOffset, SCREENWIDTH, 70)];
//    [self.view addSubview:_titleView];
    _webView =[[UIWebView alloc] initWithFrame:CGRectMake(0.0f,_nNavOffset,SCREENWIDTH,SCREENHEIGHT - _nNavOffset - 39*WIDTHPROPORTION)];
    _webView.delegate=self;
    _webView.scalesPageToFit =NO;
    [self.view addSubview:_webView];
    
    _footView = [[[NSBundle mainBundle] loadNibNamed:@"ZHNewsDetialFootView" owner:self options:nil] lastObject];
    [_footView setFrame:CGRectMake(0, SCREENHEIGHT - 39*WIDTHPROPORTION, SCREENWIDTH, 39*WIDTHPROPORTION)];
    [self.view addSubview:_footView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showDataWithHtmlString:(NSString *)htmlString
{
    NSURL* url = [NSURL URLWithString:htmlString];
    NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
    [_webView loadRequest:request];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIWebViewDelegate
- (BOOL)webView: (UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *requestString = [[[request URL] absoluteString] stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    if ([requestString hasPrefix:@"ios-log:"]) {
//        NSString* logString = [[requestString componentsSeparatedByString:@":#iOS#"] objectAtIndex:1];
//        NSLog(@"UIWebView console: %@", logString);
        return NO;
    }
    return YES;
}

//加载完成的时候执行该方法。
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *fontSize = [ud objectForKey:@"fontSize"];
    NSString *string = nil;
    if ([fontSize isEqualToString:@"-3"]) {
        string = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '80%'";
    }else if([fontSize isEqualToString:@"3"]){
        string = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '130%'";
    }else{
        string = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'";
    }
    [_webView stringByEvaluatingJavaScriptFromString:string];
}

//开始加载的时候执行该方法。
- (void)webViewDidStartLoad:(UIWebView *)webView
{
}
//加载出错的时候执行该方法。
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

@end
