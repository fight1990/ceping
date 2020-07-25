//
//  StroopEffectPresenter.h
//  qiqiaoban
//
//  Created by Wei on 2019/8/25.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemoryGameModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StroopEffectPresenter : NSObject

+ (void)getLevelDatas:(void(^)(NSArray<MemoryGameModel*> *datas,BOOL isSuccess))resultBlock;

+ (void)setLevelParmers:(NSDictionary*)parmers resultBlock:(void(^)(MemoryGameModel *memoryGameModel,BOOL isSuccess))resultBlock;

@end

NS_ASSUME_NONNULL_END
