//
//  LevelButton.h
//  qiqiaoban
//
//  Created by mac on 2019/8/15.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LevelButtonType) {
    LevelButtonTypeLock = 0,      //未解锁
    LevelButtonTypeUnlock = 1,    //已解锁
    LevelButtonTypeRecordBad = 3, //已有记录 但是未通过.
    LevelButtonTypeRecordGood= 4  //已有记录 但是未通过.
};

typedef NS_ENUM(NSInteger, LevelButtonSepType) {
    LevelButtonSepTypeImage = 0,      //图形测试使用
    LevelButtonSepTypeWords = 1       //语言测试使用
};


@interface LevelButton : UIButton

@property (nonatomic,assign) LevelButtonType levelButtonType;


//显示当前关卡数字的image
@property (nonatomic,retain) UIImageView *levelNumImageView;

//显示当前关卡较大的数字image
@property (nonatomic,retain) UIImageView *bigLevelNumImageView;

//
@property (nonatomic,retain) UIImageView *logoImageView;

@property (nonatomic,retain) UIImageView *lockedImageView;

@property (nonatomic,retain) UIImageView *timeBackImageView;

//用来显示分钟时间的label;
@property (nonatomic,retain) UILabel * scondLabel;

//用来显示秒的label;
@property (nonatomic,retain) UILabel * miaoLabel;

@property (nonatomic,assign) LevelButtonSepType LevelButtonSepType;


-(void)creatSubviewsWithButtonWidth:(CGFloat)width;


@end
//amigo roger
NS_ASSUME_NONNULL_END
