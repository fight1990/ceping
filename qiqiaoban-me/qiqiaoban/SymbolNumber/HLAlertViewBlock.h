//
//  HLAlertViewBlock.h
//  HLAlertView
//
//  Created by 郝靓 on 2018/6/5.
//  Copyright © 2018年 郝靓. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum : NSUInteger {
    AlertBlockCauseButtonClick = 0,
    AlertBlockSureButtonClick,
    AlertBlockAgainButtonClick
} AlertBlockButtonClickIndex;

@interface HLAlertViewBlock : UIView

@property(nonatomic, copy) void (^buttonBlock) (NSInteger index);

- (instancetype)initWithRemainingSeconds:(NSInteger)remainingSeconds
                             rightAmount:(NSInteger)rightAmount
                               queAmount:(NSInteger)queAmount
                                   block:(void (^) (NSInteger index))block;


- (void)show;

@end
