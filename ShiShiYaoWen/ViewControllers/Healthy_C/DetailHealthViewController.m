//
//  DetailHealthViewController.m
//  zixun
//
//  Created by pro on 14/12/5.
//  Copyright (c) 2014年 pro. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "DetailHealthViewController.h"
#import "SCDetailViewController.h"
#import "HealtyCFModel.h"
#import "SCYYViewController.h"

@interface DetailHealthViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *_dataArray;
    UITableView *_tableView;
    UITextField *_scBar;
    int _index;
    UILabel *_node;
}
@end

@implementation DetailHealthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBack];
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeView];
    if (self.type == 1) {
        self.title = @"食物营养成分查询";
    }else if(self.type == 2){
        self.title = @"产品成分配料查询";
    }
    [self showNode];
    // Do any additional setup after loading the view.
}
- (void)showNode{
    _node = [[UILabel alloc] initWithFrame:CGRectMake(15, _nNavOffset+50, winSize.width-30, 200)];
    _node.textColor = [UIColor grayColor];
    _node.font = [UIFont fontWithName:@"MarkerFelt-Wide" size:16];
    _node.numberOfLines = 0;
    if (self.type == 2) {
        _node.text = @"Note:\n      配料查看是针对想了解具体产品参数而设定的查询，可以直接输入产品名称（比如：蒙牛），查找到市场上与此相关的产品，并进一步查看此产品的成分，配料，保质期等信息。\n      此版本目前可查询市场上所售饮料喝奶制品，产品数据库将陆续完善，敬请期待。";
    }else{
        _node.text = @"Note:\n      食物营养查询是针对想了解具体食物参数而设定的查询，可以直接输入产品食物（比如：苹果），查找到市场上与此相关的食物，并进一步查看此产品的成分，等信息。\n     产品数据库将陆续完善，敬请期待。";
    }
    [self.view addSubview:_node];
}
//点击搜索
- (void)searchClick:(id)search{
    _node.text = @"";
    _node.textAlignment = NSTextAlignmentCenter;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_scBar resignFirstResponder];
    if (self.type == 2) {
        [self startRequest];
    }else if (self.type == 1){
        [self startRequest1];
    }
    _scBar.text = @"";
}
- (void)makeView{
    _dataArray = [[NSMutableArray alloc] init];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50+_nNavOffset, winSize.width, winSize.height-64-100) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    [self.view addSubview:_tableView];
    //搜索框
    UIView *bgSc = [[UIView alloc] initWithFrame:CGRectMake(0, _nNavOffset, winSize.width, 50)];
    bgSc.backgroundColor = UIColorFromRGB(0xE2E2E2);
    _scBar = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, winSize.width-80, 30)];
    _scBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _scBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _scBar.clearButtonMode = UITextFieldViewModeAlways;
    _scBar.delegate = self;
    _scBar.borderStyle = UITextBorderStyleRoundedRect;
    _scBar.placeholder = @"搜索你想要的信息";
    _scBar.font = [UIFont boldSystemFontOfSize:15];
    [bgSc addSubview:_scBar];

    //搜索按钮
    UIButton *scBt = [[UIButton alloc] initWithFrame:CGRectMake(winSize.width-60, 10, 50, 30)];
    [scBt setBackgroundImage:[UIImage imageNamed:@"ZH_Healthy_Magnifier@3x"] forState:UIControlStateNormal];
    [scBt addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgSc addSubview:scBt];
    [self.view addSubview:bgSc];
    //来源伙伴网
    UILabel *_sourchLb = [[UILabel alloc] initWithFrame:CGRectMake(20, winSize.height-64-40, winSize.width-40, 30)];
    _sourchLb.backgroundColor = UIColorFromRGB(0xE2E2E2);
    _sourchLb.text = @"查询数据来源于：食品伙伴网";
    _sourchLb.textAlignment = NSTextAlignmentCenter;
    _sourchLb.textColor = [UIColor grayColor];
    _sourchLb.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:_sourchLb];
    
}
#pragma mark -searchBar
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gcell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"gcell"];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [self getSysFontWithSize:17];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    if (self.type == 2){
        HealthSCModel *data = _dataArray[indexPath.row];
               cell.textLabel.text = data.title;
    }else if(self.type == 1){
        HealtyCFModel *data = _dataArray[indexPath.row];
        cell.textLabel.text = data.name;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //配料
    if (self.type == 2) {
        SCDetailViewController *svc = [[SCDetailViewController alloc] init];
        svc.data = _dataArray[indexPath.row];
        [self.navigationController pushViewController:svc animated:YES];
    }else if (self.type == 1){
    //营养成分
        SCYYViewController *yvc = [[SCYYViewController alloc] init];
        yvc.data = _dataArray[indexPath.row];
        [self.navigationController pushViewController:yvc animated:YES];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [_scBar resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//配料请求数据
- (void)startRequest{
    if ([_scBar.text isEqualToString:@""]||!_scBar.text) {
        return;
    }
    NSString *url = [NSString stringWithFormat:PLURL,_scBar.text];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];

        int status = [dict[@"success"] intValue];
        [_dataArray removeAllObjects];
        if (status == 1&&![dict[@"data"] isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dc in dict[@"data"][@"items"]) {
                HealthSCModel *data = [[HealthSCModel alloc] init];
                [data setValuesForKeysWithDictionary:dc];
                [_dataArray addObject:data];
            }
        }else{
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _node.text = @"Note:  没有查找到你想查询的数据！";
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
        _node.text = @"Note:  请检查您的网络！";
        
    }];
    [op start];
}
//营养成分查询
- (void)startRequest1{
    if ([_scBar.text isEqualToString:@""]||!_scBar.text) {
        return;
    }
    NSString *url = [NSString stringWithFormat:CFURL,_scBar.text];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        int status = [dict[@"success"] intValue];
        [_dataArray removeAllObjects];
        if (status == 1&&![dict[@"data"] isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dc in dict[@"data"]) {
                HealtyCFModel *data = [[HealtyCFModel alloc] init];
                [data setValuesForKeysWithDictionary:dc];
                [_dataArray addObject:data];
            }
        }else{
            _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            _node.text = @"Note:  没有查找到你想查询的数据！";
        }
        [_tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _node.text = @"Note:  请检查您的网络！";
        NSLog(@"请求失败");
    }];
    [op start];
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
