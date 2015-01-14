//
//  ZHInformationViewController.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/8.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHInformationViewController.h"
#import "ZHInformationDetailViewController.h"
#import "ZHCoreDataManage.h"
#import <UIImageView+AFNetworking.h>
#import "ZHSettingsViewController.h"
#import "AppDelegate.h"
#import "HJProgressHUD.h"
#import "HJAlertView.h"
#import "ZHInformationHeadImageCell.h"

#define ZHINFORMATIONVIEWCONTROLLER @"ZHInformationViewController"

@interface ZHInformationViewController ()

@end

@implementation ZHInformationViewController
{
    __strong NSMutableArray *_newsArray;
    UITableView *_tableView;
    UIScrollView *_imageScrollView;
    UILabel *_imageTitleLabel;
    int _pageNumber;                        //当前加载的新闻页
    NSString *_categoryId;                  //当前加载的titleID
    NSInteger count;
    NSMutableArray *_xmlDataArray;
    NSString *_keyName;
    NSInteger _index;
    __strong NSMutableArray *_titleArray;
    UIButton *_titleButton;
    BOOL _isTitleButtonLeft;
    UIImageView *_imageView;
    UIScrollView *_titleScrollView;
    ZHInformationHeadView *_titleHeadView;
    BOOL _isUp;
    NSTimer *_imageTimer;
    int _timeCount;
    AppDelegate *_appDelegate;
    NSMutableArray *_newsDataArray;         //二维数组
    int _titleIndex;                        //记录当前title的index
    int _currentPage;
    HJProgressHUD *_HUD;
    BOOL _isShowHUD;
    RequestDataType _requestType;
    CGFloat _fontSize;
    ZHInformationImageHeadView *_imageHeadView;
    NSIndexPath *_indexPath;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:REFRESHFONTSIZE object:nil];
}

- (void)refreshSize{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *fontSize = [userDefaults objectForKey:@"fontSize"];
    if (fontSize == nil) {
        _fontSize = 0;
    }else{
        _fontSize = [fontSize intValue];
    }
    [_imageTitleLabel setFont:[UIFont systemFontOfSize:14.0f+_fontSize]];
    [_tableView reloadData];
    [self PullDownLoadEnd];
    [self PullUpLoadEnd];
}

