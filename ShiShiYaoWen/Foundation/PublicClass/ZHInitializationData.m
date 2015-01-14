//
//  ZHInitializationData.m
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/16.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#import "ZHInitializationData.h"
#import "HJAlertView.h"

@implementation ZHInitializationData

- (NSArray *)returnCacheTitle
{
    return [ZHCoreDataManage getInformationTitleModelArray];
}

- (void)initializationData
{
    HJSTK_Reachability *reach = [HJSTK_Reachability reachabilityWithHostName:@"www.baidu.com"];
    if(HJSTK_NotReachable == [reach currentReachabilityStatus])//没有网络
    {
        HJAlertView *alert=[[HJAlertView alloc] initWithTitle:nil message:@"网络错误，为保证正常使用，请检查手机网络设置或尝试重启手机" delegate:self addInfo:nil buttonTitles:@"我知道了",nil];
        alert.tag=4;
        [alert show];
    }
    else//有网，连接初始化服务失败
    {
        HJAlertView *alert=[[HJAlertView alloc] initWithTitle:nil message:@"网络不佳，为保证正常使用，请重试" delegate:self addInfo:nil buttonTitles:@"我知道了",@"重试",nil];
        alert.tag=3;
        [alert show];
    }
}

- (void)RequestTitleData:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObject:@"text/html"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:[NSString stringWithFormat:@"%@/ssyw/getChannel.jspx",SSYWHTTPHEAD] parameters:self success:^(AFHTTPRequestOperation *operation, id responseObject) {
        GDataXMLDocument *rootDocument = [[GDataXMLDocument alloc] initWithHTMLString:operation.responseString error:nil];
        NSArray *array = [rootDocument nodesForXPath:@"//list" error:nil];
        GDataXMLElement *categroyEle = [array objectAtIndex:0];
        NSArray *categroyArray = [categroyEle nodesForXPath:@"//category" error:nil];
        NSMutableArray *titlaArray = [[NSMutableArray alloc] init];
        if ([categroyArray count] > 0) {
            [ZHCoreDataManage removeInformationTitleModel];
        }
        for (int i = 0 ; i<[categroyArray count]; i++) {
            GDataXMLElement *ele = [categroyArray objectAtIndex:i];
            ZHTitleModel *model = [[ZHTitleModel alloc] init];
            model.titleName = [[[ele nodesForXPath:@"name" error:nil] lastObject] stringValue];
            model.titleId = [[[ele nodesForXPath:@"id" error:nil] lastObject] stringValue];
            [titlaArray addObject:model];
            [ZHCoreDataManage saveInformationTitleModel:model];
        }
        if (success) {
            success(titlaArray);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (NSArray *)getImageDataWithTitleArray:(NSArray *)titleArray
{
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    NSMutableArray *oldImageArray = [NSMutableArray arrayWithArray:[ZHCoreDataManage getInformationImageModelArray]];
    for (int i = 0; i < [oldImageArray count]; i++) {
        ZHInformationSCVImageModel *imageModel = [oldImageArray objectAtIndex:i];
        ZHInformationSCVImageModel *model = [[ZHInformationSCVImageModel alloc] init];
        model.categoryName = imageModel.categoryName;
        model.categoryId = imageModel.categoryId;
        model.newsId = imageModel.newsId;
        model.title = imageModel.title;
        model.descrip = imageModel.descrip;
        model.contentUrl = imageModel.contentUrl;
        model.Author = imageModel.Author;
        model.praise = imageModel.praise;
        model.titleImg = imageModel.titleImg;
        model.pubDate = imageModel.pubDate;
        model.contentHtmlUrl = imageModel.contentHtmlUrl;
        model.belittle = imageModel.belittle;
        [imageArray addObject:model];
    }
    return imageArray;
}

- (NSArray *)getNewsDataWithTitleArray:(NSArray *)titleArray
{
    NSMutableArray *newsArray = [[NSMutableArray alloc] init];
    NSMutableArray *oldNewsArray = [NSMutableArray arrayWithArray:[ZHCoreDataManage getAllInformationCellModel]];
    for (ZHTitleModel *titleModel in titleArray) {
        NSMutableArray *subNewsArray = [[NSMutableArray alloc] init];
        for (int i = 0; i<[oldNewsArray count]; i++) {
            ZHInformationCellModel *cellModel = [oldNewsArray objectAtIndex:i];
            if ([cellModel.categoryid isEqualToString:titleModel.titleId]) {
                ZHInformationCellModel *model = [[ZHInformationCellModel alloc] init];
                model.categoryname = cellModel.categoryname;
                model.categoryid = cellModel.categoryid;
                model.newsid = cellModel.newsid;
                model.title = cellModel.title;
                model.descripString = cellModel.descripString;
                model.contentString = cellModel.contentString;
                model.contenturl = cellModel.contenturl;
                model.author = cellModel.author;
                model.praise = cellModel.praise;
                model.titleimg = cellModel.titleimg;
                model.pubdate = cellModel.pubdate;
                model.contentHtmlUrl = cellModel.contentHtmlUrl;
                model.belittle = cellModel.belittle;
                [subNewsArray addObject:model];
                [oldNewsArray removeObjectAtIndex:i];
                i--;
            }
        }
        [newsArray addObject:subNewsArray];
    }
    return newsArray;
}

@end
