//
//  SDViewController.h
//  shudu
//
//  Created by mac on 2019/6/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShuduBasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

//创建数独页面。  读取 新的题目、

/// 5   4   3   2   1  makodo  mujimula  nishiki   弗里茨王. 145   伊蕾娜
//复仇     可疑
@interface SDViewController : ShuduBasicViewController

@property (nonatomic,assign) NSInteger type;

-(void)loadOneShuduInfo;


@end

NS_ASSUME_NONNULL_END
