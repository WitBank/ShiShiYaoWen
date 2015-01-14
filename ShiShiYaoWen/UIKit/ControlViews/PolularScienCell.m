//
//  PolularScienCell.m
//  ShiShiYaoWen
//
//  Created by pro on 14/12/11.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "PolularScienCell.h"
#import <UIImageView+AFNetworking.h>
@implementation PolularScienCell

- (void)awakeFromNib {
    UIView *selectedView = [[UIView alloc] init];
    selectedView.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = selectedView;
    // Initialization code
}

- (void)updateData:(HeathModel *)data{
    
    [self.headImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SSYWHTTPHEAD,data.titleImg]] placeholderImage:[UIImage imageNamed:@"ZH_Download_Image@3x.png"]];
    self.dtTitle.text = data.title;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.dtTitle.backgroundColor = [UIColor whiteColor];
    // Configure the view for the selected state
}

@end
