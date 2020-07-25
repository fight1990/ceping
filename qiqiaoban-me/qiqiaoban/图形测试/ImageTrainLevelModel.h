//
//  ImageTrainLevelModel.h
//  qiqiaoban
//
//  Created by mac on 2019/8/29.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageTrainLevelModel : NSObject

@property (nonatomic,assign) int level;

@property (nonatomic,assign) float score;

@property (nonatomic,assign) float time;


@property (nonatomic,assign) int fen;
@property (nonatomic,assign) int miao;

@end

NS_ASSUME_NONNULL_END

