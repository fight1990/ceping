//
//  LightAlertViewController.h
//  qiqiaoban
//
//  Created by Wei on 2019/8/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LightAlertCloseBlock)(void);

/**
 通用弹窗控制器
 */
@class LightAlertAction,LightAlertViewItem;
@interface LightAlertViewController : UIViewController

@property (nonatomic ,copy) NSAttributedString *alertAttributedContent;
@property (nonatomic, assign) NSInteger resultScore;
@property (nonatomic ,copy) LightAlertCloseBlock closeHandle;

+(instancetype)alertWithTitle:(NSString *)title andContent:(NSString *)content;

-(void)addAction:(LightAlertAction *)action;

@end

typedef void(^LightAlertActionBlock)(void);

/**
 弹窗事件
 */
@interface LightAlertAction : NSObject

+(instancetype)actionWithTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andBackgroundColor:(UIColor*)backgroundColor action:(LightAlertActionBlock) handel;

-(instancetype)initWithTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andBackgroundColor:(UIColor*)backgroundColor action:(LightAlertActionBlock) handel;

@property (nonatomic ,copy ,readonly)  NSString *title;
@property (nonatomic ,strong ,readonly) UIColor *titleColor;

@property (nonatomic ,strong ,readonly) UIColor *backgroundColor;
@property (nonatomic ,assign) BOOL isCornerRadius;

@property (nonatomic ,copy) LightAlertActionBlock handle;
@end

@protocol LightAlertDelegate

-(void)clickItem;

@end

/**
 弹窗Item
 */
@interface LightAlertViewItem : UILabel

@property (nonatomic ,copy)LightAlertActionBlock handle;

@property (nonatomic ,weak) id<LightAlertDelegate> delegate;
@end
