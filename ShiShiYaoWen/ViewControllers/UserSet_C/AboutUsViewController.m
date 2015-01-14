//
//  AboutUsViewController.m
//  ShiShiYaoWen
//
//  Created by Mac on 14/12/14.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "AboutUsViewController.h"

#define ABOUTUSVIEWCONTROLLER @"AboutUsViewController"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [titleLabel setText:@"关于我们"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [self.navigationItem setTitleView:titleLabel];
    
    UIButton *backButton = [ZHCustomControl _customUIButtonWithTitle:nil
                                                             andFont:1.0f
                                                       andTitleColor:nil
                                                           andTarget:self
                                                              andSEL:@selector(backClick)
                                                     andControlEvent:UIControlEventTouchUpInside
                                                          andBGImage:[UIImage imageNamed:@"ZH_NavigationBack@3x"]
                                                            andFrame:CGRectMake(0, 0, 28, 30)];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = buttonItem;

    
    _tableView= [[UITableView alloc]initWithFrame:CGRectMake(0,64, self.view.frame.size.width, SCREENHEIGHT-64) style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:ABOUTUSVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:ABOUTUSVIEWCONTROLLER];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 4;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 0) {
//        return 2;
//    }else if(section == 1){
//        
//        return 2;
//    }else if(section == 2){
//        
//        return 12;
//    }

    return 4;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 88;
    }else if (indexPath.row == 1){
        return 88;
    }else if (indexPath.row == 2){
        return 484;
    }
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    
    
    if (indexPath.row == 0) {
        
        
        
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 68)];
        [imgView setImage:[UIImage imageNamed:@"线框1.png"]];
        [cell.contentView addSubview:imgView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 34)];
        lable.text = @"制作单位";
        lable.textAlignment = 1;
        lable.textColor = [UIColor whiteColor];
        
        [imgView addSubview:lable];
        
        UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 34, self.view.frame.size.width, 34)];
        lable1.text = @"国家食品药品监督管理总局";
        lable1.textAlignment = 1;
        lable1.textColor = [UIColor blackColor];
        
        [imgView addSubview:lable1];

        
        
    }else if (indexPath.row == 1) {
        
        
        
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 68)];
        [imgView setImage:[UIImage imageNamed:@"线框1.png"]];
        [cell.contentView addSubview:imgView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 34)];
        lable.text = @"技术支持单位";
        lable.textAlignment = 1;
        lable.textColor = [UIColor whiteColor];
        
        [imgView addSubview:lable];
        
        UILabel *lable1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 34, self.view.frame.size.width, 34)];
        lable1.text = @"药师在线、智汇神州网络科技";
        lable1.textAlignment = 1;
        lable1.textColor = [UIColor blackColor];
        
        [imgView addSubview:lable1];
        
        
        
    }else if (indexPath.row == 2) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 464)];
        [imgView setImage:[UIImage imageNamed:@"线框2.png"]];
        [cell.contentView addSubview:imgView];

        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        lable.text = @"内容支持单位";
        lable.textAlignment = 1;
        lable.textColor = [UIColor whiteColor];
        
        [imgView addSubview:lable];

        
        
        NSArray *array = @[@"中国食品药品检定研究院",@"国家食品安全风险评估中心",@"清华大学健康传播研究院",@"中国食品科学技术学会",@"中国药学会",@"央视网",@"果壳网",@"食品伙伴网",@"《食品指南》杂志社",@"《食品与美酒》杂志社"];
        for (int i=0; i<array.count; i ++) {
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 34 +38*i, self.view.frame.size.width, 54)];

            
            NSString *names = [array objectAtIndex:i];
            [lable setText:names];
            lable.textAlignment = 1;
            lable.textColor = [UIColor blackColor];
            
            [imgView addSubview:lable];

        }
        


    
    }else if (indexPath.row == 3) {
        
        
        
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 34)];
        [imgView setImage:[UIImage imageNamed:@"线框3.png"]];
        [cell.contentView addSubview:imgView];
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 34)];
        lable.text = @"食事药闻V1.0";
        lable.textAlignment = 1;
        lable.textColor = [UIColor whiteColor];
        
        [imgView addSubview:lable];


    }

        return cell;
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
