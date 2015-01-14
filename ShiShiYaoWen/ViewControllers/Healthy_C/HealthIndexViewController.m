//
//  HealthIndexViewController.m
//  zixun
//
//  Created by pro on 14/12/5.
//  Copyright (c) 2014年 pro. All rights reserved.
//

#import "HealthIndexViewController.h"
#import "DetailHealthViewController.h"
#import "EncyclopediaViewController.h"
#import "AppDelegate.h"
#import "HeathModel.h"
#import "ZHInformationDetailViewController.h"
#import <UIImageView+AFNetworking.h>
#import "ZHInformationCellModel.h"

#define PATH  @"http://ssyw.51yaoshi.com/ssyw/getCarousel.jspx?channelId=66"

@interface HealthIndexViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    UIImageView *_placeimg;
    UILabel *_nameLb;
    UILabel *_detailLb;
    UIPageControl *_pagecontrol;
    NSMutableArray *_dataArray;
    NSTimer *_timer;
}
@end

@implementation HealthIndexViewController
- (void)dealloc
{
    if (_timer) {
        [_timer invalidate],_timer = nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0x5B5B5B);
    self.navigationItem.title = @"健康索引";
    [self makeView];
    [self startRequest];
    // Do any additional setup after loading the view.
}
//四个按钮点击
- (void)itemClick:(UIButton *)bt{
    if (!([self.navigationController.viewControllers lastObject] == self)) {
        return;
    }
    //添加剂百科 营养成分百科
    if (bt.tag == 0||bt.tag == 3) {
        EncyclopediaViewController *evc = [[EncyclopediaViewController alloc] init];
        evc.type = (int)bt.tag;
        evc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:evc animated:YES];
    }else if(bt.tag == 1||bt.tag == 2){
        //食物营养成分//配料
        DetailHealthViewController *dvc = [[DetailHealthViewController alloc] init];
        dvc.type = (int)bt.tag;
        dvc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dvc animated:YES];
    }
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.homeTabBarControl setTabBarHidden:YES];
}
- (void)startRequest{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:PATH]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding error:nil];
        GDataXMLElement *root = [doc rootElement];
        if (_dataArray == nil) {
            _dataArray = [[NSMutableArray alloc] init];
        }
        for (GDataXMLElement *ele in [root children]) {
            HeathModel *data = [[HeathModel alloc] init];
            for (GDataXMLElement *el in [ele children]) {
                [data setValue:el.stringValue forKey:el.name];
            }
            [_dataArray addObject:data];
            
        }
        [self loadScrollViewData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
        _placeimg.image = [UIImage imageNamed:@"Healty_bg@3x.png"];
    }];
    [op start];
}
- (void)tap:(UITapGestureRecognizer *)tap{
    UIView *v = [tap view];
    HeathModel *model = _dataArray[v.tag];
    if (model) {
        
        ZHInformationCellModel *mod = [[ZHInformationCellModel alloc] init];
        mod.categoryid = model.categoryId;
        mod.categoryname = model.categoryName;
        mod.newsid = model.newsId;
        mod.titleimg = model.titleImg;
        mod.title = model.title;
        mod.descripString = model.descrip;
        mod.contenturl = [NSString stringWithFormat:@"%@:88/ssyw/newscontent/%@",SSYWHTTPHEAD,model.contentUrl];
        mod.contentHtmlUrl = [NSString stringWithFormat:@"%@/ssyw%@",SSYWHTTPHEAD,model.contentHtmlUrl];
        mod.author = model.Author;
        mod.praise = model.praise;
        mod.pubdate = model.pubDate;
        

        ZHInformationDetailViewController *detailViewController = [[ZHInformationDetailViewController alloc] initWithModel:mod];
        [self.navigationController pushViewController:detailViewController animated:YES];
        
        AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        [delegate.homeTabBarControl setTabBarHidden:YES];
        
    }
}
- (void)makeView{
    float tty = (winSize.height-64-49)*0.5;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _nNavOffset, winSize.width, tty-40)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    _placeimg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];

    [_scrollView addSubview:_placeimg];
    [self.view addSubview:_scrollView];
    
    //详情
    UIView *detView = [[UIView alloc] initWithFrame:CGRectMake(0, tty-80+_nNavOffset, winSize.width, 40)];
    _pagecontrol = [[UIPageControl alloc] initWithFrame:CGRectMake(winSize.width-70, 10, 70, 20)];
    _pagecontrol.currentPageIndicatorTintColor = [UIColor orangeColor];
    _pagecontrol.pageIndicatorTintColor = [UIColor whiteColor];
    _pagecontrol.enabled = NO;

    _pagecontrol.numberOfPages = 0;
    [detView addSubview:_pagecontrol];
    detView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _nameLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 250, 25)];
    _nameLb.text = @"素食主义";
    _nameLb.textColor = [UIColor whiteColor];
    _nameLb.font = [UIFont boldSystemFontOfSize:17];
    [detView addSubview:_nameLb];
    _detailLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 24, winSize.width-80, 15)];
    _detailLb.textColor = [UIColor whiteColor];
    _detailLb.text = @"童鞋们,多吃素菜有助于长高哦!";
    _detailLb.font = [UIFont boldSystemFontOfSize:12];
    [detView addSubview:_detailLb];
    [self.view addSubview:detView];
    
    //下部分
    UIView *lview = [[UIView alloc] initWithFrame:CGRectMake(0, tty-40+_nNavOffset, winSize.width, tty+40)];
    lview.backgroundColor = UIColorFromRGB(0x5B5B5B);
    float lx = (winSize.width-40)*0.5;
    float ly = (329.0f/516.0f)*lx;
    float lly = (lview.frame.size.height-2*ly-10)*0.5;
    NSArray *images = @[@"ZH_Healthy_01@3x",@"ZH_Healthy_02@3x",@"ZH_Healthy_03@3x",@"ZH_Healthy_04@3x"];
    for(int i = 0;i< 4;++i){
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        bt.frame = CGRectMake(15+(lx+10)*(i%2), lly+(ly+10)*(i/2), lx, ly);
        [bt setBackgroundImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [lview addSubview:bt];
        bt.tag = i;
        [bt addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.view addSubview:lview];
}
- (void)loadScrollViewData{
    //图片
    for (int i = 0; i < _dataArray.count; i++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(i*_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        HeathModel *data = _dataArray[i];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        img.userInteractionEnabled = YES;
        img.tag = i;
        [img addGestureRecognizer:tap];
        [img setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ssyw.51yaoshi.com%@",data.titleImg]] placeholderImage:[UIImage imageNamed:@"ZH_Download_Image@3x.png"]];
        [_scrollView addSubview:img];
    }
    _scrollView.contentInset = UIEdgeInsetsMake(0, winSize.width, 0, winSize.width);
    UIImageView *left = [[UIImageView alloc] initWithFrame:CGRectMake(-(winSize.width), 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    HeathModel *lData = [_dataArray lastObject];
    [left setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ssyw.51yaoshi.com%@",lData.titleImg]] placeholderImage:[UIImage imageNamed:@"ZH_Download_Image@3x.png"]];
    UIImageView *right = [[UIImageView alloc] initWithFrame:CGRectMake(winSize.width*_dataArray.count, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    HeathModel *rData = [_dataArray firstObject];
    [right setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://ssyw.51yaoshi.com%@",rData.titleImg]] placeholderImage:[UIImage imageNamed:@"ZH_Download_Image@3x.png"]];
    [_scrollView addSubview:left];
    [_scrollView addSubview:right];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(winSize.width*_dataArray.count, 0);
    _pagecontrol.numberOfPages = _dataArray.count;
    _scrollView.pagingEnabled = YES;
    
    _nameLb.text = rData.title;
    _detailLb.text = rData.descrip;
    [self starAutoScoll];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int t = (int)_pagecontrol.numberOfPages;
    if (_scrollView.contentOffset.x<0) {
        _scrollView.contentOffset = CGPointMake(winSize.width*(t-1), 0);
    }else if (_scrollView.contentOffset.x>(t-1)*winSize.width) {
        _scrollView.contentOffset = CGPointMake(0, 0);
    }
    _pagecontrol.currentPage = _scrollView.contentOffset.x/winSize.width;
    HeathModel *data = _dataArray[_pagecontrol.currentPage];
    _nameLb.text = data.title;
    _detailLb.text = data.descrip;
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_timer invalidate],_timer = nil;

}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self starAutoScoll];
}
- (void)starAutoScoll{
    if (_timer) {
        [_timer invalidate],_timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
}
//自动滚动
- (void)autoScroll{
    int t = (int)_pagecontrol.currentPage+1;
    [UIView animateWithDuration:0.5 animations:^{
        _scrollView.contentOffset = CGPointMake(t*winSize.width, 0);
    } completion:^(BOOL finished) {
        if (t >=_pagecontrol.numberOfPages) {
            _scrollView.contentOffset = CGPointMake(0, 0);
        }
    }];
    _pagecontrol.currentPage = t%_pagecontrol.numberOfPages;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *delegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.homeTabBarControl setTabBarHidden:NO];
    self.tabBarController.tabBar.frame = CGRectZero;
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
