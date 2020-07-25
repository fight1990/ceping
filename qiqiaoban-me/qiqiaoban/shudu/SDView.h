//
//  SDView.h
//  shudu
//
//  Created by mac on 2019/6/19.
//  Copyright © 2019年 mac. All rights reserved.
//

//用于显示数独的view

#import <UIKit/UIKit.h>
#import "ShuduButton.h"


typedef NS_ENUM(NSInteger, SDViewType) {
    SDViewTypeNine     =      0 ,
    SDViewTypeSix    =      1 ,          // 用来点击的按钮
    SDViewTypeFour     =      2 ,         // 用来显示已有数字 无法点击
};

NS_ASSUME_NONNULL_BEGIN
@class SDView;

@protocol SDViewDelegate <NSObject>

//点击一个数字之后的操作.
-(void)SDView:(SDView *)sd didEnterOneNum:(NSInteger)num inButton:(ShuduButton *)but;

//将会点进一个数字
-(void)SDView:(SDView *)sd willEnterOneNum:(NSInteger)num inButton:(ShuduButton *)but;

//是否可以点击上传按钮.
-(BOOL)SDView:(SDView *)sd canClcikUploadButton:(UIButton *)but;

//是否可以点击消除按钮.
-(BOOL)SDView:(SDView *)sd canClcikClearButton:(UIButton *)but;

//点击上传按钮之后
-(void)SDView:(SDView *)sd didClickUloadButton:(UIButton *)but;

//点击消除按钮 消除数字之前.
-(void)SDView:(SDView *)sd didClickClearButton:(UIButton *)but;

-(BOOL)SDView:(SDView *)sd canClear:(UIButton *)but;


@end

@interface SDView : UIView

//用于保存所有按钮的array
@property (nonatomic,retain) NSMutableArray *shuduButtonArray;

@property (nonatomic) SDViewType SDViewType;

@property (nonatomic,weak) id <SDViewDelegate> delegate;

@property (nonatomic,retain) UIButton * uploadButton;

@property (nonatomic,retain) UIButton * clearButton;


@property (nonatomic,retain,readonly) ShuduButton *currentSelectButton;


//用来传递这个地方的高度. 用来给点击的按钮控制高度.
@property (nonatomic,assign) CGFloat buttonHeight;

-(void)creatView;

@end

NS_ASSUME_NONNULL_END
