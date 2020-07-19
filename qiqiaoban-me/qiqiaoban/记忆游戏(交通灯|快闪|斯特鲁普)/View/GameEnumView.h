//
//  GameEnumView.h
//  qiqiaoban
//
//  Created by Wei on 2019/8/20.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemoryGameLevelModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface GameEnumView : UIView

@property (strong, nonatomic) MemoryGameLevelModel *levelModel;


- (instancetype)initWithXTMemoryGameType:(XTMemoryGameType)memoryGameType;


@end

NS_ASSUME_NONNULL_END
