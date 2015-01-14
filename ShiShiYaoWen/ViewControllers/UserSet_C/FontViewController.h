//
//  FontViewController.h
//  shiyaowen
//
//  Created by Mac on 14/12/10.
//  Copyright (c) 2014年 PengLi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FontViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;   //TableView
    UILabel *bigLabel;
    UILabel *mediumLabel;
    UILabel *littleLabel;
    
        

}
@end
