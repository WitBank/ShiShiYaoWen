//
//  ZHSpecialDetailViewController.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/8.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHSpecialDetailViewController.h"
#import "AppDelegate.h"

#define ZHSPECIALDETAILVIEWCONTROLLER @"ZHSpecialDetailViewController"

@interface ZHSpecialDetailViewController ()

@end

@implementation ZHSpecialDetailViewController
{
    ZHPraiseStepType _newsPraiseType;
}

- (instancetype)initWithModel:(ZHInformationCellModel *)model
{
//    _newsPraiseType = [ZHCoreDataManage getNewsTypeWithNewsId:model.newsid];
    _dataModel = model;
    self = [super init];
    if (self) {
//        if (_newsPraiseType == ZHPraiseStepTypeWithPraise) {
//            [_footView setPraiseButtonSelected];
//        }else if (_newsPraiseType == ZHPraiseStepTypeWithStep){
//            [_footView setSetpButtonSelected];
//        }
        AppDelegate *r_appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        for (NSString *newsId in r_appDelegate.collectionIdArray) {
            if ([newsId isEqualToString:model.newsid]) {
                [_footView setCollectButtonSelected:YES];
                break;
            }
        }
        for (ZHPraiseStepModel *PS_model in [r_appDelegate praiseArray]) {
            if ([PS_model.newsId isEqualToString:model.newsid]) {
                if ([PS_model.isPraise isEqualToString:@"1"]) {
                    [_footView setPraiseButtonSelected];
                }else{
                    [_footView setSetpButtonSelected];
                }
            }
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [_titleLabel setText:_dataModel.categoryname];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [self.navigationItem setTitleView:_titleLabel];
    
    [_footView setDelegate:self];
    
    UIButton *backButton = [ZHCustomControl _customUIButtonWithTitle:nil
                                                             andFont:1.0f
                                                       andTitleColor:nil
                                                           andTarget:self
                                                              andSEL:@selector(backClick)
                                                     andControlEvent:UIControlEventTouchUpInside
                                                          andBGImage:[UIImage imageNamed:@"ZH_NavigationBack@3x"]
                                                            andFrame:CGRectMake(0, 0, 28, 30)];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonItem;
    [self showDataWithHtmlString:_dataModel.contentHtmlUrl];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:ZHSPECIALDETAILVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:ZHSPECIALDETAILVIEWCONTROLLER];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)selectFootButtonWithType:(ZHFootSelectType)selectType andButton:(UIButton *)sender
{
    AppDelegate *r_appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    switch (selectType) {
        case ZHFootSelectTypeCollect:
            if (_footView.collectSelect == YES) {
                [r_appDelegate.collectionNewsArray addObject:_dataModel];
                [r_appDelegate.collectionIdArray addObject:_dataModel.newsid];
                [ZHCoreDataManage saveInforMationCollectionWithModel:_dataModel];
            }else{
                for (int i = 0; i < [r_appDelegate.collectionIdArray count]; i++) {
                    if ([[r_appDelegate.collectionIdArray objectAtIndex:i] isEqualToString:_dataModel.newsid]) {
                        [r_appDelegate.collectionIdArray removeObjectAtIndex:i];
                        [r_appDelegate.collectionNewsArray removeObjectAtIndex:i];
                        break;
                    }
                }
                [ZHCoreDataManage removeinformationCollectionModelWithNewsId:_dataModel.newsid];
            }
            break;
        case ZHFootSelectTypePraise:
        {
            ZHPraiseStepModel *model = [[ZHPraiseStepModel alloc] init];
            model.newsId = _dataModel.newsid;
            model.isPraise = @"1";
            [r_appDelegate.praiseArray addObject:model];
            [ZHCoreDataManage savePraiseStepWithNewsId:_dataModel.newsid andPraise:YES];
            [self praiseOrBelittle:YES];
            break;
        }
        case ZHFootSelectTypeStep:
        {
            ZHPraiseStepModel *model = [[ZHPraiseStepModel alloc] init];
            model.newsId = _dataModel.newsid;
            model.isPraise = @"0";
            [r_appDelegate.praiseArray addObject:model];
            [ZHCoreDataManage savePraiseStepWithNewsId:_dataModel.newsid andPraise:NO];
            [self praiseOrBelittle:NO];
            break;
        }
        case ZHFootSelectTypeShare:
        {
            NSString *img = _dataModel.titleimg;
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:_dataModel.descripString
                                               defaultContent:@""
                                                        image:[ShareSDK imageWithPath:img]
                                                        title:_dataModel.title
                                                          url:_dataModel.contentHtmlUrl
                                                  description:_dataModel.descripString
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            //创建弹出菜单容器
            id<ISSContainer> container = [ShareSDK container];
            [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
            
            //自定义标题栏相关委托
            id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                 allowCallback:NO
                                                                 authViewStyle:SSAuthViewStyleFullScreenPopup
                                                                  viewDelegate:nil
                                                       authManagerViewDelegate:nil];
            //自定义标题栏相关委托
            id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:_dataModel.title
                                                                      oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                       qqButtonHidden:YES
                                                                wxSessionButtonHidden:YES
                                                               wxTimelineButtonHidden:YES
                                                                 showKeyboardOnAppear:NO
                                                                    shareViewDelegate:self
                                                                  friendsViewDelegate:nil
                                                                picViewerViewDelegate:nil];
            
            //弹出分享菜单
            [ShareSDK showShareActionSheet:container
                                 shareList:nil
                                   content:publishContent
                             statusBarTips:YES
                               authOptions:authOptions
                              shareOptions:shareOptions
                                    result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                        
                                        if (state == SSResponseStateSuccess)
                                        {
//                                            NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                            
                                        }
                                        else if (state == SSResponseStateFail)
                                        {
                                            NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                        }
                                    }];
        }
            break;
        default:
            break;
    }
}

- (void)praiseOrBelittle:(BOOL)isPraise
{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *PBString = nil;
    if (isPraise == YES) {
        PBString = @"clickPraise";
    }else{
        PBString = @"clickBelittle";
    }
    NSString *path = [NSString stringWithFormat:@"%@/ssyw/%@.jspx?newsId=%@",SSYWHTTPHEAD,PBString,_dataModel.newsid];
    [manager GET:path parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//#pragma mark - ZHShareViewDelegate
//- (void)shareSelectButtonWithType:(ZHShareViewSelectType)type
//{
//    switch (type) {
//        case ZHShareViewSelectTypeWithTXWeibo:
//            break;
//        case ZHShareViewSelectTypeWithEmail:
//
//            break;
//        case ZHShareViewSelectTypeWithSinaWeibo:
//
//            break;
//        case ZHShareViewSelectTypeWithTxQQ:
//
//            break;
//        case ZHShareViewSelectTypeWithTxQQZone:
//
//            break;
//        case ZHShareViewSelectTypeWithCancel:
//            [_shareView removeFromSuperview];
//            _shareView = nil;
//            break;
//        default:
//            break;
//    }
//}

#pragma mark - ISSShareViewDelegate
- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType

{
    
    //修改分享编辑框的标题栏颜色
    viewController.navigationController.navigationBar.barTintColor = [UIColor orangeColor];
    
    //将分享编辑框的标题栏替换为图片
    //    UIImage *image = [UIImage imageNamed:@"iPhoneNavigationBarBG.png"];
    //    [viewController.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
}

@end
