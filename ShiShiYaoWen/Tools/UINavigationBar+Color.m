//
//  UINavigationBar+Color.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/9.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "UINavigationBar+Color.h"

@implementation UINavigationBar (Color)

- (void)setG3DefaultColor:(UIImage *)imageBar
{
    if(nil==imageBar)
    {
        imageBar =[self createImageWithColor:[UIColor blueColor]];
    }
    
    [self setShadowImage:[UIImage new]];//去掉下边的那条线
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] <7.0)
    {
        UIGraphicsBeginImageContext(CGSizeMake(320, 44));
        [imageBar drawInRect:CGRectMake(0, 0, 320, 44)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self setBackgroundImage:scaledImage forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        UIGraphicsBeginImageContext(CGSizeMake(320, 64));
        [imageBar drawInRect:CGRectMake(0, 0, 320, 64)];
        UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self setBackgroundImage:scaledImage forBarMetrics:UIBarMetricsDefault];
    }
    NSDictionary *navTitleArr = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [UIFont boldSystemFontOfSize:20],UITextAttributeFont,
                                 [UIColor whiteColor],UITextAttributeTextColor ,
                                 [NSValue valueWithCGSize:CGSizeMake(2.0, 2.0)] , UITextAttributeTextShadowOffset ,
                                 [UIColor clearColor] ,UITextAttributeTextShadowColor ,
                                 nil];
    [self setTitleTextAttributes:navTitleArr];
}

-(UIImage *) createImageWithColor: (UIColor *) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
