//
//  BaseHealthController.m
//  zixun
//
//  Created by pro on 14/12/5.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "BaseHealthController.h"
#import "AppDelegate.h"
#import <AFNetworkActivityIndicatorManager.h>
@interface BaseHealthController ()

@end

@implementation BaseHealthController
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (UIFont *)getBoldFontWithSize:(float)size{
    float fontSize = ((AppDelegate *)([UIApplication sharedApplication].delegate)).fontSize;
    UIFont *font = [UIFont boldSystemFontOfSize:size+fontSize];
    return font;
}
- (UIFont *)getSysFontWithSize:(float)size{
    float fontSize = ((AppDelegate *)([UIApplication sharedApplication].delegate)).fontSize;
    UIFont *font = [UIFont systemFontOfSize:size+fontSize];
    return font;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                NSFontAttributeName:[UIFont boldSystemFontOfSize:20],
                NSForegroundColorAttributeName:[UIColor whiteColor], //前景字体颜色
                }];
    
    _nNavOffset = 44;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        _nNavOffset = 0;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    
    // Do any additional setup after loading the view.
}
- (void)setBack{

    UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(0, 0, 28, 30);
    [bt setBackgroundImage:[UIImage imageNamed:@"ZH_NavigationBack@3x"] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:bt];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//更具内容获取大小
- (CGSize)getTextSize:(UILabel *)lb{
    CGSize size =[lb.text boundingRectWithSize:CGSizeMake(winSize.width-20, 2000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:lb.font} context:nil].size;
    return size;
}
- (NSString *)convertString:(NSString *)string{
    if ([string isEqualToString:@""]||string == nil) {
        return @"暂无数据！\n";
    }
    string = [[string componentsSeparatedByString:@"<div"] firstObject];
    NSMutableString *st = [NSMutableString stringWithString:string];
    [st replaceOccurrencesOfString:@"\n" withString:@"" options:0 range:NSMakeRange(0, st.length)];
    [st replaceOccurrencesOfString:@"<p>" withString:@"" options:0 range:NSMakeRange(0, st.length)];
    [st replaceOccurrencesOfString:@"</p>" withString:@"" options:0 range:NSMakeRange(0, st.length)];
    [st replaceOccurrencesOfString:@"&nbsp;" withString:@"" options:0 range:NSMakeRange(0, st.length)];
    [st replaceOccurrencesOfString:@"<br />" withString:@"\n" options:0 range:NSMakeRange(0, st.length)];
    [st replaceOccurrencesOfString:@"<br/>" withString:@"" options:0 range:NSMakeRange(0, st.length)];
    [st replaceOccurrencesOfString:@"<br>" withString:@"\n" options:0 range:NSMakeRange(0, st.length)];
    [st replaceOccurrencesOfString:@"|" withString:@"  " options:0 range:NSMakeRange(0, st.length)];
    [st replaceOccurrencesOfString:@"<strong>" withString:@"" options:0 range:NSMakeRange(0, st.length)];
    [st replaceOccurrencesOfString:@"</strong>" withString:@"" options:0 range:NSMakeRange(0, st.length)];
    [st replaceOccurrencesOfString:@"<sub>" withString:@"" options:0 range:NSMakeRange(0, st.length)];
    [st replaceOccurrencesOfString:@"</sub>" withString:@"" options:0 range:NSMakeRange(0, st.length)];
    if ([st characterAtIndex:st.length-1] != '\n') {
        [st appendFormat:@"\n"];
    }
    return st;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // NSLog(@"%@",[self class]);
    [MTA trackPageViewBegin:[NSString stringWithFormat:@"%@",[self class]]];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:[NSString stringWithFormat:@"%@",[self class]]];
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
