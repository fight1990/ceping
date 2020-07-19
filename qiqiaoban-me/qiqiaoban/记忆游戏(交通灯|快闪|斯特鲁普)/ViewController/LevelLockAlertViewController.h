//
//  LevelLockAlertViewController.h
//  qiqiaoban
//
//  Created by Wei on 2019/8/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LevelLockAlertCloseBlock)(void);

/**
 通用弹窗控制器
 */
@class XTAlertAction,XTAlertViewItem;


@interface LevelLockAlertViewController : UIViewController

@property (nonatomic ,copy) LevelLockAlertCloseBlock closeHandle;

+(instancetype)alertWithTitle:(NSString *)title andImage:(UIImage*)image;
+(instancetype)alertWithTitleImage:(NSString *)titleImageName andImage:(UIImage*)image;

@end

