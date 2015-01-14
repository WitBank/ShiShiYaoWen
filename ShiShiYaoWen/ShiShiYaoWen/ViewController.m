//
//  ViewController.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/5.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ZHCoreDataManage.h"
#import "ZHInitializationData.h"
#import <UIImageView+AFNetworking.h>

#define VIEWCONTROLLER @"ViewController"

@interface ViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scollView;
//    UIImageView *_defaultImage;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self loadStartPage];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:VIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:VIEWCONTROLLER];
}

- (void)tap:(id)sender{
//    [((AppDelegate *)([UIApplication sharedApplication].delegate)) initializationData];
    [self initializationData];
}
//跳过
- (void)btnClicked:(UIButton *)btn
{
    //[((AppDelegate *)([UIApplication sharedApplication].delegate)) showMainViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addInfoImage
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    float wx = self.view.frame.size.width;
    float wy = self.view.frame.size.height;
    
    //开始
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((wx-140)*0.5, wy - 100, 140, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"start_button.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _scollView = [[UIScrollView alloc] init];
    _scollView.frame = self.view.frame;
    [self.view addSubview:_scollView];
    for (int i = 0; i< 4; ++i) {
        UIImageView * imgv = [[UIImageView alloc] initWithFrame:CGRectMake(wx*i, 0,wx ,wy)];
        NSString *st = @"Intro_";
        if ([UIScreen mainScreen].bounds.size.height <= 480) {
            st = @"Intro4s_";
        }
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%d",st,i] ofType:@"png"];
        imgv.image = [UIImage imageWithContentsOfFile:path];
        [_scollView addSubview:imgv];
        if (i == 3) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            [imgv addGestureRecognizer:tap];
            imgv.userInteractionEnabled = YES;
        }
    }
    _scollView.delegate = self;
    _scollView.bounces = NO;
    _scollView.showsHorizontalScrollIndicator = NO;
    _scollView.contentSize = CGSizeMake(wx*4, 0);
    _scollView.pagingEnabled = YES;
}

- (void)initializationData
{
//    [self requestStartImage];
    AppDelegate *r_appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ZHInitializationData *initialization = [[ZHInitializationData alloc] init];
    [initialization RequestTitleData:^(NSArray *titleArray) {
        r_appDelegate.informationTitleArray = [NSArray arrayWithArray:titleArray];
        if ([r_appDelegate.informationTitleArray count] <= 0) {
            r_appDelegate.informationTitleArray = [initialization returnCacheTitle];
        }
        if ([r_appDelegate.informationTitleArray count] > 0) {
            [self readLocalData];
        }else{
            //获取数据失败
        }
    } failure:^(NSError *error) {
        r_appDelegate.informationTitleArray = [initialization returnCacheTitle];
        if ([r_appDelegate.informationTitleArray count] > 0) {
            [self readLocalData];
        }
        //网络错误不跳转页面
    }];
}

- (void)readLocalData
{
    AppDelegate *r_appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ZHInitializationData *initialization = [[ZHInitializationData alloc] init];
    //有数据 获取数据去请求页面
    r_appDelegate.informationImageArray = [initialization getImageDataWithTitleArray:r_appDelegate.informationTitleArray];
    r_appDelegate.informationNewsArray = [initialization getNewsDataWithTitleArray:r_appDelegate.informationTitleArray];
    r_appDelegate.specialNewsArray = [NSMutableArray arrayWithArray:[ZHCoreDataManage getAllSpecialCellModel]];
    r_appDelegate.collectionIdArray = [[NSMutableArray alloc] init];
    r_appDelegate.collectionNewsArray = [NSMutableArray arrayWithArray:[ZHCoreDataManage getAllInformationCollectionModelWithNewsIdArray:r_appDelegate.collectionIdArray]];
    r_appDelegate.praiseArray = [NSMutableArray arrayWithArray:[ZHCoreDataManage getAllPraiseStepModel]];
//    [_defaultImage removeFromSuperview];
    [r_appDelegate goHome];
}

- (void)requestStartImage
{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:@"http://ssyw.51yaoshi.com/ssyw/r/cms/ssyw/iosstart/start.xml" parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        GDataXMLDocument *rootDocument = [[GDataXMLDocument alloc] initWithHTMLString:operation.responseString error:nil];
        NSArray *array = [rootDocument nodesForXPath:@"//list" error:nil];
        GDataXMLElement *categroyEle = [array objectAtIndex:0];
        NSString *startString = [[[categroyEle nodesForXPath:@"start" error:nil] lastObject] stringValue];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:startString forKey:@"StartImage"];
        [ud synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//启动页
- (void)loadStartPage{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *start = [ud objectForKey:@"isFirstStart"];
//    NSString *startImage = [ud objectForKey:@"StartImage"];
    if (start == nil||[start isEqualToString:@"YES"]) {
        [self addInfoImage];
    }else{
//        //设置启动图片
//        if (startImage == nil) {
//            _defaultImage=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-568h@3x"]];
//        }else{
//            _defaultImage = [[UIImageView alloc] init];
//            [_defaultImage setImageWithURL:[NSURL URLWithString:startImage]];
//        }
//        _defaultImage.frame=CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
//        [self.view addSubview:_defaultImage];
        
        if ([ZHCustomControl isConnectionAvailable]) {
            [self initializationData];
        }else{
            HJAlertView *alertView = [[HJAlertView alloc] initWithTitle:@"温馨提示" andMessage:@"当前网络不可用，请检查你的网络" andDelegate:self andAddInfo:nil andButtonColor:[UIColor blueColor] andParentView:self andButtonTitles:@"关闭",@"继续",nil];
            [alertView setTag:1001];
            [alertView show];
        }
    }
    [ud setObject:@"NO" forKey:@"isFirstStart"];
    [ud synchronize];
}

- (void)HJalertView:(HJAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex AddInformation:(id)addInfo
{
    if (alertView.tag == 1001 && [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"关闭"]) {
        exit(0);
    }else if (alertView.tag == 1001 && [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"重试"]){
        [self loadStartPage];
    }else if (alertView.tag == 1001 && [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"继续"]){
        [self initializationData];
    }
}

@end
