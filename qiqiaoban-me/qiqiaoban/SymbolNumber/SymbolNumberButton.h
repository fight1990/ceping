//
//  SymbolNumberButton.h
//  QiQiaoBan
//
//  Created by mac on 2019/8/13.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_OPTIONS(NSUInteger, SymbolNumberButtonType) {
    SymbolNumberButtonTypeNone     =      0     ,
    SymbolNumberButtonTypeClick    =      1 << 0,          // 用来点击的按钮
    SymbolNumberButtonTypeShow     =      1 << 1,         // 用来显示已有数字 无法点击
    //    ShuduButtonTypeSelect   =      1 << 2         // 被选中的按钮
};

struct SNBTPostion {
    NSInteger xcount;
    NSInteger ycount;
};

typedef NSInteger areaCount;

typedef struct SNBTPostion SNBTPostion;

CG_INLINE SNBTPostion SNBTPositonMake(NSInteger x,NSInteger y){
    SNBTPostion posi;
    posi.xcount = x;
    posi.ycount = y;
    return posi;
}

//判断是否是同一个创建位置的点。
CG_INLINE BOOL SNBTPositonSame(SNBTPostion a,SNBTPostion b){
    if (a.xcount == b.xcount && a.ycount == b.ycount) {
        return YES;
    }else{
        return NO;
    }
}

NS_ASSUME_NONNULL_BEGIN

@interface SymbolNumberButton : UIButton
//用于显示按钮在数独中的位置。
@property (nonatomic) SNBTPostion Posi;

//处于第几个区域。
//数独 从左到右 从上到下 从0到N;
@property (nonatomic,assign) areaCount iAre;

//当前显示的数字。
@property (nonatomic,assign) NSInteger showNum;


//两种种显示的颜色。

@property (nonatomic,retain) UIColor *showTypeColor;


@property (nonatomic,retain) UIColor *clickTypeColor;


//当前所处的状态。
@property (nonatomic,assign) SymbolNumberButtonType SymbolNumberButtonType;
@end

NS_ASSUME_NONNULL_END