- (id)init
{
    _titleArray = [[NSMutableArray alloc] init];
    _imageArray = [[NSMutableArray alloc] init];
    _newsArray = [[NSMutableArray alloc] init];
    _newsDataArray = [[NSMutableArray alloc] init];
    self = [super init];
    if (self) {
        [self.view setBackgroundColor:HJCOLORBACK];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSize) name:REFRESHFONTSIZE object:nil];
    
    _appDelegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    _titleArray = [NSMutableArray arrayWithArray:_appDelegate.informationTitleArray];
    ZHTitleModel *model = [_titleArray objectAtIndex:0];
    _categoryId = model.titleId;
    _newsDataArray = [NSMutableArray arrayWithArray:_appDelegate.informationNewsArray];
    _imageArray = [NSMutableArray arrayWithArray:_appDelegate.informationImageArray];
    _newsArray = [NSMutableArray arrayWithArray:[_newsDataArray objectAtIndex:0]];
    _pageNumber = (int)[_newsArray count]/10;
    //初始化一个转圈加提示的tost
    _HUD = [[HJProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    _requestType = RequestDataTypeNone;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *fontSize = [userDefaults objectForKey:@"fontSize"];
    if (fontSize == nil) {
        _fontSize = 0;
    }else{
        _fontSize = [fontSize intValue];
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [titleLabel setText:@"资讯精选"];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [self.navigationItem setTitleView:titleLabel];
    
    UIButton *setButton = [ZHCustomControl _customUIButtonWithTitle:nil
                                                            andFont:1.0f
                                                      andTitleColor:nil
                                                          andTarget:self
                                                             andSEL:@selector(userSetClick)
                                                    andControlEvent:UIControlEventTouchUpInside
                                                         andBGImage:[UIImage imageNamed:@"ZH_Navigation_Set_white@3x"]
                                                           andFrame:CGRectMake(0, 0, 24, 23)];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:setButton];
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    _titleButton = [ZHCustomControl _customUIButtonWithTitle:nil
                                                     andFont:1
                                               andTitleColor:[UIColor clearColor]
                                                   andTarget:self
                                                      andSEL:@selector(rollTitleScroll)
                                             andControlEvent:UIControlEventTouchUpInside
                                                  andBGImage:nil
                                                    andFrame:CGRectMake(290*WIDTHPROPORTION,
                                                                        64*WIDTHPROPORTION,
                                                                        30*WIDTHPROPORTION,
                                                                        40*WIDTHPROPORTION)];
    [self.view addSubview:_titleButton];
    
    CGFloat buttonWidth;
    if ([_titleArray count]>4) {
        buttonWidth = 70.0f;
    }else{
        buttonWidth = 280.0f/[_titleArray count];
        [_titleButton setEnabled:NO];
    }
    _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64*WIDTHPROPORTION, 280*WIDTHPROPORTION, 40*WIDTHPROPORTION)];
    [_titleScrollView setBounces:NO];
    [_titleScrollView setShowsHorizontalScrollIndicator:NO];
    [_titleScrollView setShowsVerticalScrollIndicator:NO];
    
    _titleHeadView = [[ZHInformationHeadView alloc] initWithFrame:CGRectMake(0, 0, buttonWidth*[_titleArray count], 40*WIDTHPROPORTION) andTitleArray:_titleArray];
    [_titleHeadView setDelegate:self];
    [_titleScrollView addSubview:_titleHeadView];
    [_titleScrollView setContentSize:CGSizeMake(buttonWidth*[_titleArray count],0)];
    [self.view addSubview:_titleScrollView];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(300*WIDTHPROPORTION, (_nNavOffset+(40-15)/2)*WIDTHPROPORTION, 9*WIDTHPROPORTION, 15*WIDTHPROPORTION)];
    [_imageView setBackgroundColor:[UIColor clearColor]];
    [_imageView setImage:[UIImage imageNamed:@"ZH_Information_arrow_right_black@3x"]];
    [self.view addSubview:_imageView];
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 105*WIDTHPROPORTION, SCREENWIDTH, SCREENHEIGHT - (105 + 49)*WIDTHPROPORTION) style:UITableViewStylePlain];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setPullDelegate:self];
    [_tableView setCanPullUp:YES];
    [_tableView setCanPullDown:YES];
    [self.view addSubview:_tableView];
    
    if ([_imageArray count] > 0) {
//        [self showImageScrollView];
    }else{
        [self requestImageData];
    }
    if ([_newsArray count] <= 0) {
        [self requestNewsData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [_appDelegate.homeTabBarControl setTabBarHidden:NO];
    [super viewWillAppear:animated];
    [MTA trackPageViewBegin:ZHINFORMATIONVIEWCONTROLLER];
    [_imageHeadView stopAutoPlayWithBOOL:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
     [MTA trackPageViewEnd:ZHINFORMATIONVIEWCONTROLLER];
    [_imageHeadView stopAutoPlayWithBOOL:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - CustomButtonViewDelegate
- (void)selectTitleButtonTag:(NSInteger)tag
{
    [_tableView scrollToRowAtIndexPath:_indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    _titleIndex = (int)tag;
    
    [self PullDownLoadEnd];
    [self PullUpLoadEnd];
    [_xmlDataArray removeAllObjects];
//    NSIndexPath *indes = [NSIndexPath indexPathForRow:0 inSection:0];
//    [_tableView scrollToRowAtIndexPath:indes atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    
    ZHTitleModel *model = [_titleArray objectAtIndex:tag];
    _categoryId = model.titleId;
    _newsArray = [NSMutableArray arrayWithArray:[_newsDataArray objectAtIndex:tag]];
    _pageNumber = (int)[_newsArray count]/10;
    if ([_newsArray count] <= 0) {
        [self requestNewsData];
    }else
    {
        [_tableView reloadData];
        [self PullDownLoadEnd];
        [self PullUpLoadEnd];
    }
    
}

#pragma mark - UserSetButtonClicked
- (void)userSetClick
{
    ZHSettingsViewController *settingsVC = [[ZHSettingsViewController alloc]init];
    [self.navigationController pushViewController:settingsVC animated:YES];
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.homeTabBarControl setTabBarHidden:YES];
}

- (void)rollTitleScroll
{
    CGPoint lastPoint = _titleScrollView.contentOffset;
    if (_isTitleButtonLeft == NO) {
        CGFloat conten = _titleHeadView.frame.size.width - (_titleScrollView.contentOffset.x + _titleScrollView.frame.size.width);
        if (conten > _titleScrollView.frame.size.width) {
            conten = _titleScrollView.frame.size.width;
        }else{
            _isTitleButtonLeft = YES;
        }
        [UIView animateWithDuration:0.5 animations:^{
            _titleScrollView.contentOffset = lastPoint;
        }completion:^(BOOL finished) {
            if (finished) {
                [_titleScrollView setContentOffset:CGPointMake(lastPoint.x+conten, lastPoint.y) animated:YES];
            }
        }];
    }else{
        CGFloat conten = (_titleScrollView.contentOffset.x + _titleScrollView.frame.size.width) - _titleScrollView.frame.size.width;
        if (conten > _titleScrollView.frame.size.width) {
            conten = _titleScrollView.frame.size.width;
        }else{
            _isTitleButtonLeft = NO;
        }
        [UIView animateWithDuration:0.5 animations:^{
            _titleScrollView.contentOffset = lastPoint;
        }completion:^(BOOL finished) {
            if (finished) {
                [_titleScrollView setContentOffset:CGPointMake(lastPoint.x-conten, lastPoint.y) animated:YES];
            }
        }];
    }
    if (_isTitleButtonLeft == YES) {
        [_imageView setImage:[UIImage imageWithCGImage:[UIImage imageNamed:@"ZH_Information_arrow_right_black@3x"].CGImage scale:0 orientation:UIImageOrientationDown]];
    }else{
        [_imageView setImage:[UIImage imageNamed:@"ZH_Information_arrow_right_black@3x"]];
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_newsArray == nil && _imageArray == nil) {
        return 0;
    }
    return [_newsArray count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        _indexPath = indexPath;
        ZHInformationHeadImageCell *imageCell = [[ZHInformationHeadImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil andModelArray:_imageArray];
        _imageHeadView = imageCell.imageHeadView;
        [self imageHeadBlock];
        return imageCell;
    }
    static NSString *cellName = @"InformationCell";
    ZHInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZHInformationTableViewCell" owner:self options:nil] lastObject];
    }
    ZHInformationCellModel *model = [_newsArray objectAtIndex:indexPath.row - 1];
    [cell showDataWithModel:model andFont:_fontSize];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 140*WIDTHPROPORTION;
    }
    if (_newsArray == nil) {
        return 44*WIDTHPROPORTION;
    }
    return 90*WIDTHPROPORTION;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    if (indexPath.row == 0) {
        return;
    }
    ZHInformationCellModel *cellModel = [_newsArray objectAtIndex:indexPath.row-1];
    ZHInformationDetailViewController *detailViewController = [[ZHInformationDetailViewController alloc] initWithModel:cellModel];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.homeTabBarControl setTabBarHidden:YES];
}

- (void)imageHeadBlock
{
    __block ZHInformationViewController *mSelf = self;
    [_imageHeadView setCallBlock:^(NSInteger index) {
        //image点击后触发的方法
        if (index < [mSelf.imageArray count]) {
            ZHInformationSCVImageModel *model = [mSelf.imageArray objectAtIndex:index];
            ZHInformationDetailViewController *detailViewControl = [[ZHInformationDetailViewController alloc] initWithImageModel:model];
            [mSelf.navigationController pushViewController:detailViewControl animated:YES];
        }
    }];
}

#pragma mark - requestData
- (void)setTitleArray:(NSArray *)array
{
    _titleArray = [NSMutableArray arrayWithArray:array];
    ZHTitleModel *model = [_titleArray objectAtIndex:0];
    _categoryId = model.titleId;
    [self requestNewsData];
}

//请求标题对应滑动图片新闻数据
- (void)requestImageData
{
    if (_requestType == RequestDataTypeNone) {
        _requestType = RequestDataTypeForImage;
    }else if(_requestType == RequestDataTypeForNews){
        _requestType = RequestDataTypeForAllData;
    }
    if (_isShowHUD == NO) {
        [self startAmination:@"加载数据中"];
    }
    NSString *xmlPath = [NSString stringWithFormat:@"%@/ssyw/getContent.jspx?channelId=76",SSYWHTTPHEAD];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:xmlPath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [[_appDelegate operationQueue] addOperation:op];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:operation.responseData error:nil];
            GDataXMLElement *root = [doc rootElement];
            NSArray *itemArray = [root nodesForXPath:@"item" error:nil];
            NSMutableArray *iamgeArray = [[NSMutableArray alloc] init];
            
            for (GDataXMLElement *ele in itemArray) {
                ZHInformationSCVImageModel *model = [[ZHInformationSCVImageModel alloc] init];
                model.categoryName = [[[ele nodesForXPath:@"categoryName" error:nil] lastObject] stringValue];
                model.categoryId = [[[ele nodesForXPath:@"categoryId" error:nil] lastObject] stringValue];
                model.newsId = [[[ele nodesForXPath:@"newsId" error:nil] lastObject] stringValue];
                model.title = [[[ele nodesForXPath:@"title" error:nil] lastObject] stringValue];
                model.descrip = [[[ele nodesForXPath:@"description" error:nil] lastObject] stringValue];
                model.contentUrl = [NSString stringWithFormat:@"%@:88/ssyw/newscontent/%@",SSYWHTTPHEAD,[[[ele nodesForXPath:@"contentUrl" error:nil] lastObject] stringValue]];
                model.contentHtmlUrl = [NSString stringWithFormat:@"%@/ssyw%@",SSYWHTTPHEAD,[[[ele nodesForXPath:@"contentHtmlUrl" error:nil] lastObject] stringValue]];
                model.Author = [[[ele nodesForXPath:@"Author" error:nil] lastObject] stringValue];
                model.praise = [[[ele nodesForXPath:@"praise" error:nil] lastObject] stringValue];
                model.titleImg = [NSString stringWithFormat:@"%@%@",SSYWHTTPHEAD,[[[ele nodesForXPath:@"titleImg" error:nil] lastObject] stringValue]];
                model.pubDate = [[[ele nodesForXPath:@"pubDate" error:nil] lastObject] stringValue];
                [iamgeArray addObject:model];
            }
            dispatch_async([_appDelegate sharedQueue], ^{
            if ([iamgeArray count] > 0) {
                if ([_imageArray count] > 0) {
                    ZHInformationSCVImageModel *firstModel = [iamgeArray objectAtIndex:0];
                    ZHInformationSCVImageModel *nowModel = [_imageArray objectAtIndex:0];
                    if (![firstModel.newsId isEqualToString:nowModel.newsId]) {
                        _imageArray = [NSMutableArray arrayWithArray:iamgeArray];
                        //放子线程队列中去
                        [ZHCoreDataManage removeInformationImageModelWithId:_categoryId];
                        for (ZHInformationSCVImageModel *saveModel in iamgeArray) {
                            [ZHCoreDataManage saveInformationImageModel:saveModel];
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (_requestType == RequestDataTypeForAllData) {
                            _requestType = RequestDataTypeForNews;
                        }else{
                            _requestType = RequestDataTypeNone;
                            [self stopAmination];
                        }
//                        [self showImageScrollView];
                    });
                }else{
                    _imageArray = [NSMutableArray arrayWithArray:iamgeArray];
                    for (ZHInformationSCVImageModel *saveModel in _imageArray) {
                        [ZHCoreDataManage saveInformationImageModel:saveModel];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (_requestType == RequestDataTypeForAllData) {
                            _requestType = RequestDataTypeForNews;
                        }else{
                            _requestType = RequestDataTypeNone;
                            [self loadTableViewData];
                            [self stopAmination];
                        }
//                        [self showImageScrollView];
                    });
                }
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_requestType == RequestDataTypeForAllData) {
                _requestType = RequestDataTypeForImage;
            }else{
                _requestType = RequestDataTypeNone;
                [self stopAmination];
            }
        });
    }];
    [op start];
}

