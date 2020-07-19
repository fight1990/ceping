//
//  MemoryGameLevelModel.m
//  qiqiaoban
//
//  Created by Wei on 2019/8/21.
//  Copyright © 2019 mac. All rights reserved.
//

#import "MemoryGameLevelModel.h"

@implementation MemoryGameLevelModel

+ (NSArray*)countWithLevelGameType:(XTMemoryGameType)gameType level:(NSInteger)level {
    /**
        第一位：关卡数量；
        第二位：颜色数量；
        第三位：图形数量
     */
    NSArray *gameCount = @[];
    switch (level) {
        case 1: {
            if (gameType == XTMemoryGameTypeWithTrafficLight) {
                gameCount = @[@15,@1,@3];
            } else if (gameType == XTMemoryGameTypeWithQuickFlashing) {
                gameCount = @[@20,@1,@4];
            } else if (gameType == XTMemoryGameTypeWithStroopEffect) {
                gameCount = @[@15,@3,@1];
            }
            break;
        }
        case 2: {
            if (gameType == XTMemoryGameTypeWithTrafficLight) {
                gameCount = @[@20,@1,@3];
            } else if (gameType == XTMemoryGameTypeWithQuickFlashing) {
                gameCount = @[@25,@1,@4];
            } else if (gameType == XTMemoryGameTypeWithStroopEffect) {
                gameCount = @[@20,@3,@1];
            }
            break;
        }
        case 3: {
            if (gameType == XTMemoryGameTypeWithTrafficLight) {
                gameCount = @[@25,@1,@3];;
            } else if (gameType == XTMemoryGameTypeWithQuickFlashing) {
                gameCount = @[@30,@1,@4];
            } else if (gameType == XTMemoryGameTypeWithStroopEffect) {
                gameCount = @[@25,@3,@1];
            }
            break;
        }
        case 4: {
            if (gameType == XTMemoryGameTypeWithTrafficLight) {
                gameCount = @[@30,@1,@3];;
            } else if (gameType == XTMemoryGameTypeWithQuickFlashing) {
                gameCount = @[@35,@1,@4];
            } else if (gameType == XTMemoryGameTypeWithStroopEffect) {
                gameCount = @[@30,@3,@1];
            }
            break;
        }
        case 5: {
            if (gameType == XTMemoryGameTypeWithTrafficLight) {
                gameCount = @[@35,@1,@3];
            } else if (gameType == XTMemoryGameTypeWithQuickFlashing) {
                gameCount = @[@40,@1,@4];
            } else if (gameType == XTMemoryGameTypeWithStroopEffect) {
                gameCount = @[@35,@3,@1];
            }
            break;
        }
        case 6: {
            if (gameType == XTMemoryGameTypeWithTrafficLight) {
                gameCount = @[@40,@1,@3];
            } else if (gameType == XTMemoryGameTypeWithQuickFlashing) {
                gameCount = @[@40,@1,@4];
            } else if (gameType == XTMemoryGameTypeWithStroopEffect) {
                gameCount = @[@30,@4,@1];
            }
            break;
        }
        case 7: {
            if (gameType == XTMemoryGameTypeWithTrafficLight) {
                gameCount = @[@30,@1,@3];
            } else if (gameType == XTMemoryGameTypeWithQuickFlashing) {
                gameCount = @[@45,@1,@7];
            } else if (gameType == XTMemoryGameTypeWithStroopEffect) {
                gameCount = @[@35,@4,@1];
            }
            break;
        }
        case 8: {
            if (gameType == XTMemoryGameTypeWithTrafficLight) {
                gameCount = @[@35,@1,@3];
            } else if (gameType == XTMemoryGameTypeWithQuickFlashing) {
                gameCount = @[@50,@1,@7];
            } else if (gameType == XTMemoryGameTypeWithStroopEffect) {
                gameCount = @[@40,@4,@1];
            }
            break;
        }
        case 9: {
            if (gameType == XTMemoryGameTypeWithTrafficLight) {
                gameCount = @[@40,@1,@3];
            } else if (gameType == XTMemoryGameTypeWithQuickFlashing) {
                gameCount = @[@55,@1,@7];
            } else if (gameType == XTMemoryGameTypeWithStroopEffect) {
                gameCount = @[@45,@4,@1];
            }
            break;
        }
        case 10: {
            if (gameType == XTMemoryGameTypeWithTrafficLight) {
                gameCount = @[@45,@1,@3];
            } else if (gameType == XTMemoryGameTypeWithQuickFlashing) {
                gameCount = @[@60,@1,@7];
            } else if (gameType == XTMemoryGameTypeWithStroopEffect) {
                gameCount = @[@50,@4,@1];
            }
            break;
        }
        case 11: {
            if (gameType == XTMemoryGameTypeWithTrafficLight) {
                gameCount = @[@45,@1,@3];
            } else if (gameType == XTMemoryGameTypeWithQuickFlashing) {
                gameCount = @[@40,@2,@4];
            } else if (gameType == XTMemoryGameTypeWithStroopEffect) {
                gameCount = @[@40,@5,@1];
            }
            break;
        }
        case 12: {
            if (gameType == XTMemoryGameTypeWithTrafficLight) {
                gameCount = @[@30,@2,@3];
            } else if (gameType == XTMemoryGameTypeWithQuickFlashing) {
                gameCount = @[@45,@2,@4];
            } else if (gameType == XTMemoryGameTypeWithStroopEffect) {
                gameCount = @[@45,@5,@1];
            }
            break;
        }
        case 13: {
            if (gameType == XTMemoryGameTypeWithTrafficLight) {
                gameCount = @[@35,@2,@3];
            } else if (gameType == XTMemoryGameTypeWithQuickFlashing) {
                gameCount = @[@50,@2,@4];
            } else if (gameType == XTMemoryGameTypeWithStroopEffect) {
                gameCount = @[@50,@5,@1];
            }
            break;
        }
        case 14: {
            if (gameType == XTMemoryGameTypeWithTrafficLight) {
                gameCount = @[@40,@2,@3];
            } else if (gameType == XTMemoryGameTypeWithQuickFlashing) {
                gameCount = @[@55,@2,@4];
            } else if (gameType == XTMemoryGameTypeWithStroopEffect) {
                gameCount = @[@40,@4,@1];
            }
            break;
        }
        case 15: {
            if (gameType == XTMemoryGameTypeWithTrafficLight) {
                gameCount = @[@45,@2,@3];
            } else if (gameType == XTMemoryGameTypeWithQuickFlashing) {
                gameCount = @[@60,@2,@4];
            } else if (gameType == XTMemoryGameTypeWithStroopEffect) {
                gameCount = @[@45,@4,@1];
            }
            break;
        }
        case 16: {
            if (gameType == XTMemoryGameTypeWithTrafficLight) {
                gameCount = @[@45,@2,@3];
            } else if (gameType == XTMemoryGameTypeWithQuickFlashing) {
                gameCount = @[@60,@2,@4];
            } else if (gameType == XTMemoryGameTypeWithStroopEffect) {
                gameCount = @[@50,@4,@1];
            }
            break;
        }
        case 17: {
            if (gameType == XTMemoryGameTypeWithTrafficLight) {
                gameCount = @[@30,@2,@3];
            } else if (gameType == XTMemoryGameTypeWithQuickFlashing) {
                gameCount = @[@50,@2,@7];
            } else if (gameType == XTMemoryGameTypeWithStroopEffect) {
                gameCount = @[@40,@5,@1];
            }
            break;
        }
        case 18: {
            if (gameType == XTMemoryGameTypeWithTrafficLight) {
                gameCount = @[@35,@2,@3];
            } else if (gameType == XTMemoryGameTypeWithQuickFlashing) {
                gameCount = @[@55,@2,@7];
            } else if (gameType == XTMemoryGameTypeWithStroopEffect) {
                gameCount = @[@45,@5,@1];
            }
            break;
        }
        case 19: {
            if (gameType == XTMemoryGameTypeWithTrafficLight) {
                gameCount = @[@40,@2,@3];
            } else if (gameType == XTMemoryGameTypeWithQuickFlashing) {
                gameCount = @[@60,@2,@7];
            } else if (gameType == XTMemoryGameTypeWithStroopEffect) {
                gameCount = @[@50,@5,@1];
            }
            break;
        }
        case 20: {
            if (gameType == XTMemoryGameTypeWithTrafficLight) {
                gameCount = @[@45,@3,@3];
            } else if (gameType == XTMemoryGameTypeWithQuickFlashing) {
                gameCount = @[@70,@2,@7];
            } else if (gameType == XTMemoryGameTypeWithStroopEffect) {
                gameCount = @[@55,@5,@1];
            }
            break;
        }
        case 21: {
            if (gameType == XTMemoryGameTypeWithTrafficLight) {
                gameCount = @[@100,@2,@3];
            } else if (gameType == XTMemoryGameTypeWithQuickFlashing) {
                gameCount = @[@100,@2,@7];
            } else if (gameType == XTMemoryGameTypeWithStroopEffect) {
                gameCount = @[@100,@5,@1];
            }
            break;
        }
        default:
            break;
    }
    
    return gameCount;
}

+ (NSArray *)getColorWords {
    return @[@"红色",@"橙色",@"黄色",@"绿色",@"青色",@"蓝色",@"紫色",@"灰色",@"黑色",@"Red",@"Orange",@"Yellow",@"Green",@"Cyan",@"Blue",@"Purple",@"Gray",@"Black"];
}

- (BOOL)isEqual:(MemoryGameLevelModel*)object {
    if (self == object) {
        return YES;
    } else if (((!self.colors && !object.colors) || [self colorsEqual:self.colors colors:object.colors]) && ((!self.colorIndexs && !object.colorIndexs) || [self.colorIndexs isEqual:object.colorIndexs]) && self.maxCount == object.maxCount && ((!self.graphShapes && !object.graphShapes) || [self.graphShapes isEqual:object.graphShapes]) && ((!self.colorWords && !object.colorWords) || [self.colorWords isEqual:object.colorWords])) {
        return YES;
    } else {
        return NO;
    }
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
