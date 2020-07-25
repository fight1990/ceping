//
//  ShuduBasicViewController.h
//  qiqiaoban
//
//  Created by mac on 2019/7/4.
//  Copyright © 2019年 mac. All rights reserved.
//  要这样也不早说。 擦擦擦擦擦擦

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShuduBasicViewController : UIViewController



//当前所用时间.
@property (nonatomic,assign) NSInteger currentMiaokeka;

//显示标题的 title
@property (nonatomic,retain) UILabel *titleLabel;


//开始计时
-(void)goTime;

//结束计时
-(void)stopTime;



#pragma mark - 重写的方法。
//点击退出了数独。
-(void)clickQuit;

//跳过
-(void)tiaoGuo;

//显示答案
-(void)chakanAnswer;


@end

NS_ASSUME_NONNULL_END
