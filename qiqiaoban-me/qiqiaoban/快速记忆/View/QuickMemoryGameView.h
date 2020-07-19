//
//  QuickMemoryGameView.h
//  qiqiaoban
//
//  Created by Wei on 2019/8/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickMemoryLevelModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuickMemoryGameView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat maxNumber;
@property (nonatomic, assign) BOOL hiddenTitle;

@property (strong, nonatomic) QuickMemoryLevelModel *levelModel;

- (void)startAnimationPlay;
- (void)initInfo;

- (void)responseResultToDefault;
- (void)responseResultWithSuccess:(BOOL)success;
@end

NS_ASSUME_NONNULL_END
