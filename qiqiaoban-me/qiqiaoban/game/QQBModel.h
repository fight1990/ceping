//
//  QQBModel.h
//  qiqiaoban
//
//  Created by mac on 2019/3/22.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShapeModel.h"


typedef NS_ENUM(NSInteger, ShapeModelCountType) {
    ShapeModelCountTypeLess = 0,    //小于10道题目.
    ShapeModelCountTypeTen = 1,     //已经第10题.
    ShapeModelCountTypeOver = 2     //题目超出范围.
};




//七巧板模型

@interface QQBModel : NSObject

//七巧板名称
@property (nonatomic,copy) NSString *QQBName;

//七巧板编号
@property (nonatomic,copy) NSString *QQBNumber;

//标准时间
@property (nonatomic,copy) NSString *standardTime;

//难度等级
@property (nonatomic,copy) NSString *level;

//提示等级 分为1-6级.
@property (nonatomic,copy) NSString *type;

//实际时间.
@property (nonatomic,copy) NSString *costTime;

@property (nonatomic,assign) ShapeModelCountType currentCountType;

//得到的分数.  0分为 跳过. 1分为 查看答案. 2分为实际超时.
@property (nonatomic,copy) NSString *currentScore;

// 
@property (nonatomic,copy) NSString *ageGrounp;



//每个图形的model
@property (nonatomic,retain) NSMutableArray *ShapeModelArray;


//随机到的色块的样子.
@property (nonatomic,retain) NSMutableArray *selectSQCount;

@end
