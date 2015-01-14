//
//  ZHSettingsViewController.m
//  ShiShiYaoWen
//
//  Created by Mac on 14/12/10.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHSettingsViewController.h"
#import "FontViewController.h"
#import "ZHCollectionViewController.h"
#import "AboutUsViewController.h"
#import "AppDelegate.h"
#import "ZHPolularViewController.h"
#import "QuestionViewController.h"
#import "ProposeViewController.h"

#define ZHSETTINGSVIEWCONTROLLER @"ZHSettingsViewController"

@interface ZHSettingsViewController ()
{
    UILabel *lableSize;
}
@end

@implementation ZHSettingsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [titleLabel setText:@"设置"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [self.navigationItem setTitleView:titleLabel];
    
    _tableView= [[UITableView alloc]initWithFrame:CGRectMake(0,_nNavOffset, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
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

    
    //计算本地图片的缓存
    
    [self countCacheSize];
    
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:ZHSETTINGSVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:ZHSETTINGSVIEWCONTROLLER];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

//计算本地缓存

-(void)countCacheSize
{
    NSString *dirHome = [NSHomeDirectory()stringByAppendingPathComponent:@"Library/Caches"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    //取得一个文件夹中所有文件的路径
    NSArray *subPath = [fileManager subpathsOfDirectoryAtPath:dirHome error:nil];
    long long sum = 0;
    for (NSString *filePath in subPath) {
//        NSLog(@"filePath:%@",filePath);
        NSString *path = [dirHome stringByAppendingPathComponent:filePath];
        NSDictionary *attribute = [fileManager attributesOfItemAtPath:path error:nil];
        NSNumber *filesize = attribute[NSFileSize];
        long long size = [filesize longValue];
        sum +=size;
        
    }
    NSString *Documents = [NSHomeDirectory()stringByAppendingPathComponent:@"Documents"];
    
    //    NSString *dirHome =NSHomeDirectory();
    NSFileManager *fileManage = [NSFileManager defaultManager];
    //取得一个文件夹中所有文件的路径
    NSArray *subPat = [fileManage subpathsOfDirectoryAtPath:dirHome error:nil];
    long long sum1 = 0;
    for (NSString *filePath in subPat) {
        //        NSLog(@"filePath:%@",filePath);
        NSString *path = [Documents stringByAppendingPathComponent:filePath];
        NSDictionary *attribute = [fileManager attributesOfItemAtPath:path error:nil];
        NSNumber *filesize = attribute[NSFileSize];
        long long size = [filesize longValue];
        sum1 +=size;
        
    } 

    
    
    _cacheSize = (sum+sum1)/(1024.0*1024);
    
}

//获取Cache目录
-(NSString *)dirCache{
    NSArray *cacPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cacPath objectAtIndex:0];
//    NSLog(@"app_home_lib_cache: %@",cachePath);
    return cachePath;
  
}
//删除文件
-(void)deleteFile{
    NSString *documentsPath =[self dirCache];

    NSFileManager *fileManager = [NSFileManager defaultManager];

    BOOL res=[fileManager removeItemAtPath:documentsPath error:nil];
    if (res) {
        NSLog(@"文件删除成功");
    }else
        NSLog(@"文件删除失败");
//    NSLog(@"文件是否存在: %@",[fileManager isExecutableFileAtPath:documentsPath]?@"YES":@"NO");
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self->_tableView reloadData];
}

#pragma mark -UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        
        return 2;
    }
    return 3;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identify = @"Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    
    if (indexPath.section == 0) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 100, 30)];
        lable.text = @"我的收藏";
        [cell.contentView addSubview:lable];
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 25, 25)];
        [imgView setImage:[UIImage imageNamed:@"ZH_UserSet_Collect.png"]];
        [cell.contentView addSubview:imgView];
        
        
        
        
        
    }else if(indexPath.section == 1){
//        if (indexPath.row == 0) {
//            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 100, 30)];
//            lable.text = @"无图模式";
//            lable.textColor = [UIColor grayColor];
//            [cell.contentView addSubview:lable];
//            
//            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 25, 25)];
//            [imgView setImage:[UIImage imageNamed:@"ZH_UserSet_NImage.png"]];
//            [cell.contentView addSubview:imgView];
//            
////            UISwitch *noImages = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width- 60, 5, 30, 30)];
////            [cell.contentView addSubview:noImages];
////            noImages.onTintColor = [UIColor orangeColor];
//            
////            [noImages addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
////
////            [noImages setOnImage:[UIImage imageNamed:             @"ZH_UserSet_Switch_select@3x.png"]];
////
////            [noImages setOn:YES];
//            
//            UIButton *noImage = [UIButton buttonWithType:UIButtonTypeCustom];
//            noImage.frame = CGRectMake(self.view.frame.size.width- 60, 5, 50, 40);
//            [cell.contentView addSubview:noImage];
////
////            
//            [noImage setBackgroundImage:[UIImage imageNamed:@"ZH_UserSet_Switch_normal@3x.png"]forState:UIControlStateNormal];
////            [noImage setImage:[UIImage imageNamed:@"ZH_UserSet_Switch_select@3x.png"] forState:UIControlStateSelected];
////            noImage.highlighted = NO;
//            
//            
//            
//        }else
            if(indexPath.row == 0){
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 100, 30)];
            lable.text = @"正文字号";
            [cell.contentView addSubview:lable];
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 25, 25)];
            [imgView setImage:[UIImage imageNamed:@"ZH_UserSet_Typeface.png"]];
            [cell.contentView addSubview:imgView];
            
            
            
            
            
            
            
