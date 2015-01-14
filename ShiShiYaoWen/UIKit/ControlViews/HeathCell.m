//
//  HeathCell.m
//  zixun
//
//  Created by pro on 14/12/5.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "HeathCell.h"
#import <UIImageView+AFNetworking.h>

//rgb颜色转化   UIColorFromRGB(0x34465C);
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define winSize [UIScreen mainScreen].bounds.size
@interface HeathCell()
{
    UIImageView *_headImg;
    UILabel *_nameLb;
    UILabel *_detailLb;
    UIButton *_favorite;
    
}
@end
@implementation HeathCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *sebg = [[UIView alloc] init];
        sebg.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = sebg;
        [self makeView];
    }
    return self;
}
//更新数据
- (void)updateData:(HeathModel *)data{
    _nameLb.text = data.Author;
    _detailLb.text = data.descrip;
    [_headImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SSYWHTTPHEAD,data.titleImg]]];
}
- (void)makeView{
    UIImageView *_bgimg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, winSize.width-20, 80)];
    _bgimg.image = [UIImage imageNamed:@"Healthy_bg"];
    
    
    _headImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 60)];
    _headImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"a%d",arc4random()%2+1]];
    [_bgimg addSubview:_headImg];
    _nameLb = [[UILabel alloc] initWithFrame:CGRectMake(85, 5, _bgimg.frame.size.width-110, 35)];
  //  _nameLb.text = @"香菇鱼汤";
    _nameLb.font = [UIFont boldSystemFontOfSize:17];
    
    _detailLb = [[UILabel alloc] initWithFrame:CGRectMake(85, 35, _bgimg.frame.size.width-115, 40)];
    _detailLb.textColor = [UIColor grayColor];
    _detailLb.numberOfLines = 0;
    _detailLb.font = [UIFont boldSystemFontOfSize:13];
  //  _detailLb.text = @"鱼肉含有维生素B,C等有害物C等有害物。";
    
    //喜爱
    _favorite = [UIButton buttonWithType:UIButtonTypeCustom];
    _favorite.frame = CGRectMake(_bgimg.frame.size.width-30, 40, 20, 20);
    [_favorite setBackgroundImage:[UIImage imageNamed:@"ZH_Healthy_Collect_normal"] forState:UIControlStateNormal];
    [_favorite setBackgroundImage:[UIImage imageNamed:@"ZH_Healthy_Collect_select"] forState:UIControlStateSelected];
    arc4random()%2?(_favorite.selected = YES):(_favorite.selected = NO);
    [_bgimg addSubview:_favorite];
    [_bgimg addSubview:_detailLb];
    [_bgimg addSubview:_nameLb];
    [self.contentView addSubview:_bgimg];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
