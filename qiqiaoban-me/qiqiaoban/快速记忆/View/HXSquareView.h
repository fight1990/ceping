//
//  HXSquareView.h
//  qiqiaoban
//
//  Created by Wei on 2019/8/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HXSquareView : UIView

@property (strong, nonatomic) UIImageView *peakView;

- (instancetype)initWithFrame:(CGRect)frame fillColor:(UIColor*)fillCollor peakColor:(UIColor*)peakColor peakView:(UIImageView*)peakView;

- (void)responseResultToDefault;
- (void)responseResultWithSuccess:(BOOL)success;

@end