//- (void)showImageScrollView
//{
//    _imageTimer = nil;
//    NSArray *subViews = [_imageScrollView subviews];
//    if ([subViews count] > 0) {
//        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    }
//    [self addScrollViewImage];
//    [_imageScrollView reloadInputViews];
//}
//
//- (void)addScrollViewImage
//{
//    if (_imageArray != nil && [_imageArray count] > 0) {
//        for (int i = 0; i < [_imageArray count]; i++) {
//            UIImageView * imgv = [[UIImageView alloc] initWithFrame:CGRectMake(_imageScrollView.frame.size.width*i, 0,_imageScrollView.frame.size.width ,120*WIDTHPROPORTION)];
//            ZHInformationSCVImageModel *model = [_imageArray objectAtIndex:i];
//            [imgv setImageWithURL:[NSURL URLWithString:model.titleImg]];
//            [_imageScrollView addSubview:imgv];
//            if (i == 0) {
//                [_imageTitleLabel setText:model.title];
//            }
//        }
//        [_imageScrollView setContentSize:CGSizeMake(SCREENWIDTH*[_imageArray count], 0)];
////        if (_imageTimer == nil) {
////            _imageTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(replaceImage) userInfo:nil repeats:YES];
////            _timeCount = 0;
////        }
//    }
//}
//
//- (void)replaceImage
//{
//    _timeCount ++;
//    if (_timeCount >= [_imageArray count]) {
//        _timeCount = 0;
//        [_imageTimer invalidate];
//        return;
//    }
//    [_imageScrollView setContentOffset:CGPointMake(_imageScrollView.contentOffset.x+_imageScrollView.frame.size.width*_timeCount, _imageScrollView.contentOffset.y)];
//    
//}

