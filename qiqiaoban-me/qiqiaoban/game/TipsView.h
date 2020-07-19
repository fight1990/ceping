//
//  TipsView.h
//  qiqiaoban
//
//  Created by mac on 2019/3/22.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QQBModel.h"

#import "QQShapeSqura.h"

struct SQAre {
    CGPoint MaxPoint;
    CGPoint MinPoint;
};
typedef struct  SQAre SQAre;




//用来创建提示使用的view 根据提示类型的不同

@interface TipsView : UIView

//当前显示数据的模型。
@property (nonatomic,retain) QQBModel *model;

//当前显示等级
@property (nonatomic,assign) NSInteger currentTypeNum;

@property (nonatomic,assign) SQAre showAre;

//保存所有七巧板图形的数组.
@property (nonatomic,retain) NSMutableArray *containSquraArray;

-(instancetype)initWithModel:(QQBModel *)model;

-(void)showAnswer;


@end
