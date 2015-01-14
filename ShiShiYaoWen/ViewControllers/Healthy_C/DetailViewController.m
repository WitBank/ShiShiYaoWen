//
//  DetailViewController.m
//  zixun
//
//  Created by pro on 14/12/5.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "DetailViewController.h"
@interface DetailViewController ()
{
    UILabel *_titleLb;
    UILabel *_jj;
    UILabel *_pl;
    UILabel *_bzq;
    UIScrollView *_scrollView;
}
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBack];
    [self makeView];
    self.title = @"详情";
    [self startRequest];
    // Do any additional setup after loading the view.
}
- (void)makeView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _nNavOffset, winSize.width, winSize.height - 64)];
    [self.view addSubview:_scrollView];
    //头部
    _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, winSize.width-20, 50)];

    UIImageView *bgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, winSize.width, 50)];
    bgv.backgroundColor = UIColorFromRGB(0xE2E2E2);
    [bgv addSubview:_titleLb];
    _titleLb.numberOfLines = 0;
    _titleLb.font = [self getBoldFontWithSize:17];
    [_scrollView addSubview:bgv];
    //简介
    _jj = [[UILabel alloc] init];
    _jj.numberOfLines = 0;
    _jj.font = [self getSysFontWithSize:14];
    //功能
    _pl = [[UILabel alloc] init];
    _pl.numberOfLines = 0;
    _pl.font = [self getSysFontWithSize:14];
    //保质期
    _bzq = [[UILabel alloc] init];
    _bzq.numberOfLines = 0;
    _bzq.font = [self getSysFontWithSize:14];

    [_scrollView addSubview:_jj];
    [_scrollView addSubview:_pl];
    [_scrollView addSubview:_bzq];
}
- (void)updateData{
    _titleLb.text = self.data.name;
    //成分

    _jj.text = [NSString stringWithFormat:@"简介:\n%@",[self convertString:self.data.introduction]];
    CGSize cfSize = [self getTextSize:_jj];
    _jj.frame = CGRectMake(10, 50, winSize.width-20, cfSize.height+10);
    NSMutableAttributedString *cfAt = [[NSMutableAttributedString alloc] initWithString:_jj.text];
    [cfAt addAttributes:@{
                          NSFontAttributeName:[self getBoldFontWithSize:17],
                          NSForegroundColorAttributeName:[UIColor orangeColor]
                          } range:NSMakeRange(0, 3)];
    [_jj setAttributedText:cfAt];
    //功能
    
    _pl.text = [NSString stringWithFormat:@"功能:\n%@",[self convertString:self.data.effect]];
    CGSize plSize = [self getTextSize:_pl];
    _pl.frame = CGRectMake(10, 50+_jj.frame.size.height, winSize.width-20, plSize.height+10);
    NSMutableAttributedString *plAt = [[NSMutableAttributedString alloc] initWithString:_pl.text];
    [plAt addAttributes:@{
                          NSFontAttributeName:[self getBoldFontWithSize:17],
                          NSForegroundColorAttributeName:[UIColor orangeColor]
                          } range:NSMakeRange(0, 3)];
    [_pl setAttributedText:plAt];
    
    //重要性
    _bzq.text = [NSString stringWithFormat:@"重要性:\n%@",[self convertString:self.data.cz]];
    CGSize bzqSize = [self getTextSize:_bzq];
    _bzq.frame = CGRectMake(10, _pl.frame.size.height+_pl.frame.origin.y, winSize.width-20, bzqSize.height+10);
    NSMutableAttributedString *bzqAt = [[NSMutableAttributedString alloc] initWithString:_bzq.text];
    [bzqAt addAttributes:@{
                           NSFontAttributeName:[self getBoldFontWithSize:17],
                           NSForegroundColorAttributeName:[UIColor orangeColor]
                           } range:NSMakeRange(0, 4)];
    [_bzq setAttributedText:bzqAt];
    _scrollView.contentSize = CGSizeMake(0, _bzq.frame.origin.y+_bzq.frame.size.height+50);
    
}
- (void)startRequest{
    NSString *url = [NSString stringWithFormat:YYBKDTURL,self.data.name];

    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        NSDictionary *dc = dict[@"data"];
        [self.data setValuesForKeysWithDictionary:dc];
        [self updateData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    [op start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