//请求对应id数据
- (void)requestNewsData
{
    if (_requestType == RequestDataTypeForImage) {
        _requestType = RequestDataTypeForAllData;
    }else if (_requestType == RequestDataTypeNone){
        _requestType = RequestDataTypeForNews;
    }
    if (_isShowHUD == NO) {
        [self startAmination:@"加载数据中"];
    }
    if (_categoryId != nil && ![_categoryId isEqualToString:@""]) {
        
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            NSString *xmlPath = [NSString stringWithFormat:@"%@/ssyw/getContent.jspx?channelId=%@&page=%d",SSYWHTTPHEAD,_categoryId,_pageNumber];
//            _index = -1;
//            NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:xmlPath]];
//            [parser setShouldProcessNamespaces:NO];
//            [parser setShouldReportNamespacePrefixes:NO];
//            [parser setShouldResolveExternalEntities:NO];
//            
//            [parser setDelegate:self];
//            [parser parse];
        NSString *xmlPath = [NSString stringWithFormat:@"%@/ssyw/getContent.jspx?channelId=%@&page=%d",SSYWHTTPHEAD,_categoryId,_pageNumber];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:xmlPath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [[_appDelegate operationQueue] addOperation:op];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            ZHInformationCellModel *oldNewsModel = nil;
            if (_pageNumber == 0 && [_newsArray count] > 0) {
                oldNewsModel = [_newsArray objectAtIndex:0];
            }
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:operation.responseData error:nil];
            GDataXMLElement *root = [doc rootElement];
            NSArray *itemArray = [root nodesForXPath:@"item" error:nil];
            for (int i = 0; i < [itemArray count]; i++) {
                GDataXMLDocument *ele = [itemArray objectAtIndex:i];
                ZHInformationCellModel *model = [[ZHInformationCellModel alloc] init];
                model.categoryname = [[[ele nodesForXPath:@"categoryName" error:nil] lastObject] stringValue];
                model.categoryid = [[[ele nodesForXPath:@"categoryId" error:nil] lastObject] stringValue];
                model.newsid = [[[ele nodesForXPath:@"newsId" error:nil] lastObject] stringValue];
                model.title = [[[ele nodesForXPath:@"title" error:nil] lastObject] stringValue];
                model.descripString = [[[ele nodesForXPath:@"description" error:nil] lastObject] stringValue];
                model.contenturl = [NSString stringWithFormat:@"%@:88/ssyw/newscontent/%@",SSYWHTTPHEAD,[[[ele nodesForXPath:@"contentUrl" error:nil] lastObject] stringValue]];
                model.contentHtmlUrl = [NSString stringWithFormat:@"%@/ssyw%@",SSYWHTTPHEAD,[[[ele nodesForXPath:@"contentHtmlUrl" error:nil] lastObject] stringValue]];
                model.author = [[[ele nodesForXPath:@"Author" error:nil] lastObject] stringValue];
                model.praise = [[[ele nodesForXPath:@"praise" error:nil] lastObject] stringValue];
                model.titleimg = [NSString stringWithFormat:@"%@%@",SSYWHTTPHEAD,[[[ele nodesForXPath:@"titleImg" error:nil] lastObject] stringValue]];
                model.pubdate = [[[ele nodesForXPath:@"pubDate" error:nil] lastObject] stringValue];
                model.praise = [[[ele nodesForXPath:@"praise" error:nil] lastObject] stringValue];
                model.belittle = [[[ele nodesForXPath:@"belittle" error:nil] lastObject] stringValue];
                if (_pageNumber == 0 && oldNewsModel) {
                    if (i == 0 && [model.newsid isEqualToString:oldNewsModel.newsid]) {
                        break;
                    }else if (i == 0){
                        [ZHCoreDataManage removePraiseNewsWithId:model.categoryid];
                    }
                }
                [_newsArray addObject:model];
                [ZHCoreDataManage savePraiseNewsWithModel:model];
            }
            [_newsDataArray replaceObjectAtIndex:_titleIndex withObject:[NSMutableArray arrayWithArray:_newsArray]];
            _pageNumber = (int)[_newsArray count]/10;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_requestType == RequestDataTypeForAllData) {
                    _requestType = RequestDataTypeForImage;
                }else{
                    _requestType = RequestDataTypeNone;
                    [self stopAmination];
                    [self loadTableViewData];
                }
                [self PullDownLoadEnd];
                [self PullUpLoadEnd];
            });
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_requestType == RequestDataTypeForAllData) {
                    _requestType = RequestDataTypeForNews;
                }else{
                    _requestType = RequestDataTypeNone;
                    [self stopAmination];
                }
            });
        }];
        [op start];
