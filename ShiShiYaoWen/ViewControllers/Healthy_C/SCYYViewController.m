//
//  SCYYViewController.m
//  ShiShiYaoWen
//
//  Created by pro on 14/12/14.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "SCYYViewController.h"

@interface SCYYViewController ()
{
    UIScrollView *_scrollView;
    UILabel *_titleLb;
    UITextView *_detailView;
}
@property (nonatomic,retain)NSDictionary *dc;
@end

@implementation SCYYViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBack];
    self.title = @"详情";
    [self makeView];
    [self starRequest];
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
    _titleLb.font = [self getBoldFontWithSize:17];
    [_scrollView addSubview:bgv];
    
     _detailView = [[UITextView alloc] initWithFrame:CGRectMake(10, 60, winSize.width-20, winSize.height-70-64)];
    _detailView.layer.borderColor = [UIColorFromRGB(0xE2E2E2) CGColor];
    _detailView.layer.borderWidth = 1;
    _detailView.editable = NO;
    _detailView.font = [self getSysFontWithSize:14];
    [_scrollView addSubview:_detailView];
    
}
- (void)updateData{
    _titleLb.text = _dc[@"name"];
    NSDictionary *dic = @{
                         @"reliang":@"热量(千卡)",
                         @"liuan":@"硫胺素(毫克)",
                         @"gai":@"钙(毫克)",
                         @"danbai":@"蛋白质(克)",
                         @"hehuang":@"核黄素(毫克)",
                         @"mei":@"镁(毫克)",
                         @"zhifang":@"脂肪(克)",
                         @"yanshuan":@"烟酸(毫克)",
                         @"tie":@"铁(毫克)",
                         @"tanshui":@"碳水化合物(克)",
                         @"vc":@"维生素C(毫克)",
                         @"meng":@"锰(毫克)",
                         @"shanshi":@"膳食纤维(克)",
                         @"ve":@"维生素E(毫克)",
                         @"xing":@"锌(毫克)",
                         @"va":@"维生素A(微克)",
                         @"dangu":@"胆固醇(毫克)",
                         @"tong":@"铜(毫克)",
                         @"huluobu":@"胡罗卜素(微克)",
                         @"jia":@"钾(毫克)",
                         @"ling":@"磷(毫克)",
                         @"shihuangcuen":@"视黄醇当量(微克)",
                         @"na":@"钠(毫克)",
                         @"sai":@"硒(微克)",
                         };
    NSMutableString *string = [NSMutableString string];
    for (NSString *st in dic) {
        [string appendFormat:@"  %@ : %@\n",dic[st],_dc[st]];
    }
    _detailView.text = [NSString stringWithFormat:@"%@",string];
}
- (void)starRequest{
    NSString *url = [NSString stringWithFormat:CFDTURL,self.data.Sid];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
        self.dc = dict[@"data"];
        [self updateData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
    }];
    [op start];

}
- (NSString *)getString:(NSString *)st{
    NSDictionary *dc = @{
    @"reliang":@"热量(千卡)",
    @"liuan":@"硫胺素(毫克)",
    @"gai":@"钙(毫克)",
    @"danbai":@"蛋白质(克)",
    @"hehuang":@"核黄素(毫克)",
    @"mei":@"镁(毫克)",
    @"zhifang":@"脂肪(克)",
    @"yanshuan":@"烟酸(毫克)",
    @"tie":@"铁(毫克)",
    @"tanshui":@"碳水化合物(克)",
    @"vc":@"维生素C(毫克)",
    @"meng":@"锰(毫克)",
    @"shanshi":@"膳食纤维(克)",
    @"ve":@"维生素E(毫克)",
    @"xing":@"锌(毫克)",
    @"va":@"维生素A(微克)",
    @"dangu":@"胆固醇(毫克)",
    @"tong":@"铜(毫克)",
    @"huluobu":@"胡罗卜素(微克)",
    @"jia":@"钾(毫克)",
    @"ling":@"磷(毫克)",
    @"shihuangcuen":@"视黄醇当量(微克)",
    @"na":@"钠(毫克)",
    @"sai":@"硒(微克)",
    };
    return dc[st];
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
