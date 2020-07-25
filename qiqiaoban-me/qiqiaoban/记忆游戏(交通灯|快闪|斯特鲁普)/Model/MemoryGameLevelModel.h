//
//  MemoryGameLevelModel.h
//  qiqiaoban
//
//  Created by Wei on 2019/8/21.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XTMemoryGameType) {
    XTMemoryGameTypeWithTrafficLight = 0, //交通灯
    XTMemoryGameTypeWithQuickFlashing,    //快闪图标
    XTMemoryGameTypeWithStroopEffect      //斯特鲁普
};

#define LightColor_Red   UIColorFromRGB(0xff0000)
#define LightColor_Green UIColorFromRGB(0x33cc33)

#define KColorWithGreen    UIColorFromRGB(0x33cc33)
#define KColorWithRed      UIColorFromRGB(0xff0000)
#define KColorWithOrange   UIColorFromRGB(0xffcc00)
#define KColorWithBlue     UIColorFromRGB(0x3399ff)
#define KColorWithCyan     UIColorFromRGB(0x33cc99)
#define KColorWithPurple   UIColorFromRGB(0x9933cc)
#define KColorWithYellow   UIColorFromRGB(0xffff00)
#define KColorWithGray     UIColorFromRGB(0x666666)
#define KColorWithBlack    UIColorFromRGB(0x333333)

@interface MemoryGameLevelModel : NSObject

#pragma mark 交通灯数据
///取值颜色区间
@property (strong, nonatomic) NSArray<UIColor*> *colors;
///最大数量 N * 3 = maxCount
@property (assign, nonatomic) NSInteger maxCount;
///存在绘色的位置
@property (strong, nonatomic) NSArray<NSNumber*> *colorIndexs;

/**
 0 -- 圆形
 1 -- 正方形
 2 -- 五角星
 3 -- 八边形
 4 -- 六边形
 5 -- 三角形
 */
@property (strong, nonatomic) NSArray<NSNumber*> *graphShapes;

/**
 #define KColorWithGreen    UIColorFromRGB(0x33cc33)
 #define KColorWithRed      UIColorFromRGB(0xff0000)
 #define KColorWithOrange   UIColorFromRGB(0xffcc00)
 #define KColorWithBlue     UIColorFromRGB(0x3399ff)
 #define KColorWithCyan     UIColorFromRGB(0x33cc99)
 #define KColorWithPurple   UIColorFromRGB(0x9933cc)
 #define KColorWithYellow   UIColorFromRGB(0xffff00)
 #define KColorWithGray     UIColorFromRGB(0x666666)
 #define KColorWithBlack    UIColorFromRGB(0x333333)
 0 -- 橙色值
 1 -- 蓝色值
 2 -- 青色值
 3 -- 紫色值
 4 -- 黄色值
 5 -- 绿色值
 6 -- 红色值
 7 -- 灰色值
 8 -- 黑色值
 9 -- Orange
 10 -- Blue
 11 -- Cyan
 12 -- Purple
 13 -- Yellow
 14 -- Green
 15 -- Red
 16 -- Gray
 17 -- Black
 */
@property (strong, nonatomic) NSArray<NSString*> *colorWords;

#pragma mark 快闪图标

#pragma mark 斯特鲁普


/**
 第一位：关卡数量；
 第二位：颜色数量；
 第三位：图形数量
 */
+ (NSArray*)countWithLevelGameType:(XTMemoryGameType)gameType level:(NSInteger)level;

+ (NSArray*)getColorWords;

@end
