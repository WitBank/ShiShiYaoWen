//
//  ZHHomeViewController.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/8.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHHomeViewController.h"
#import "ZHCustomControl.h"

#define ZHHOMEVIEWCONTROLLER @"ZHHomeViewController"

@interface ZHHomeViewController ()

@end

@implementation ZHHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _titleNameArray = [[NSMutableArray alloc] init];
    _normalImageArray = [[NSMutableArray alloc] init];
    _selectImageArray = [[NSMutableArray alloc] init];
    
    _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 49*WIDTHPROPORTION, self.view.frame.size.width, 49*WIDTHPROPORTION)];
    [_tabbarView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:_tabbarView];
    
    [self addAllViewControllerArray];
    [self showTabBarView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:ZHHOMEVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:ZHHOMEVIEWCONTROLLER];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)setTabBarHidden:(BOOL)isHidden
{
    if (isHidden == YES) {
        [self hideTabBar];
    }else{
        [self showTabBar];
    }
}

- (void)hideTabBar {
//    [UIView animateWithDuration:0.35
//                     animations:^{
//                         CGRect tabFrame = _tabbarView.frame;
//                         tabFrame.origin.y = tabFrame.origin.y + 50;
//                         _tabbarView.frame = tabFrame;
//                     }];
    CGRect rect = _tabbarView.frame;
    [UIView animateWithDuration:0.35f animations:^{
        [_tabbarView setFrame:rect];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.35f animations:^{
            [_tabbarView setFrame:CGRectMake(0,
                                             SCREENHEIGHT,
                                             self.view.frame.size.width,
                                             49*WIDTHPROPORTION)];
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)showTabBar {
//    [UIView animateWithDuration:0.35
//                     animations:^{
//                         CGRect tabFrame = _tabbarView.frame;
//                         tabFrame.origin.y = tabFrame.origin.y - 50;
////                         tabFrame.origin.x = CGRectGetWidth(tabFrame) + CGRectGetMinX(tabFrame);
//                         _tabbarView.frame = tabFrame;
//                     }];
    CGRect rect = _tabbarView.frame;
    [UIView animateWithDuration:0.35f animations:^{
        [_tabbarView setFrame:rect];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.35 animations:^{
            [_tabbarView setFrame:CGRectMake(0,
                                             SCREENHEIGHT - 49*WIDTHPROPORTION,
                                             self.view.frame.size.width,
                                             49*WIDTHPROPORTION)];
        } completion:^(BOOL finished) {
            
        }];
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)addAllViewControllerArray
{
    [self.navigationController.navigationBar setBackgroundColor:[UIColor redColor]];
    //用plist中的信息
    NSString *controlPath = [[NSBundle mainBundle] pathForResource:@"ControllersData" ofType:@"plist"];
    NSArray *itemArray = [NSArray arrayWithContentsOfFile:controlPath];
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (int i = 0; i < [itemArray count]; i++) {
        NSString *className = [[itemArray objectAtIndex:i] objectForKey:@"ClassName"];
        if (className == nil) {
            continue;
        }
        id classs = [[NSClassFromString(className) alloc] init];
        NSString *imageString = [[itemArray objectAtIndex:i] objectForKey:@"imageString"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:classs];
        [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ZH_NavigationBKGround_orange@3x"] forBarMetrics:UIBarMetricsDefault];
        [navigationController.tabBarItem setTitle:[[itemArray objectAtIndex:i] objectForKey:@"nameString"]];
        [_titleNameArray addObject:[[itemArray objectAtIndex:i] objectForKey:@"nameString"]];
        [_normalImageArray addObject:[NSString stringWithFormat:@"%@normal@3x",imageString]];
        [_selectImageArray addObject:[NSString stringWithFormat:@"%@select@3x",imageString]];
        [controllers addObject:navigationController];
    }
    self.viewControllers = controllers;
    self.tabBar.frame = CGRectMake(-500, -600, 320, 44);
}

- (void)showTabBarView
{
    
    CGFloat tabWidth = SCREENWIDTH/4;
    for (int i = 0; i < [_normalImageArray count]; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((tabWidth*i)+((tabWidth-23*WIDTHPROPORTION)/2), (49-23-18)*WIDTHPROPORTION, 23*WIDTHPROPORTION, 23*WIDTHPROPORTION)];
        [imageView setTag:2000+i];
        [imageView setImage:[UIImage imageNamed:[_normalImageArray objectAtIndex:i]]];
        [_tabbarView addSubview:imageView];
        UILabel *titleLbale = [ZHCustomControl _customLabelWithTitle:[_titleNameArray objectAtIndex:i]
                                                             andFont:12.0f
                                                       andTitleColor:[UIColor whiteColor]
                                                            andFrame:CGRectMake(tabWidth * i,
                                                                                31*WIDTHPROPORTION,
                                                                                tabWidth,
                                                                                18*WIDTHPROPORTION)];
        [titleLbale setTextAlignment:NSTextAlignmentCenter];
        [titleLbale setTag:3000+i];
        [_tabbarView addSubview:titleLbale];
        UIButton *button = [ZHCustomControl _customUIButtonWithTitle:nil
                                                             andFont:13.0f
                                                       andTitleColor:[UIColor clearColor]
                                                           andTarget:self
                                                              andSEL:@selector(tabbarClicked:)
                                                     andControlEvent:UIControlEventTouchUpInside
                                                          andBGImage:nil
                                                            andFrame:CGRectMake(tabWidth * i,0, tabWidth, 49*WIDTHPROPORTION)];
        [button setTag:1000+i];
        [_tabbarView addSubview:button];
        if (i == 0) {
            [imageView setImage:[UIImage imageNamed:[_selectImageArray objectAtIndex:i]]];
            [titleLbale setTextColor:[UIColor orangeColor]];
//            [button setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.15]];
        }
    }
    
}

- (void)tabbarClicked:(UIButton *)btn
{
    for (int i = 0; i < [_normalImageArray count]; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:1000+i];
        if (btn.tag == button.tag) {
//            [button setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.15]];
            UIImageView *imageView = (UIImageView *)[self.view viewWithTag:2000+i];
            [imageView setImage:[UIImage imageNamed:[_selectImageArray objectAtIndex:i]]];
            UILabel *titleLabel = (UILabel *)[self.view viewWithTag:3000+i];
            [titleLabel setTextColor:[UIColor orangeColor]];
        }else{
            [button setBackgroundColor:[UIColor clearColor]];
            UIImageView *imageView = (UIImageView *)[self.view viewWithTag:2000+i];
            [imageView setImage:[UIImage imageNamed:[_normalImageArray objectAtIndex:i]]];
            UILabel *titleLabel = (UILabel *)[self.view viewWithTag:3000+i];
            [titleLabel setTextColor:[UIColor whiteColor]];
        }
    }
    [self setSelectedIndex:btn.tag-1000];
}

@end
