//
//  HWCircleView.h
//  HWProgress
//
//  Created by sxmaps_w on 2017/3/3.
//  Copyright © 2017年 hero_wqb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWCircleView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) CGFloat maxNumber;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, assign) CGFloat lineWidth;
@end
