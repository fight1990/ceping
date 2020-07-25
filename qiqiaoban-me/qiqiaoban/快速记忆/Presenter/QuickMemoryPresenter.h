//
//  QuickMemoryPresenter.h
//  qiqiaoban
//
//  Created by Wei on 2019/8/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuickMemoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuickMemoryPresenter : NSObject

+ (void)getLevelDatas:(void(^)(NSArray<QuickMemoryModel*> *datas,BOOL isSuccess))resultBlock;

+ (void)setLevelParmers:(NSDictionary*)parmers resultBlock:(void(^)(QuickMemoryModel *memoryGameModel,BOOL isSuccess))resultBlock;

@end

NS_ASSUME_NONNULL_END