//        });
    }
}

//- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
//{
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self reductionTableView];
//    });
//    if ([elementName isEqualToString:@"item"]) {
//        _index ++;
//    }
//    _keyName = elementName;
//}
//
//- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
//{
//    if (_xmlDataArray == nil) {
//        _xmlDataArray = [[NSMutableArray alloc] init];
//    }
//    NSMutableDictionary *dictionary = nil;
//    if (_index < [_xmlDataArray count]) {
//        dictionary = [_xmlDataArray objectAtIndex:_index];
//    }else{
//        dictionary = [[NSMutableDictionary alloc] init];
//        [_xmlDataArray addObject:dictionary];
//    }
//    [dictionary setValue:string forKey:_keyName];
//}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_requestType == RequestDataTypeForAllData) {
            _requestType = RequestDataTypeForNews;
        }else{
            _requestType = RequestDataTypeNone;
            [self stopAmination];
        }
    });
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
        ZHInformationCellModel *oldNewsModel = nil;
        if (_pageNumber == 0 && [_xmlDataArray count] > 0 && [_newsArray count] > 0) {
            oldNewsModel = [_newsArray objectAtIndex:0];
        }
    dispatch_async([_appDelegate sharedQueue], ^{
        for (int i = 0; i < [_xmlDataArray count]; i++) {
            ZHInformationCellModel *model = [[ZHInformationCellModel alloc] init];
            model.categoryname = [[_xmlDataArray objectAtIndex:i] objectForKey:@"categoryName"];
            model.categoryid = [[_xmlDataArray objectAtIndex:i] objectForKey:@"categoryId"];
            model.pubdate = [[_xmlDataArray objectAtIndex:i] objectForKey:@"pubDate"];
            model.titleimg = [NSString stringWithFormat:@"%@%@",SSYWHTTPHEAD,[[_xmlDataArray objectAtIndex:i] objectForKey:@"titleImg"]];
            model.title = [[_xmlDataArray objectAtIndex:i] objectForKey:@"title"];
            model.descripString = [[_xmlDataArray objectAtIndex:i] objectForKey:@"description"];
            model.newsid = [[_xmlDataArray objectAtIndex:i] objectForKey:@"newsId"];
            model.contenturl = [NSString stringWithFormat:@"%@:88/ssyw/newscontent/%@",SSYWHTTPHEAD,[[_xmlDataArray objectAtIndex:i] objectForKey:@"contentUrl"]];
            model.contentHtmlUrl = [NSString stringWithFormat:@"%@/ssyw%@",SSYWHTTPHEAD,[[_xmlDataArray objectAtIndex:i] objectForKey:@"contentHtmlUrl"]];
            model.belittle = [[_xmlDataArray objectAtIndex:i] objectForKey:@"belittle"];
            model.author = [[_xmlDataArray objectAtIndex:i] objectForKey:@"Author"];
            model.praise = [[_xmlDataArray objectAtIndex:i] objectForKey:@"praise"];
            if (_pageNumber == 0 && oldNewsModel) {
                if (i == 0 && [model.newsid isEqualToString:oldNewsModel.newsid]) {
                    break;
                }else if (i == 0){
                    [_newsArray removeAllObjects];
                    [ZHCoreDataManage removePraiseNewsWithId:model.categoryid];
                }
            }
            [_newsArray addObject:model];
            [ZHCoreDataManage savePraiseNewsWithModel:model];
        }
        [_newsDataArray replaceObjectAtIndex:_titleIndex withObject:[NSMutableArray arrayWithArray:_newsArray]];
        _pageNumber = (int)[_newsArray count]/10;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_requestType == RequestDataTypeForAllData) {
                _requestType = RequestDataTypeForImage;
            }else{
                _requestType = RequestDataTypeNone;
                [self stopAmination];
            }
            [_tableView reloadData];
            [self PullDownLoadEnd];
            [self PullUpLoadEnd];
            [_xmlDataArray removeAllObjects];
        });
    });
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [self reductionTableView];
    if (_requestType == RequestDataTypeForAllData) {
        _requestType = RequestDataTypeForImage;
    }else{
        _requestType = RequestDataTypeNone;
        [self stopAmination];
    }
}

