//
//  SCDetailViewController.m
//  ShiShiYaoWen
//
//  Created by pro on 14/12/13.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "SCDetailViewController.h"
#import "TJJDTViewController.h"

@interface SCDetailViewController ()
{
    UILabel *_titleLb;
    UILabel *_cf;
    UILabel *_pl;
    UILabel *_bzq;
    UILabel *_bk;
    UIView *_bkView;
    HealthSCModel *_currenData;
    UIScrollView *_scrollView;
}
@end

@implementation SCDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBack];
    self.title = @"详情";

    [self makeView];
    [self startRequest];

    // Do any additional setup after loading the view from its nib.
}

- (void)startRequest{
    NSString *url = [NSString stringWithFormat:PLDTURL,self.data.itemid];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        _currenData = [[HealthSCModel alloc] init];
        [_currenData setValuesForKeysWithDictionary:dict[@"data"]];
        [self updateData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    [op start];
}
//相关百科点击
- (void)bkClick:(UIButton *)bt{
    TJJDTViewController *tjj = [[TJJDTViewController alloc] init];
    tjj.Sid = [NSString stringWithFormat:@"%d",(int)bt.tag];
    [self.navigationController pushViewController:tjj animated:YES];
}
//更新数据
- (void)updateData{
    _titleLb.text = _currenData.title;
    //成分
    _cf.text = [NSString stringWithFormat:@"成分:\n%@",[self convertString:_currenData.chengfen]];
    CGSize cfSize = [self getTextSize:_cf];
    _cf.frame = CGRectMake(10, 50, winSize.width-20, cfSize.height+10);
    NSMutableAttributedString *cfAt = [[NSMutableAttributedString alloc] initWithString:_cf.text];
    [cfAt addAttributes:@{
                          NSFontAttributeName:[self getBoldFontWithSize:17],
                          NSForegroundColorAttributeName:[UIColor orangeColor]
                          } range:NSMakeRange(0, 3)];
    [_cf setAttributedText:cfAt];
    //配料
    _pl.text = [NSString stringWithFormat:@"配料:\n%@",[self convertString:_currenData.peiliao]];
    CGSize plSize = [self getTextSize:_pl];
    _pl.frame = CGRectMake(10, 50+_cf.frame.size.height, winSize.width-20, plSize.height+10);
    NSMutableAttributedString *plAt = [[NSMutableAttributedString alloc] initWithString:_pl.text];
    [plAt addAttributes:@{
                          NSFontAttributeName:[self getBoldFontWithSize:17],
                          NSForegroundColorAttributeName:[UIColor orangeColor]
                          } range:NSMakeRange(0, 3)];
    [_pl setAttributedText:plAt];
    
    //保质期
    _bzq.text = [NSString stringWithFormat:@"保质期:\n%@",[self convertString:_currenData.bzq]];
    CGSize bzqSize = [self getTextSize:_bzq];
    _bzq.frame = CGRectMake(10, _pl.frame.size.height+_pl.frame.origin.y, winSize.width-20, bzqSize.height+10);
    NSMutableAttributedString *bzqAt = [[NSMutableAttributedString alloc] initWithString:_bzq.text];
    [bzqAt addAttributes:@{
                          NSFontAttributeName:[self getBoldFontWithSize:17],
                          NSForegroundColorAttributeName:[UIColor orangeColor]
                          } range:NSMakeRange(0, 4)];
    [_bzq setAttributedText:bzqAt];
    
    //相关知识百科
    _bk.frame = CGRectMake(10, _bzq.frame.origin.y+_bzq.frame.size.height, winSize.width-20, 40);
    _bk.font =[self getBoldFontWithSize:17];
    _bk.textColor = [UIColor orangeColor];
    _bk.text = @"相关知识百科:";
    float tx = 0,ty = 0;
    float ttx = 0;
    float tth = 0;
    for (int i = 0; i<_currenData.additives.count; i++) {
        NSDictionary *dc = _currenData.additives[i];
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        bt.titleLabel.font = [self getSysFontWithSize:15];
        [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [bt setTitle:dc[@"name"] forState:UIControlStateNormal];
        bt.tag = [dc[@"id"] intValue];
        CGSize size = [self getButtonSize:bt];
        bt.backgroundColor = UIColorFromRGB(0xE2E2E2);
        if ((tx+size.width+20)>(winSize.width-30)) {
            tx = 0;
            ty += 35;
        }
        if (tx == 0) {
            ttx = 0;
        }else{
            ttx = 10;
        }
        bt.frame = CGRectMake(tx+ttx, ty, size.width+20, 25);
        [_bkView addSubview:bt];
        [bt addTarget:self action:@selector(bkClick:) forControlEvents:UIControlEventTouchUpInside];
        tx = bt.frame.origin.x+bt.frame.size.width;
        tth = bt.frame.origin.y+bt.frame.size.height;
    }
    _bkView.frame = CGRectMake(10, _bk.frame.origin.y+_bk.frame.size.height, winSize.width-20, tth);

    _scrollView.contentSize = CGSizeMake(0, _bkView.frame.origin.y+_bkView.frame.size.height+50);
}

- (CGSize)getButtonSize:(UIButton *)bt{
    CGSize size =[bt.titleLabel.text boundingRectWithSize:CGSizeMake(winSize.width-20, 1000) options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:bt.titleLabel.font} context:nil].size;
    return size;
}
- (void)makeView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _nNavOffset, winSize.width, winSize.height - 64)];
    [self.view addSubview:_scrollView];
    //头部
    _titleLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, winSize.width-20, 50)];
    _titleLb.adjustsFontSizeToFitWidth = YES;
    UIImageView *bgv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, winSize.width, 50)];
    bgv.backgroundColor = UIColorFromRGB(0xE2E2E2);
    [bgv addSubview:_titleLb];
    _titleLb.numberOfLines = 0;
    _titleLb.font = [self getBoldFontWithSize:17];
    [_scrollView addSubview:bgv];
    //成分
    _cf = [[UILabel alloc] init];
    _cf.numberOfLines = 0;
    _cf.font = [self getSysFontWithSize:14];
    //配料
    _pl = [[UILabel alloc] init];
    _pl.numberOfLines = 0;
    _pl.font = [self getSysFontWithSize:14];
    //保质期
    _bzq = [[UILabel alloc] init];
    _bzq.numberOfLines = 0;
    _bzq.font = [self getSysFontWithSize:14];
    //相关知识百科
    _bk = [[UILabel alloc] init];
    _bkView = [[UIView alloc] init];
    [_scrollView addSubview:_bk];
    [_scrollView addSubview:_bkView];
    [_scrollView addSubview:_cf];
    [_scrollView addSubview:_pl];
    [_scrollView addSubview:_bzq];
    
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
