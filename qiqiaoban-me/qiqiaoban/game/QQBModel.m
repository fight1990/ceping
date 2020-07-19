//
//  QQBModel.m
//  qiqiaoban
//
//  Created by mac on 2019/3/22.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "QQBModel.h"

@implementation QQBModel


//初始化 给所有模型全部创建好. 等待赋值
-(instancetype)init{
    
    if (self = [super init]) {
        self.ShapeModelArray = [NSMutableArray array];
        
        for (int i = 0 ; i < 7; i ++) {
            ShapeModel *model = [[ShapeModel alloc] init];
            
            [self.ShapeModelArray addObject:model];
            
        }
        
        _currentScore = @"0";
    }
    return self;
}

-(void)setType:(NSString *)type{
    _type = type;
    [self.selectSQCount removeAllObjects];
    if ([type isEqualToString:@"提示-4"]) {
        self.selectSQCount = [self getSuijiNumForCount:1];
    }else if ([type isEqualToString:@"提示-5"]){
        self.selectSQCount = [self getSuijiNumForCount:2];
    }else if ([type isEqualToString:@"提示-6"]){
        self.selectSQCount = [self getSuijiNumForCount:3];
    }else{
    }
}

//得到 0-6 中的几个不同的随机数.
-(NSMutableArray *)getSuijiNumForCount:(NSInteger)count{
    
    NSMutableArray *ary = [NSMutableArray array];
    for (int i = 0 ; i < count; ) {
        NSInteger num = arc4random() % 7;
        NSString *numStr = [NSString stringWithFormat:@"%ld",num];
        if (![ary containsObject:numStr]) {
            [ary addObject:numStr];
            i++;
        }
    }
    return ary;
    
}

@end
