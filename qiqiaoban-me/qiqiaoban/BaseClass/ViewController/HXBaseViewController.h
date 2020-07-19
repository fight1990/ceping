//
//  HXBaseViewController.h
//  qiqiaoban
//
//  Created by Wei on 2019/8/11.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MacroDefinition.h"

NS_ASSUME_NONNULL_BEGIN

#define KNavigationBar_Height 80

@interface HXBaseViewController : UIViewController

@property (strong, nonatomic) UIView *navigationBarView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *backgroundImageView;

@end

NS_ASSUME_NONNULL_END
