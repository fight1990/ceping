
//  qiqiaoban
//
//  Created by mac on 2019/2/19.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QQBModel.h"

#import "TipsView.h"

#import "UIView+ImageExtention.h"

#import "UIImage+ColorAtPixel.h"

//开始游戏的页面.

@interface StartViewController : UIViewController

//当前所得到的模型   //当得出所花时间后进行赋值  计算得分.
@property (nonatomic,retain) QQBModel *currentModel;

//当前所用时间.
@property (nonatomic,assign) NSInteger currentMiaokeka;

@property (nonatomic,retain) TipsView *tips;

@property (nonatomic,assign) NSInteger currentQQBPoint;

@property (nonatomic,retain) UILabel *titleLabel;

@property (nonatomic,retain) UIView *timeView;

-(void)loadQQB;

//开始计时+
-(void)timeGo;

//结束计时
-(void)stopTime;

//需要重写的方法;
-(void)clickQuit;

//读取七巧板
-(void)loadQQBInfoOver;

//跳过
-(void)tiaoGuo;

//显示答案
-(void)chakanAnswer;

@end






