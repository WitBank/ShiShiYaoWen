//
//  ZHSpecialViewController.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/8.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHSpecialViewController.h"
#import "SpecialTableViewCell.h"
#import "AppDelegate.h"
#import "ZHCoreDataManage.h"
#import "ZHSpecialDetailViewController.h"
#import "ZHSettingsViewController.h"

#define ZHSPECIALVIEWCONTROLLER @"ZHSpecialViewController"

@interface ZHSpecialViewController ()

@end

@implementation ZHSpecialViewController
{
    NSMutableArray *_dataArray;
    int _pageNumber;
    UITableView *_tableView;
    BOOL _isUp;
    BOOL _isDownload;
    CGFloat _fontSize;
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
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSize) name:REFRESHFONTSIZE object:nil];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *fontSize = [userDefaults objectForKey:@"fontSize"];
    if (fontSize == nil) {
        _fontSize = 0;
    }else{
        _fontSize = [fontSize intValue];
    }
    
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    _dataArray = [NSMutableArray arrayWithArray:delegate.specialNewsArray];
    _pageNumber = (int)[_dataArray count]/10;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [titleLabel setText:@"深度专题"];
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
                                                           andFrame:CGRectMake(0, 0, 24, 24)];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:setButton];
    self.navigationItem.leftBarButtonItem = buttonItem;
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _nNavOffset, SCREENWIDTH, SCREENHEIGHT-_nNavOffset - 49*WIDTHPROPORTION) style:UITableViewStylePlain];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setPullDelegate:self];
    [_tableView setCanPullUp:YES];
    [_tableView setCanPullDown:YES];
    [self.view addSubview:_tableView];
    
    if ([_dataArray count] <= 0) {
        [self requestNewsData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.homeTabBarControl setTabBarHidden:NO];
    [MTA trackPageViewBegin:ZHSPECIALVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:ZHSPECIALVIEWCONTROLLER];
}

- (void)userSetClick
{
    ZHSettingsViewController *settingsVC = [[ZHSettingsViewController alloc]init];
    [self.navigationController pushViewController:settingsVC animated:YES];
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.homeTabBarControl setTabBarHidden:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataArray == nil) {
        return 0;
    }
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"SpecialCell";
    SpecialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SpecialTableViewCell" owner:self options:nil] lastObject];
    }
    ZHSpecialCellModel *model = [_dataArray objectAtIndex:indexPath.row];
    [cell showDataWithSpecialModel:model andFont:_fontSize];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataArray == nil && [_dataArray count] <= 0) {
        return 44;
    }
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
    ZHSpecialCellModel *sModel = [_dataArray objectAtIndex:indexPath.row];
    ZHInformationCellModel *model = [[ZHInformationCellModel alloc] init];
    model.categoryname = sModel.categoryname;
    model.categoryid = sModel.categoryid;
    model.titleimg = sModel.titleimg;
    model.title = sModel.title;
    model.pubdate = sModel.pubdate;
    model.descripString = sModel.descripString;
    model.contentString = sModel.contentString;
    model.newsid = sModel.newsid;
    model.contenturl = sModel.contenturl;
    model.contentHtmlUrl = sModel.contentHtmlUrl;
    model.author = sModel.author;
    model.praise = sModel.praise;
    model.belittle = sModel.belittle;
    
    ZHSpecialDetailViewController *detailView = [[ZHSpecialDetailViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:detailView animated:YES];
    
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.homeTabBarControl setTabBarHidden:YES];
}

