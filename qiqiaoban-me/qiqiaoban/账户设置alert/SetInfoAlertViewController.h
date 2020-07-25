//
//  SetInfoAlertViewController.h
//  qiqiaoban
//
//  Created by mac on 2019/3/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StudentsInfo.h"

@class SetInfoAlertViewController;

@protocol SetInfoAlertViewControllerDelegate <NSObject>

-(void)SetInfoAlertViewController:(SetInfoAlertViewController *)controller didSetBirthday:(NSString *)date;

@end

@interface SetInfoAlertViewController : UIViewController

@property (nonatomic,retain) StudentsInfo *currentStuInfo;

@property (nonatomic,weak) id <SetInfoAlertViewControllerDelegate> delegate;

@end
