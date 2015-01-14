//
//  ZHNewsDetialFootView.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/8.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum ZHFootSelectType{
//    ZHFootSelectTypeSize,       //调整字号
    ZHFootSelectTypeCollect,    //收藏
    ZHFootSelectTypePraise,     //点赞
    ZHFootSelectTypeStep,       //踩
    ZHFootSelectTypeShare       //分享
}ZHFootSelectType;

@protocol ZHNewsDetialFootViewDelegate <NSObject>

- (void)selectFootButtonWithType:(ZHFootSelectType)selectType andButton:(UIButton *)sender;

@end

@interface ZHNewsDetialFootView : UIView

@property (nonatomic, weak) id<ZHNewsDetialFootViewDelegate>delegate;
@property (nonatomic, assign) BOOL collectSelect;

//@property (weak, nonatomic) IBOutlet UIButton *sizeButton;      //调整字号
@property (weak, nonatomic) IBOutlet UIButton *collectButton;   //收藏
@property (weak, nonatomic) IBOutlet UIButton *praiseButton;    //点赞
@property (weak, nonatomic) IBOutlet UIButton *stepButton;      //踩
@property (weak, nonatomic) IBOutlet UIButton *shareButton;     //分享

- (IBAction)selectButtonClicked:(UIButton *)sender;

- (void)setCollectButtonSelected:(BOOL)selected;
- (void)setPraiseButtonSelected;
- (void)setSetpButtonSelected;

@end