//            button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.frame = CGRectMake(300,5 , 30, 30);
//            //            button.backgroundColor = [UIColor cyanColor];
//            [button setTitle:@"大" forState:UIControlStateNormal];
//            button.titleLabel.font = [UIFont systemFontOfSize:17];
//            
//            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//            
//            [cell.contentView addSubview:button];
            
            if (lableSize == nil) {
                lableSize = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width- 60, 5, 30, 30)];
            }
            int t = ((AppDelegate *)([UIApplication sharedApplication].delegate)).fontSize;
            if (t == 3) {
                lableSize.text = @"大";
            }else if (t == 0) {
                lableSize.text = @"中";
            }else if (t == -3){
                lableSize.text = @"小";
            }
            [cell.contentView addSubview:lableSize];

            
            
            
            
            
            
            
            
            
            
            
        }else if(indexPath.row == 1){
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 100, 30)];
            lable.text = @"清理缓存";
            [cell.contentView addSubview:lable];
            
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 25, 25)];
            [imgView setImage:[UIImage imageNamed:@"ZH_UserSet_Clear.png"]];
            
            
            [cell.contentView addSubview:imgView];
           

        }
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 25, 25)];
            [imgView setImage:[UIImage imageNamed:@"ZH_UserSet_Propose"]];
            [cell.contentView addSubview:imgView];
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 100, 30)];
            lable.text = @"反馈与建议";
            
            [cell.contentView addSubview:lable];
            
        }else if(indexPath.row == 1){
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 25, 25)];
            [imgView setImage:[UIImage imageNamed:@"ZH_UserSet_Question"]];
            [cell.contentView addSubview:imgView];
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 100, 30)];
            lable.text = @"常见问题";
            [cell.contentView addSubview:lable];
            
        }
//        else if(indexPath.row == 2){
//            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 25, 25)];
//            [imgView setImage:[UIImage imageNamed:@"ZH_UserSet_Recommend"]];
//            [cell.contentView addSubview:imgView];
//            
//            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 100, 30)];
//            lable.text = @"推荐应用";
//            [cell.contentView addSubview:lable];
            
//        }
         else if(indexPath.row == 2){
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 25, 25)];
            [imgView setImage:[UIImage imageNamed:@"ZH_UserSet_US"]];
            [cell.contentView addSubview:imgView];
            
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 100, 30)];
            lable.text = @"关于我们";
            [cell.contentView addSubview:lable];
        }
        
        
        
    }
    
    
    
    
    return cell;
}
//-(void)buttonAction:(UIButton *)btn
//{
//    if ( [btn.titleLabel.text  isEqual: @"大"]) {
//        [btn setTitle:@"小" forState:UIControlStateNormal];
//        
//        
//        
//    }else if([btn.titleLabel.text  isEqual: @"小"])
//    {
//        [btn setTitle:@"大" forState:UIControlStateNormal];
//    }
//    
//}
-(void)switchAction:(id)sender
{
//    UISwitch *switchButton = (UISwitch*)sender;
//    BOOL isButtonOn = [switchButton isOn];
//    if (isButtonOn) {
//        NSLog(@"无图");
//    }else {
//        NSLog(@"有图");
//    }
}

- (void)setOn:(BOOL)on animated:(BOOL)animated
{
    
    
    
}
//当cell在屏幕上展示的时候调用

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        [self countCacheSize];
        
        if (_cacheLabel == nil) {
            _cacheLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width- 60, 5, 50, 30)];
        }
        
        [cell.contentView addSubview:_cacheLabel];
               _cacheLabel.text = [NSString stringWithFormat:@"%.2fM",_cacheSize];
        NSLog(@"缓存大小:%f",_cacheSize);
        
        
    }
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 1) {
        //清除缓存时弹出对话框
//        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"清空缓存" message:@"确定要清空缓存?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        HJAlertView *alerView = [[HJAlertView alloc] initWithTitle:@"清空缓存" andMessage:@"确定要清空缓存?" andDelegate:self andAddInfo:nil andButtonColor:[UIColor blueColor] andButtonTitles:@"取消",@"确定",nil];
        [alerView setTag:10001];
        [alerView show];
        
        
    }else if(indexPath.section ==1 && indexPath.row == 0){
        FontViewController *fontVC = [[FontViewController alloc] init];
        [self.navigationController pushViewController:fontVC animated:YES];
        
    }else if(indexPath.section ==0){
        ZHCollectionViewController *collectionVC = [[ZHCollectionViewController alloc] init];
        [self.navigationController pushViewController:collectionVC animated:YES];
        
    }else if(indexPath.section ==2 && indexPath.row == 2){
        AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] init];
        [self.navigationController pushViewController:aboutUsVC animated:YES];
    }else if(indexPath.section ==2 && indexPath.row == 1){
        QuestionViewController *qusetionVC = [[QuestionViewController alloc] init];
        [self.navigationController pushViewController:qusetionVC animated:YES];
    }else if(indexPath.section ==2 && indexPath.row == 0){
        ProposeViewController *proposeVC = [[ProposeViewController alloc] init];
        [self.navigationController pushViewController:proposeVC animated:YES];
    }



    
    
}

- (void)HJalertView:(HJAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex AddInformation:(id)addInfo
{
    if (alertView.tag == 10001 && [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确定"]) {
        //清除缓存的方法
        
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [ZHCoreDataManage removeAllModelCache];
        [ZHPolularViewController deleteCache];
        
        [self dirCache];
        [self deleteFile];
//        NSString *documentsPath =[self dirCache];
//        
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        
//        BOOL res=[fileManager removeItemAtPath:documentsPath error:nil];
//        if (res) {
//            NSLog(@"文件删除成功");
//        }else
//            NSLog(@"文件删除失败");
//        NSLog(@"文件是否存在: %@",[fileManager isExecutableFileAtPath:documentsPath]?@"YES":@"NO");

       
    }
    [_tableView reloadData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