#pragma mark - 下载数据
- (void)requestNewsData
{
    NSString *xmlPath = [NSString stringWithFormat:@"%@/ssyw/getContent.jspx?channelId=64&page=%d",SSYWHTTPHEAD,_pageNumber];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:xmlPath]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reductionTableView];
        });
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:operation.responseData error:nil];
        GDataXMLElement *root = [doc rootElement];
        NSArray *itemArray = [root nodesForXPath:@"item" error:nil];
        if (_pageNumber == 0 && [_dataArray count] > 0) {
            GDataXMLDocument *firstEle = [itemArray objectAtIndex:0];
            ZHSpecialCellModel *nowModel = [_dataArray objectAtIndex:0];
            if (![nowModel.newsid isEqualToString:[[[firstEle nodesForXPath:@"newsId" error:nil] lastObject] stringValue]]) {
                [ZHCoreDataManage removeSpecialNewsWithId:nil];
                for (GDataXMLElement *ele in itemArray) {
                    ZHSpecialCellModel *model = [[ZHSpecialCellModel alloc] init];
                    model.categoryname = [[[ele nodesForXPath:@"categoryName" error:nil] lastObject] stringValue];
                    model.categoryid = [[[ele nodesForXPath:@"categoryId" error:nil] lastObject] stringValue];
                    model.newsid = [[[ele nodesForXPath:@"newsId" error:nil] lastObject] stringValue];
                    model.title = [[[ele nodesForXPath:@"title" error:nil] lastObject] stringValue];
                    model.descripString = [[[ele nodesForXPath:@"description" error:nil] lastObject] stringValue];
                    model.contenturl = [[[ele nodesForXPath:@"contentUrl" error:nil] lastObject] stringValue];
                    model.contentHtmlUrl = [NSString stringWithFormat:@"%@/ssyw%@",SSYWHTTPHEAD,[[[ele nodesForXPath:@"contentHtmlUrl" error:nil] lastObject] stringValue]];
                    model.author = [[[ele nodesForXPath:@"Author" error:nil] lastObject] stringValue];
                    model.praise = [[[ele nodesForXPath:@"praise" error:nil] lastObject] stringValue];
                    model.belittle = [[[ele nodesForXPath:@"belittle" error:nil] lastObject] stringValue];
                    model.pubdate = [[[ele nodesForXPath:@"pubDate" error:nil] lastObject] stringValue];
                    model.titleimg = [NSString stringWithFormat:@"%@%@",SSYWHTTPHEAD,[[[ele nodesForXPath:@"titleImg" error:nil] lastObject] stringValue]];
                    [_dataArray addObject:model];
                    [ZHCoreDataManage saveSpecialNewsWithModel:model];
                }
            }
        }else{
            for (GDataXMLElement *ele in itemArray) {
                ZHSpecialCellModel *model = [[ZHSpecialCellModel alloc] init];
                model.categoryname = [[[ele nodesForXPath:@"categoryName" error:nil] lastObject] stringValue];
                model.categoryid = [[[ele nodesForXPath:@"categoryId" error:nil] lastObject] stringValue];
                model.newsid = [[[ele nodesForXPath:@"newsId" error:nil] lastObject] stringValue];
                model.title = [[[ele nodesForXPath:@"title" error:nil] lastObject] stringValue];
                model.descripString = [[[ele nodesForXPath:@"description" error:nil] lastObject] stringValue];
                model.contenturl = [[[ele nodesForXPath:@"contentUrl" error:nil] lastObject] stringValue];
                model.contentHtmlUrl = [NSString stringWithFormat:@"%@/ssyw%@",SSYWHTTPHEAD,[[[ele nodesForXPath:@"contentHtmlUrl" error:nil] lastObject] stringValue]];
                model.author = [[[ele nodesForXPath:@"Author" error:nil] lastObject] stringValue];
                model.praise = [[[ele nodesForXPath:@"praise" error:nil] lastObject] stringValue];
                model.belittle = [[[ele nodesForXPath:@"belittle" error:nil] lastObject] stringValue];
                model.pubdate = [[[ele nodesForXPath:@"pubDate" error:nil] lastObject] stringValue];
                model.titleimg = [NSString stringWithFormat:@"%@%@",SSYWHTTPHEAD,[[[ele nodesForXPath:@"titleImg" error:nil] lastObject] stringValue]];
                [_dataArray addObject:model];
            }
        }
                
            
        if ([_dataArray count] > 0) {
            [_tableView reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"请求失败");
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reductionTableView];
        });
    }];
    [op start];
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
    }
    else {
        _isUp = YES;
        _pageNumber++;
    }
    [self requestNewsData];
}

- (void)PullDownLoadEnd {
    [_tableView stopLoadWithState:PullDownLoadState];
}

- (void)PullUpLoadEnd {
    [_tableView stopLoadWithState:PullUpLoadState];
}

@end
