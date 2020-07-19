//
//  ShuduTopicModel.m
//  qiqiaoban
//
//  Created by mac on 2019/7/12.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ShuduTopicModel.h"

@implementation ShuduTopicModel

-(NSMutableArray *)SDButtonModelArray{
    if (!_SDButtonModelArray) {
        _SDButtonModelArray = [NSMutableArray array];
    }
    return _SDButtonModelArray;
}

@end
