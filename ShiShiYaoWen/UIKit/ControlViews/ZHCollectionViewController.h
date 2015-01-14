//
//  ZHCollectionViewController.h
//  ShiShiYaoWen
//
//  Created by Mac on 14/12/11.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHBaseViewController.h"
#import "ZHInformationCellModel.h"

#import "ZHCoreDataManage.h"
@class ZHCollectionCell;

@interface ZHCollectionViewController : ZHBaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_collectionArray;
    ZHInformationCellModel *_collectionModel;
    ZHCollectionCell *_collectionCell;
}


@end
