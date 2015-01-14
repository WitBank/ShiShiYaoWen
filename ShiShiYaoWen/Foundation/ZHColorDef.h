//
//  ZHColorDef.h
//  ShiShiYaoWen
//
//  Created by HuXin on 14/12/20.
//  Copyright (c) 2014年 Huxin. All rights reserved.
//

#ifndef ShiShiYaoWen_ZHColorDef_h
#define ShiShiYaoWen_ZHColorDef_h

#define HEXCOLOR(rgbValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])
#define HJCOLORRED          HEXCOLOR(0xf1453b)//红色
#define HJCOLORGREEN        HEXCOLOR(0x2dcc70)//绿
#define HJCOLORGRAY         HEXCOLOR(0xa3a2a2)//灰

#define HJCOLORTITLEGRAY    HEXCOLOR(0x5a5959)//字体灰 股票名称的代码或者偏要设置下边的说明，以及更多首页“当前券商的文字”
#define HJCOLORFIELDGRAY    HEXCOLOR(0x888888)//浅灰色字体颜色     888888   请输入相关的
//灰色按钮颜色  cccccc

#define HJCOLORBLUE         HEXCOLOR(0x157dfb)//所有的蓝色的字
#define HJCOLORBACK         HEXCOLOR(0xf0eff4)//页面的背景颜色
#define HJCOLORLINE        HEXCOLOR(0xd7d7d7)//线的颜色   所有线的颜色

/* 所有红色都为   f1453b
 蓝色  157dfb
 绿色   2dcc70
 白色界面上线的颜色   d7d7d7  （新）
 
 浅灰色字体颜色     888888   请输入相关的
 深灰色字体颜色  5a5959   股票名称的代码或者偏要设置下边的说明，以及更多首页“当前券商的文字”
 更深灰字体颜色  323232  先忽略
 灰色按钮颜色  cccccc
 软件背景色   f0eff4
 红色按钮点击颜色  da2d23
 系统绿色  4cd964  先忽略
 */

//背景颜色
//#define BACKGROUNDCOLOR  HEXCOLOR(0x262527)  //页面背景色
#define BACKGROUNDCOLORWHITE  HEXCOLOR(0xf0eff4)//白色背景
//白色主题下title颜色
#define LITHTCOLOROFWHITE HEXCOLOR(0x777777)//浅
#define DARKCOLOROFWHITE HEXCOLOR(0x111111)//深：
//#define BACKCOLOROFBLACK  HEXCOLOR(0xffffff) //黑色版背景
//黑色背景 title颜色
#define LIGHTCOLOROFBLACK HEXCOLOR(0xffffff)//浅 --对应 白版的深
#define DARKCOLOROFBLACK  HEXCOLOR(0xbbbbbb)//深
#define STRINLOADING @"正在加载中…"


//集合竞价  的虚拟成交量色值也为cecece
#define BORDERCOLOR  HEXCOLOR(0xa1a1a1).CGColor//边框
#define LINECOLOR  HEXCOLOR(0xa1a1a1).CGColor//内部线框


#endif
