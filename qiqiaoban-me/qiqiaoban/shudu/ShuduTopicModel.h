//
//  ShuduTopicModel.h
//  qiqiaoban
//
//  Created by mac on 2019/7/12.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShuduTopicModel : NSObject



//---------------- 创建的信息.

//判断 是否最后一个题目。
@property (nonatomic,assign) BOOL isLastTopic;

//判断是否已经全部填写.
@property (nonatomic,assign) BOOL isFinish;

@property (nonatomic,assign) NSInteger useWrongTimes;

@property (nonatomic,retain) NSMutableArray *SDButtonModelArray;

@property (nonatomic,assign) float totalScore;

//----------------  保存的信息

//年龄段
@property (nonatomic,assign) NSInteger ageGroup;

//这是什么规格的数独 分别为4 6 9
@property (nonatomic,assign) NSInteger shuduCount;

//容错次数/
@property (nonatomic,assign) NSInteger wrongNum;

//时间
@property (nonatomic,assign) NSInteger standard_time;

//数独level
@property (nonatomic,copy) NSString *level;

//数独名字
@property (nonatomic,copy) NSString *name;

//数独id
@property (nonatomic,copy) NSString *sudokuid;

@end

NS_ASSUME_NONNULL_END
