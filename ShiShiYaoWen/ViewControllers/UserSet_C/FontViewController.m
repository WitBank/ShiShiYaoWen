//
//  FontViewController.m
//  shiyaowen
//
//  Created by Mac on 14/12/10.
//  Copyright (c) 2014年 PengLi. All rights reserved.
//

#import "FontViewController.h"
#import "AppDelegate.h"

#define FONTVIEWCONTROLLER @"FontViewController"

@interface FontViewController ()
{
    int _fontSize;
    UITableViewCell *selectCell;
}
@end

@implementation FontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *fontSize = [ud objectForKey:@"fontSize"];
    if (fontSize==nil) {
        _fontSize = 0;
    }else{
        
        _fontSize = [fontSize intValue];
    }
    // Do any additional setup after loading the view from its nib.

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [titleLabel setText:@"正文字号"];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [self.navigationItem setTitleView:titleLabel];
    _tableView= [[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
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

    
    

    [self saveNSUserDefaults];
    [self readNSUserDefaults];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:FONTVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:FONTVIEWCONTROLLER];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

NSInteger bigSize = 2;
NSInteger mediumSize = 0;
NSInteger littleSize = -2;

-(void)saveNSUserDefaults
{
    NSUserDefaults *userDefahlts = [NSUserDefaults standardUserDefaults];
    [userDefahlts setInteger:bigSize forKey:@"bigSize"];
    [userDefahlts setInteger:mediumSize forKey:@"mediumSize"];
    [userDefahlts setInteger:littleSize forKey:@"littleSize"];
    
    
    
}
-(void)readNSUserDefaults
{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSInteger big = [userDefaults integerForKey:@"bigSize"];
//    NSInteger medium = [userDefaults integerForKey:@"mediuSize"];
//    NSInteger little = [userDefaults integerForKey:@"littleSize"];
//
    
}
#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"kIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中cell时无色
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger big = [userDefaults integerForKey:@"bigSize"];
    NSInteger medium = [userDefaults integerForKey:@"mediuSize"];
    NSInteger little = [userDefaults integerForKey:@"littleSize"];

    
    if (indexPath.row == 0) {
        bigLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 5, 100, 30)];
        bigLabel.text = @"大";
        bigLabel.font = [UIFont fontWithName:nil size:17+big];
        
        [cell.contentView addSubview:bigLabel];
        if (_fontSize == 3) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            selectCell = cell;
        }
    }else if (indexPath.row == 1) {
        mediumLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 5, 100, 30)];
        mediumLabel.text = @"中";
        mediumLabel.font = [UIFont fontWithName:nil size:17+medium];
        if (_fontSize == 0) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            selectCell = cell;
        }

        [cell.contentView addSubview:mediumLabel];
    }else if (indexPath.row == 2) {
         littleLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 5, 100, 30)];
        littleLabel.text = @"小";
        littleLabel.font = [UIFont fontWithName:nil size:17+little];
        [cell.contentView addSubview:littleLabel];
        if (_fontSize == -3) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            selectCell = cell;
        }
    }

   
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectCell.accessoryType =UITableViewCellAccessoryNone;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    //1.获取到当前字体

    
    //2.修改当前字体

    
    //3.刷新列表
   // [tableView reloadData];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *st = @"0";
    if (indexPath.row == 0) {
        st = @"3";
    }else if(indexPath.row == 1){
        st = @"0";
    }else if(indexPath.row == 2){
        st = @"-3";
    }
    [ud setObject:st forKey:@"fontSize"];
    [ud synchronize];
    ((AppDelegate *)([UIApplication sharedApplication].delegate)).fontSize = [st floatValue];
    
    //通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FontSizeNotification" object:st];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
}
- (void)dealloc{

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
