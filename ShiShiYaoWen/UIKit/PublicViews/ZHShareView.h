//
//  ZHShareView.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/15.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum ZHShareViewSelectType
{
    ZHShareViewSelectTypeWithTXWeibo,       //腾讯微博
    ZHShareViewSelectTypeWithEmail,         //电子邮件
    ZHShareViewSelectTypeWithSinaWeibo,     //新浪微博
    ZHShareViewSelectTypeWithTxQQ,          //腾讯QQ
    ZHShareViewSelectTypeWithTxQQZone,      //QQ空间
    ZHShareViewSelectTypeWithCancel,        //取消
}ZHShareViewSelectType;

@protocol ZHShareViewDelegate <NSObject>

- (void)shareSelectButtonWithType:(ZHShareViewSelectType)type;

@end

@interface ZHShareView : UIView

@property (nonatomic, weak) id <ZHShareViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *tenxunWeiBoButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *sinaWeiBoButton;
@property (weak, nonatomic) IBOutlet UIButton *tenxunQQButton;
@property (weak, nonatomic) IBOutlet UIButton *tenxunQQZoneButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)selectButtonClicked:(UIButton *)sender;

@end
