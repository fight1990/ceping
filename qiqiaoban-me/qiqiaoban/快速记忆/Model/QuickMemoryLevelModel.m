//
//  QuickMemoryLevelModel.m
//  qiqiaoban
//
//  Created by Wei on 2019/8/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QuickMemoryLevelModel.h"

@implementation QuickMemoryLevelModel

+ (NSArray *)countWithLevel:(NSInteger)level {
    /**
     第一位：关卡数量；
     第二位：颜色数量；
     第三位：图形数量;
     */
    NSArray *gameCount = @[];
    
    switch (level) {
        case 1:
            gameCount = @[@10,@3,@1];
            break;
        case 2:
            gameCount = @[@15,@3,@1];
            break;
        case 3:
            gameCount = @[@20,@3,@1];
            break;
        case 4:
            gameCount = @[@25,@3,@1];
            break;
        case 5:
            gameCount = @[@30,@3,@1];
            break;
        case 6:
            gameCount = @[@20,@3,@2];
            break;
        case 7:
            gameCount = @[@25,@3,@2];
            break;
        case 8:
            gameCount = @[@30,@3,@2];
            break;
        case 9:
            gameCount = @[@30,@3,@2];
            break;
        case 10:
            gameCount = @[@35,@3,@2];
            break;
        case 11:
            gameCount = @[@20,@4,@3];
            break;
        case 12:
            gameCount = @[@25,@4,@3];
            break;
        case 13:
            gameCount = @[@30,@4,@3];
            break;
        case 14:
            gameCount = @[@35,@4,@3];
            break;
        case 15:
            gameCount = @[@40,@4,@3];
            break;
        case 16:
            gameCount = @[@25,@4,@3];
            break;
        case 17:
            gameCount = @[@30,@4,@3];
            break;
        case 18:
            gameCount = @[@35,@4,@3];
            break;
        case 19:
            gameCount = @[@40,@4,@3];
            break;
        case 20:
            gameCount = @[@45,@4,@3];
            break;
        case 21:
            gameCount = @[@100,@4,@3];
            break;
        default:
            break;
    }
    
    return gameCount;
}

- (BOOL)isEqual:(QuickMemoryLevelModel*)object {
    if (self == object) {
        return YES;
    } else if (self.byType == 0) {
        if ([self colorsEqual:self.colors colors:object.colors]) {
            return YES;
        }
    } else if (self.byType == 1) {
        if ([self.graphShapes isEqual:object.graphShapes]) {
            return YES;
        }
    } else if (self.byType == 2) {
        if (self.drawCount == object.drawCount) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)colorsEqual:(NSArray<UIColor*>*)colors_1 colors:(NSArray<UIColor*>*)colors_2 {
    if ([colors_1 count] != [colors_2 count]) {
        return NO;
    } else {
        BOOL isSame = YES;
        for (int i = 0; i < [colors_1 count]; i++) {
            if (!CGColorEqualToColor(colors_1[i].CGColor, colors_2[i].CGColor)) {
                isSame = NO;
                break;
            }
        }
        return isSame;
    }
}

@end
