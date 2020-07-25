//
//  QuickMemoryLevelModel.h
//  qiqiaoban
//
//  Created by Wei on 2019/8/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define KColorWithGreen    UIColorFromRGB(0x33cc33)
#define KColorWithRed      UIColorFromRGB(0xff0000)
#define KColorWithOrange   UIColorFromRGB(0xffcc00)
#define KColorWithBlue     UIColorFromRGB(0x3399ff)
#define KColorWithCyan     UIColorFromRGB(0x33cc99)
#define KColorWithPurple   UIColorFromRGB(0x9933cc)
#define KColorWithYellow   UIColorFromRGB(0xffff00)
#define KColorWithGray     UIColorFromRGB(0x666666)
#define KColorWithBlack    UIColorFromRGB(0x333333)

@interface QuickMemoryLevelModel : NSObject

///取值颜色区间
@property (strong, nonatomic) NSArray<UIColor*> *colors;
///数量
@property (assign, nonatomic) NSInteger enumCount;
///绘制图形个数
@property (assign, nonatomic) NSInteger drawCount;

/**
 0 -- 圆形
 1 -- 正方形
 2 -- 五角星
 3 -- 八边形
 4 -- 六边形
 5 -- 三角形
 */
@property (strong, nonatomic) NSArray<NSNumber*> *graphShapes;

//比较类型 0.颜色；1.形状；2.数量
@property (assign, nonatomic) NSInteger byType;

+ (NSArray *)countWithLevel:(NSInteger)level;

@end
