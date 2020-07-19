//
//  QMLevelLockAlertViewController.h
//  qiqiaoban
//
//  Created by Wei on 2019/8/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^QMLevelLockAlertCloseBlock)(void);

/**
 通用弹窗控制器
 */
@class XTAlertAction,XTAlertViewItem;

@interface QMLevelLockAlertViewController : UIViewController

@property (nonatomic ,copy) QMLevelLockAlertCloseBlock closeHandle;

+(instancetype)alertWithTitle:(NSString *)title headerImage:(UIImage*)headerImage;

@end