- (void)reductionTableView
{
    if (_isUp == YES) {
        [self PullUpLoadEnd];
    }else{
        [self PullDownLoadEnd];
    }
}

#pragma mark UIScrollView PullDelegate
- (void)scrollView:(UIScrollView*)scrollView loadWithState:(LoadState)state {
    
    if (state == PullDownLoadState) {
        _isUp = NO;
        _pageNumber = 0;
        [self requestImageData];
    }else {
        _isUp = YES;
        _pageNumber ++;
    }
    [self requestNewsData];
}

- (void)PullDownLoadEnd {
    [_tableView stopLoadWithState:PullDownLoadState];
}

- (void)PullUpLoadEnd {
    [_tableView stopLoadWithState:PullUpLoadState];
}

//滚动控件的委托方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView1
{
    CGFloat pageWidth = scrollView1.frame.size.width;
    _currentPage = floor((scrollView1.contentOffset.x - pageWidth/2.0f)/pageWidth) + 1;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    ZHInformationSCVImageModel *model = [_imageArray objectAtIndex:_currentPage];
    [_imageTitleLabel setText:model.title];
}

//联网开始转菊花
-(void)startAmination:(NSString *)strInfo
{
    _isShowHUD = YES;
    [self.view bringSubviewToFront:_HUD];
    [_HUD startShow:strInfo];
}

//停止转菊花
-(void)stopAmination
{
    _isShowHUD = NO;
    [_HUD startHide];
}

- (void)loadTableViewData
{
    [_tableView reloadData];
}

@end
