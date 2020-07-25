//
//  HWProgressView.m
//  HWProgress
//
//  Created by sxmaps_w on 2017/3/3.
//  Copyright © 2017年 hero_wqb. All rights reserved.
//

#import "HWProgressView.h"

#define KProgressBorderWidth 2.0f
#define KProgressPadding 1.0f
#define KProgressColor [UIColor yellowColor]

#define KProgressFont [UIFont systemFontOfSize:12.0f]
@interface HWProgressView ()

@property (nonatomic, strong) UIView *tView;
@property (nonatomic, strong) UILabel *cLabel;

@end

@implementation HWProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //边框
        UIView *borderView = [[UIView alloc] initWithFrame:self.bounds];
        borderView.layer.cornerRadius = self.bounds.size.height * 0.5;
        borderView.layer.masksToBounds = YES;
        borderView.backgroundColor = [UIColor whiteColor];
        borderView.layer.borderColor = [KProgressColor CGColor];
        borderView.layer.borderWidth = KProgressBorderWidth;
        [self addSubview:borderView];
        
        //进度
        UIView *tView = [[UIView alloc] init];
        tView.backgroundColor = KProgressColor;
        tView.layer.cornerRadius = (self.bounds.size.height - (KProgressBorderWidth + KProgressPadding) * 2) * 0.5;
        tView.layer.masksToBounds = YES;
        [self addSubview:tView];
        self.tView = tView;
        
        [self addSubview:self.cLabel];
        
    }
    
    return self;
}

- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    _tView.backgroundColor = _progressColor;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    CGFloat margin = KProgressBorderWidth + KProgressPadding;
    CGFloat maxWidth = self.bounds.size.width - margin * 2;
    CGFloat heigth = self.bounds.size.height - margin * 2;
    
    if (progress >= 1.0) {
        self.cLabel.hidden = YES;
    } else {
        self.cLabel.hidden = NO;
    }
    
    _tView.frame = CGRectMake(margin, margin, maxWidth * progress, heigth);
    self.cLabel.frame = CGRectMake(maxWidth * progress, margin * 2 + heigth, 40, 20);
    self.cLabel.text = [NSString stringWithFormat:@"%d", (int)floor(self.maxNumber * _progress)];
}

- (UILabel *)cLabel {
    if (!_cLabel) {
        //百分比标签
        _cLabel = [[UILabel alloc] init];
        _cLabel.font = KProgressFont;
        _cLabel.textColor = [UIColor whiteColor];
        _cLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _cLabel;
}
@end

