//
//  ZHInformationHeadImageCell.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/19.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHInformationImageHeadView.h"

@interface ZHInformationHeadImageCell : UITableViewCell

@property (nonatomic, strong) ZHInformationImageHeadView *imageHeadView;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andModelArray:(NSArray *)modelArray;

@end
