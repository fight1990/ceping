//
//  QuickMemoryDetailViewController.h
//  qiqiaoban
//
//  Created by Wei on 2019/8/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import "HXBaseViewController.h"
#import "QuickMemoryModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^GameResultBlock)(BOOL isSuccess);

@interface QuickMemoryDetailViewController : HXBaseViewController

@property (assign, nonatomic) NSInteger level;
@property (strong, nonatomic) QuickMemoryModel *gameModel;
@property (strong, nonatomic) NSArray<QuickMemoryModel*> *dataList;

@property (strong, nonatomic) GameResultBlock gameResultBlock;

@end

NS_ASSUME_NONNULL_END
