//
//  EncyclopediaViewController.m
//  ShiShiYaoWen
//
//  Created by pro on 14/12/12.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "EncyclopediaViewController.h"
#import "HealthDTModel.h"
#import "UIScrollView+PullLoad.h"
#import "DetailViewController.h"
#import "TJJDTViewController.h"

@interface EncyclopediaViewController ()<UITableViewDataSource,UITableViewDelegate,PullDelegate>
{
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    int _index;
    BOOL isPullDown;//刷新
    BOOL isPullUp;//加载
}
@end

@implementation EncyclopediaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBack];
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeView];
    if (self.type == 0) {
        _index = 1;
        [self startRequest1];
        [_tableView setPullDelegate:self];
        [_tableView setCanPullUp:YES];
        [_tableView setCanPullDown:YES];
        self.title = @"添加剂百科";
    }else if(self.type == 3){
        
        self.title = @"营养成分百科";
        [self startRequest];
    }
    // Do any additional setup after loading the view.
}
//营养成分百科
- (void)startRequest{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:YYBKURL]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        int status = [dict[@"success"] intValue];
        if (status == 1) {
            for (NSDictionary *dc in dict[@"data"]) {
                HealthDTModel *data = [[HealthDTModel alloc] init];
                [data setValuesForKeysWithDictionary:dc];
                [_dataArray addObject:data];
            }
            [_tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    [op start];
}
//添加剂请求
- (void)startRequest1{

    NSString *url = [NSString stringWithFormat:TJJURL,_index];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        int status = [dict[@"success"] intValue];
        if (isPullDown) {
            [_dataArray removeAllObjects];
        }
        if (status == 1) {
            for (NSDictionary *dc in dict[@"data"][@"items"]) {
                HealthDTModel *data = [[HealthDTModel alloc] init];
                [data setValuesForKeysWithDictionary:dc];
                [_dataArray addObject:data];
            }
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
        isPullUp = NO;
        isPullUp = NO;
        [_tableView stopLoadWithState:PullUpLoadState];
        [_tableView stopLoadWithState:PullDownLoadState];
        NSLog(@"请求失败");
    }];
    [op start];
    
}
- (void)makeView{
    _dataArray = [[NSMutableArray alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,_nNavOffset, winSize.width, winSize.height-64-50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    [self.view addSubview:_tableView];
    
    
    //来源伙伴网
    UILabel *_sourchLb = [[UILabel alloc] initWithFrame:CGRectMake(20, winSize.height-64-40, winSize.width-40, 30)];
    _sourchLb.backgroundColor = UIColorFromRGB(0xE2E2E2);
    _sourchLb.text = @"查询数据来源于：食品伙伴网";
    _sourchLb.textAlignment = NSTextAlignmentCenter;
    _sourchLb.textColor = [UIColor grayColor];
    _sourchLb.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:_sourchLb];
}
#pragma mark- tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gcell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"gcell"];
        cell.textLabel.font = [self getSysFontWithSize:17];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    HealthDTModel *data = _dataArray[indexPath.row];
    cell.textLabel.text = data.name;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //营养成分百科
    if (self.type == 3) {
        DetailViewController *dt = [[DetailViewController alloc] init];
        dt.data = _dataArray[indexPath.row];
        [self.navigationController pushViewController:dt animated:YES];
    }if(self.type == 0){    //添加剂百科
        TJJDTViewController *tvc = [[TJJDTViewController alloc] init];
        HealthDTModel *data1 =_dataArray[indexPath.row];
        tvc.Sid = data1.Sid;
        [self.navigationController pushViewController:tvc animated:YES];
    }


}
//刷新加载
- (void)scrollView:(UIScrollView*)scrollView loadWithState:(LoadState)state {
    if (state == PullDownLoadState) {
        isPullDown = YES;
        _index = 1;
        [self startRequest1];
    }
    //上拉加载
    else {
        isPullUp = YES;
        _index ++;
        [self startRequest1];
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

@end
