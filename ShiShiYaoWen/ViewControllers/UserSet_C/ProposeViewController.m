//
//  ProposeViewController.m
//  ShiShiYaoWen
//
//  Created by Mac on 14/12/19.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ProposeViewController.h"

#define PROPOSEVIEWCONTROLLER @"ProposeViewController"
@interface ProposeViewController ()<UITextViewDelegate>

@end

@implementation ProposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    [titleLabel setText:@"反馈与建议"];
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
    
    
//    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 100, SCREENWIDTH-20, 150)];
//    img.backgroundColor = [UIColor grayColor];
//    img.alpha = 0.1;
//    [self.view addSubview:img];
    
    //输入文本框
    _propseText = [[UITextView alloc] initWithFrame:CGRectMake(10, 100, SCREENWIDTH-20, 150)];
    _propseText.delegate = self;
     [self.view addSubview:_propseText];
    _propseText.backgroundColor = [UIColor clearColor];
//    _propseText.alpha = 0.1;
    label  = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, SCREENWIDTH-20, 30)];
    label.backgroundColor = [UIColor clearColor];
    //字体颜色
    label.textColor = [UIColor lightGrayColor];
    [_propseText addSubview:label];
    
    label.text = @"请输入反馈与建议,我们将为您不断改进";
    //字体
    _propseText.font = [UIFont boldSystemFontOfSize:17.0];
    //对齐
    _propseText.textAlignment = NSTextAlignmentLeft;
    
    //允许编辑
    _propseText.editable = YES;
    //用户交互     /////////////////////若想有滚动条 不能交互 上为No，下为Yes
    _propseText.userInteractionEnabled = YES; ///
    //自定义键盘
    //textView.inputView = view;
    //textView.inputAccessoryView = view;
    _propseText.delegate = self;
    
    _propseText.returnKeyType = UIReturnKeyDefault;//返回键的类型
    
    _propseText.keyboardType = UIKeyboardTypeDefault;//键盘类型
    
    _propseText.scrollEnabled = YES;//是否可以拖动
    
    
    
    _propseText.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [_propseText becomeFirstResponder];
    

    
    
    
    
    //首字母是否大写
    _propseText.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //是否纠错
    _propseText.autocorrectionType = UITextAutocorrectionTypeNo;
    //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
//    _propseText.clearButtonMode = UITextFieldViewModeAlways;
//    _propseText.delegate = self;
    
    //设置边框样式
//    _propseText.borderStyle = UITextBorderStyleRoundedRect;
    //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
//    _propseText.clearButtonMode = UITextFieldViewModeAlways;
//    _propseText.placeholder = @"请输入反馈与建议,我们将为您不断改进";
//    _propseText.font = [UIFont boldSystemFontOfSize:15];
    //内容的垂直对齐方式
//    _propseText.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    
    


   

    //提交Button
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 280, SCREENWIDTH-20, 40);
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setEnabled:NO];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:PROPOSEVIEWCONTROLLER];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:PROPOSEVIEWCONTROLLER];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)buttonAction:(UIButton *)btn
{
    
    

    NSString *url = [NSString stringWithFormat:@"http://ssyw.51yaoshi.com/ssyw/feedback.jspx?ctgId=3&email=shenzl@qq.com&phone=18658160756&qq=645566259&title=1231&content=%@",_propseText.text];
       NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        //NSLog(@"%@",operation.responseString);
        _propseText.text = @"";
        button.enabled = NO;
       // NSString *xPath = [NSString stringWithFormat:@"%@/ssyw/feedback.jspx?",SSYWHTTPHEAD,content];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            _propseText.text = @"";
            button.enabled = NO;
            // NSString *xPath = [NSString stringWithFormat:@"%@/ssyw/feedback.jspx?",SSYWHTTPHEAD,content];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            NSLog(@"请求失败");
        }];

    [op start];
    
   
    

   
    

}

#pragma mark -UITextView
//如果开始编辑状态，则将文本信息设置为空，颜色变为黑色：

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView

{
    
//    _propseText.text=@"";

    _propseText.textColor = [UIColor blackColor];
    
    return YES;
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //判断类型，如果是UITextView类型，收起键盘
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[UITextView class]]) {
            UITextView* tv = (UITextView*)view;
            [tv resignFirstResponder];
        }
    }
}



- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    NSLog(@"开始编辑");
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"结束编辑");
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([@"\n" isEqualToString:text] == YES) {
        [_propseText resignFirstResponder];
        return NO;
    }
    return YES;
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    NSLog(@"已经修改");
    if (_propseText.text !=nil) {
        [button setEnabled:YES];

     
    }
    
//    [button setEnabled:NO];

    [label removeFromSuperview];
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    NSLog(@"textViewDidChangeSelection");
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
