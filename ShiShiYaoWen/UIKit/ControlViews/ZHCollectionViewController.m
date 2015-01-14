//
//  ZHCollectionViewController.m
//  ShiShiYaoWen
//
//  Created by Mac on 14/12/11.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHCollectionViewController.h"
#import "ZHCollectionCell.h"
#import "ZHInformationCellModel.h"
#import "ZHInformationDetailViewController.h"

@interface ZHCollectionViewController ()

@end

@implementation ZHCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [titleLabel setText:@"我的收藏"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [self.navigationItem setTitleView:titleLabel];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
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

//    [self _requestData];
    
    _collectionArray = [NSMutableArray arrayWithArray:[ZHCoreDataManage getAllInformationCollectionModelWithNewsIdArray:nil]];
    if (_collectionModel == nil) {
        _collectionModel = [[ZHInformationCellModel alloc] init];
    }
//    _collectionArray = [[NSMutableArray alloc]init];
    

    for (NSString *str in _collectionArray) {
        
    
        _collectionModel.titleimg = [str valueForKey:@"titleimg"];
        _collectionModel.title =[str valueForKey:@"title"];
        _collectionModel.pubdate =[str valueForKey:@"pubdate"];
        [_collectionCell showDataWithModel:_collectionModel];
        
    }
    
}
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)_requestData
//{
//    if (_collectionModel == nil) {
//        _collectionModel = [[ZHInformationCellModel alloc] init];
//    }
//    _collectionArray = [[NSMutableArray alloc]init];
//    
//    
//    
//    
//    
//}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_collectionArray == nil) {
        return 44;
    }
    return 90;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( _collectionArray== nil) {
        return 0;
    }
    return [_collectionArray count];
//    return _collectionArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellName = @"CollectionCell";
    ZHCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];

    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ZHCollectionCell" owner:self options:nil] lastObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中cell时无色
        

    
    }
    _collectionModel = [_collectionArray objectAtIndex:indexPath.row];

    [cell showDataWithModel:_collectionModel];

  
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZHInformationCellModel *cellModel = [_collectionArray objectAtIndex:indexPath.row];
    ZHInformationDetailViewController *detailViewController = [[ZHInformationDetailViewController alloc] initWithModel:cellModel];
    [self.navigationController pushViewController:detailViewController animated:YES];
    
//    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate.homeTabBarControl setTabBarHidden:YES];

}


@end
