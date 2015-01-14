//
//  ZHPolularViewController.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/8.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHPolularViewController.h"
#import "PolularScienCell.h"
#import "AppDelegate.h"
#import "UIScrollView+PullLoad.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Reachability.h"

#define PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/VideoCache"]
#define PATHKEY [NSString stringWithFormat:@"key%d",_index]


@interface ZHPolularViewController ()<UITableViewDataSource,UITableViewDelegate,PullDelegate>
{
    MPMoviePlayerViewController *_playerController;
    
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    int _index;
    BOOL isPullDown;
    BOOL isPullUp;
    int _lastIndex;
}
@end

@implementation ZHPolularViewController
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"FontSizeNotification" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"科普短片";

    [self makeView];
    _index = 0;
    [self starRequest];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveNotification:) name:@"FontSizeNotification" object:nil];
    // Do any additional setup after loading the view.
}

-(void)reciveNotification:(NSNotification *)noti{
        //通知的名字，通知的内容
//        NSLog(@"---listener1-----");
//        NSLog(@"%@",noti.name);
//        NSLog(@"%@",noti.object);
//        NSLog(@"%@",noti.userInfo);
    [_tableView reloadData];
}
//请求数据
- (void)starRequest{
    self.channelId = @"65";
    NSString *url = [NSString stringWithFormat:@"http://ssyw.51yaoshi.com/ssyw/getContent.jspx?channelId=%@&page=%d",self.channelId,_index];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:operation.responseData error:nil];
        GDataXMLElement *root = [doc rootElement];
        if (root.childCount >= 1){
            //缓存
            [self setCacheWithObject:operation.responseData key:PATHKEY];
        }
        if (isPullDown) {
            [_dataArray removeAllObjects];
        }
        for(GDataXMLElement *item in [root children]){
            HeathModel *data = [[HeathModel alloc] init];
            for (GDataXMLElement *ele in [item children]) {
                [data setValue:ele.stringValue forKey:ele.name];
            }
            [_dataArray addObject:data];
        }
        //加载
        if (isPullUp) {
            [self performSelectorOnMainThread:@selector(PullUpLoadEnd) withObject:nil waitUntilDone:NO];
        }else if(isPullDown){       //刷新
            [self PullDownLoadEnd];
        }else{
            [_tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSData *data = [self getCacheWithKey:PATHKEY];
        if (data) {
            if (isPullDown) {
                [_dataArray removeAllObjects];
            }
            GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data error:nil];
            GDataXMLElement *root = [doc rootElement];
            for(GDataXMLElement *item in [root children]){
                HeathModel *data = [[HeathModel alloc] init];
                for (GDataXMLElement *ele in [item children]) {
                    [data setValue:ele.stringValue forKey:ele.name];
                }
        
                [_dataArray addObject:data];
            
            }
            [_tableView reloadData];
        }else{
            if(isPullUp){
                _index --;
            }
            if (isPullDown) {
                _index = _lastIndex;
            }
        }
        
        isPullDown = NO;
        isPullUp = NO;
        [_tableView stopLoadWithState:PullUpLoadState];
        [_tableView stopLoadWithState:PullDownLoadState];
        
        NSLog(@"请求失败");
    }];
    [op start];
}
- (void)makeView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-49*WIDTHPROPORTION-64) style:UITableViewStylePlain];
    _dataArray = [[NSMutableArray alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setPullDelegate:self];
    [_tableView setCanPullUp:YES];
    [_tableView setCanPullDown:YES];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
#pragma mark- UITableViewDelegate
//选中某一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    HeathModel *data = _dataArray[indexPath.row];
    if ([data.mediaPath isEqualToString:@""]||!data.mediaPath) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无视屏链接" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSString *path = [NSString stringWithFormat:@"%@%@",SSYWHTTPHEAD,data.mediaPath];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            HJAlertView *alertView = nil;
            if (status == AFNetworkReachabilityStatusNotReachable) {
                alertView = [[HJAlertView alloc] initWithTitle:@"提示" andMessage:@"当前无网络，请检查你的网络" andDelegate:self andAddInfo:nil andButtonColor:[UIColor blueColor] andButtonTitles:@"确定"];
                [alertView setTag:2001];
            }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){
                [self presentMoviePlayerWithPath:path];
            }else if (AFNetworkReachabilityStatusReachableViaWWAN == status){
                alertView = [[HJAlertView alloc] initWithTitle:@"提示" andMessage:@"您现在并未使用Wifi网络查看视频，是否继续播放视频" andDelegate:self andAddInfo:path andButtonColor:[UIColor blueColor] andButtonTitles:@"取消",@"继续",nil];
                [alertView setTag:2002];
            }else{
                alertView = [[HJAlertView alloc] initWithTitle:@"提示" andMessage:@"当前网络未知" andDelegate:self andAddInfo:nil andButtonColor:[UIColor blueColor] andButtonTitles:@"确定"];
                [alertView setTag:2003];
            }
            [alertView show];
        });
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 190;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PolularScienCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PoluarScCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PolularScienCell" owner:self options:nil] lastObject];
    }
    cell.dtTitle.font = [self getSysFontWithSize:17];
    HeathModel *data = [_dataArray objectAtIndex:indexPath.row];
    [cell updateData:data];
    return cell;
}
//刷新加载
- (void)scrollView:(UIScrollView*)scrollView loadWithState:(LoadState)state {
    if (state == PullDownLoadState) {
        isPullDown = YES;
        _lastIndex = _index;
        _index = 0;
        [self starRequest];
    }
    //上拉加载
    else {
        isPullUp = YES;
        _index ++;
        [self starRequest];
    }
}
- (void)PullDownLoadEnd {
    _tableView.canPullUp = YES;
    isPullDown = NO;
    [_tableView reloadData];
    [_tableView stopLoadWithState:PullDownLoadState];
}

- (void)PullUpLoadEnd {
    BOOL bo = NO;
    if (bo) {
        _tableView.canPullUp = NO;
    }
    isPullUp = NO;
    [_tableView reloadData];
    [_tableView stopLoadWithState:PullUpLoadState];
}

- (void)presentMoviePlayerWithPath:(NSString *)path
{
    _playerController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:path]];
    //  _playerController.moviePlayer.view.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    //获取homeController
    UIViewController *root = ((AppDelegate *)([UIApplication sharedApplication].delegate)).window.rootViewController;
    [root presentMoviePlayerViewControllerAnimated:_playerController];
}

//缓存
- (BOOL)setCacheWithObject:(NSData *)data key:(NSString *)key{
    [self createFile];
    BOOL ret = [NSKeyedArchiver archiveRootObject:data toFile:[NSString stringWithFormat:@"%@/%@",PATH,key]];
    return ret;
}
- (NSData *)getCacheWithKey:(NSString *)key{
    NSData *data =[NSKeyedUnarchiver unarchiveObjectWithFile:[NSString stringWithFormat:@"%@/%@",PATH,key]];
    return data;
}
//创建缓存路径文件夹
- (void)createFile{
    NSString *imageDir = PATH;
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
+ (void)deleteCache{
    NSString *imageDir = PATH;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:imageDir error:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)HJalertView:(HJAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex AddInformation:(id)addInfo
{
    if (alertView.tag == 2002 && [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"继续"]) {
        NSString *path = (NSString *)addInfo;
        [self presentMoviePlayerWithPath:path];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
