//
//  ShuduButton.h
//  shudu
//
//  Created by mac on 2019/6/20.
//  Copyright © 2019年 mac. All rights reserved.
//用于显示数独方块的button

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, ShuduButtonType) {
    ShuduButtonTypeNone     =      0     ,
    ShuduButtonTypeClick    =      1 << 0,          // 用来点击的按钮
    ShuduButtonTypeShow     =      1 << 1,         // 用来显示已有数字 无法点击
//    ShuduButtonTypeSelect   =      1 << 2         // 被选中的按钮
};

struct BTPostion {
    NSInteger xcount;
    NSInteger ycount;
};

typedef NSInteger areaCount;

typedef struct BTPostion BTPostion;

CG_INLINE BTPostion BTPositonMake(NSInteger x,NSInteger y){
    BTPostion posi;
    posi.xcount = x;
    posi.ycount = y;
    return posi;
}

//判断是否是同一个创建位置的点。
CG_INLINE BOOL BTPositonSame(BTPostion a,BTPostion b){
    if (a.xcount == b.xcount && a.ycount == b.ycount) {
        return YES;
    }else{
        return NO;
    }
}


NS_ASSUME_NONNULL_BEGIN
@interface ShuduButton : UIButton

//用于显示按钮在数独中的位置。
@property (nonatomic) BTPostion Posi;

//处于第几个区域。
//数独 从左到右 从上到下 从0到N;
@property (nonatomic,assign) areaCount iAre;

//当前显示的数字。
@property (nonatomic,assign) NSInteger showNum;

//两种种显示的颜色。

//背景色。  两种操作模式的
@property (nonatomic,retain) UIColor *showTypeColor;

@property (nonatomic,retain) UIColor *clickTypeColor;

//字体颜色. 操作模式的.
@property (nonatomic,retain) UIColor *showTypeTitleColor;

@property (nonatomic,retain) UIColor *clickTypeTitleColor;

@property (nonatomic,retain) UIColor *selectButtonBackColor;

@property (nonatomic,retain) UIColor *wrongButtonBackColor;

@property (nonatomic,retain) UIColor *selectTitleColor;

@property (nonatomic,retain) UIColor *wrongTitleColor;

//当前所处的状态。
@property (nonatomic,assign) ShuduButtonType ShuduButtonType;

@property (nonatomic,assign) BOOL isInRightPlace;

//自己算表示的分数.
@property (nonatomic,assign) float score;


@end

NS_ASSUME_NONNULL_END
