//
//  AppDelegate.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/5.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/WeiBoAPI.h>
#import "WeiboSDK.h"
#import "WeiboApi.h"
#import "WXApi.h"
#import <RennSDK/RennSDK.h>
#import "YXApi.h"
#import "ZHInitializationData.h"
#import "ViewController.h"



@interface AppDelegate ()


@end
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //设置主窗口
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(readFontSize) name:REFRESHFONTSIZE object:nil];
    [self readFontSize];
    [self addShareSDK];
    [self addMTASDK];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)goHome
{
//    [image removeFromSuperview];
    _homeTabBarControl = [[ZHHomeViewController alloc] init];
    [self.window setRootViewController:_homeTabBarControl];
}

- (void)addMTASDK
{
    [MTA startWithAppkey:@"IGX6GB99T2LJ"];
}

+(BOOL)startWithAppkey:(NSString*) appkey checkedSdkVersion:(NSString*)ver
{
    return YES;
}

- (void)addShareSDK
{
    [ShareSDK registerApp:SHARESDKAPPID];
//    //添加新浪微博应用 注册网址 http://open.weibo.com
//    [ShareSDK connectSinaWeiboWithAppKey:@"2399814728"
//                               appSecret:@"777ad8f58b6ef0dd1d952abdfe598eb4"
//                             redirectUri:@"http://www.sharesdk.cn"];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
//    [ShareSDK  connectSinaWeiboWithAppKey:@"2399814728"
//                                appSecret:@"777ad8f58b6ef0dd1d952abdfe598eb4"
//                              redirectUri:@"http://www.sharesdk.cn"
//                              weiboSDKCls:[WeiboSDK class]];
//    
//    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
//    [ShareSDK connectTencentWeiboWithAppKey:@"1103654801"
//                                  appSecret:@"l4xNS0UWfSNqIuxW"
//                                redirectUri:@"http://www.sharesdk.cn"
//                                   wbApiCls:[WeiboApi class]];
//    
//    //添加QQ应用  注册网址  http://open.qq.com/
//    [ShareSDK connectQQWithQZoneAppKey:@"1103654801"
//                     qqApiInterfaceCls:[QQApiInterface class]
//                       tencentOAuthCls:[TencentOAuth class]];
//    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"1103654801"
                           appSecret:@"l4xNS0UWfSNqIuxW"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
//
////    //添加微信应用 注册网址 http://open.weixin.qq.com
////    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
////                           wechatCls:[WXApi class]];
//    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"   //微信APPID
//                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"  //微信APPSecret
//                           wechatCls:[WXApi class]];
//    
//    
//    //添加人人网应用 注册网址  http://dev.renren.com
//    [ShareSDK connectRenRenWithAppId:@"226427"
//                              appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
//                           appSecret:@"f29df781abdd4f49beca5a2194676ca4"
//                   renrenClientClass:[RennClient class]];
//    
//    
//    
//    /**
//     连接易信应用以使用相关功能，此应用需要引用YiXinConnection.framework
//     http://open.yixin.im/上注册易信开放平台应用，并将相关信息填写到以下字段
//     **/
//    [ShareSDK connectYiXinWithAppId:@"yx0d9a9f9088ea44d78680f3274da1765f"
//                           yixinCls:[YXApi class]];
    
    //连接邮件
    [ShareSDK connectMail];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESHFONTSIZE object:nil];
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)readFontSize{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *fontSize = [ud objectForKey:@"fontSize"];
    if (fontSize==nil) {
        self.fontSize = 0;
    }else{
        self.fontSize = [fontSize floatValue];
    }
}

- (dispatch_queue_t)sharedQueue
{
    static dispatch_queue_t serialQueue = nil;
    static dispatch_once_t predicate; dispatch_once(&predicate, ^{
        serialQueue = dispatch_queue_create("com.example.gcd.MyConcurrentDispatchQueue", DISPATCH_QUEUE_CONCURRENT);
    });
    return serialQueue;
}

- (NSOperationQueue *)operationQueue
{
    if (_operationQueue == nil) {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    return _operationQueue;
}

@end
