//
//  ImageTrainLevelModel.m
//  qiqiaoban
//
//  Created by mac on 2019/8/29.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ImageTrainLevelModel.h"

@implementation ImageTrainLevelModel

-(void)setTime:(float)time{
    _time = time;
    
    if (time <=60) {
        _fen = 0;
        _miao = time;
    }
    if (time >60) {
        int timet = (int)time;
        _fen = timet % 60;
        _miao = timet / 60;
     }
}

@end
