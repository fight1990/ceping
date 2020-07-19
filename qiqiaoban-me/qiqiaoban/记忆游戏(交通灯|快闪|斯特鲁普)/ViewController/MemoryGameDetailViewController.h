//
//  MemoryGameDetailViewController.h
//  qiqiaoban
//
//  Created by Wei on 2019/8/11.
//  Copyright © 2019 mac. All rights reserved.
//

#import "HXBaseViewController.h"
#import "MemoryGameLevelModel.h"
#import "MemoryGameModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^GameResultBlock)(BOOL isSuccess);

@interface MemoryGameDetailViewController : HXBaseViewController

@property (assign, nonatomic) XTMemoryGameType memoryGameType;
@property (assign, nonatomic) NSInteger level;
@property (strong, nonatomic) MemoryGameModel *gameModel;
@property (strong, nonatomic) NSArray<MemoryGameModel*> *dataList;

@property (strong, nonatomic) GameResultBlock gameResultBlock;


@end

NS_ASSUME_NONNULL_END
