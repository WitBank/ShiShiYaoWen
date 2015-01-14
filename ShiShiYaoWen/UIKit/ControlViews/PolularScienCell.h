//
//  PolularScienCell.h
//  ShiShiYaoWen
//
//  Created by pro on 14/12/11.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeathModel.h"
@interface PolularScienCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dtTitle;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
- (void)updateData:(HeathModel *)data;
@end
