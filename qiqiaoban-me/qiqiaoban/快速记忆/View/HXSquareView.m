//
//  HXSquareView.m
//  qiqiaoban
//
//  Created by Wei on 2019/8/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "HXSquareView.h"

@interface HXSquareView ()

@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) UIColor *fillCollor;
@property (strong, nonatomic) UIColor *peakColor;

@property (strong, nonatomic) UIImageView *peakView_1;
@property (strong, nonatomic) UIImageView *peakView_2;
@property (strong, nonatomic) UIImageView *peakView_3;
@property (strong, nonatomic) UIImageView *peakView_4;

@end

@implementation HXSquareView

- (instancetype)initWithFrame:(CGRect)frame fillColor:(UIColor*)fillCollor peakColor:(UIColor*)peakColor peakView:(UIImageView*)peakView {
    self = [super initWithFrame:frame];
    if (self) {
        _fillCollor = fillCollor;
        _peakColor = peakColor;
        self.peakView = peakView;
        
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews {
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = _fillCollor;
}

- (UIView *)contentView {
    if (!_contentView) {
        CGFloat peakView_width = CGRectGetWidth(self.frame)/15.0;

        _contentView = [[UIView alloc] initWithFrame:CGRectMake(peakView_width/2.0, peakView_width/2.0, self.frame.size.width-peakView_width, self.frame.size.height-peakView_width)];
        _contentView.layer.cornerRadius = 5.0;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (void)setPeakView:(UIImageView *)peakView {
    _peakView = peakView;
    
    if (_peakView) {
        if ([_peakView_1 superview]) {
            [_peakView_1 removeFromSuperview];
        }
        CGFloat peakView_width = CGRectGetWidth(self.frame)/15.0;
        _peakView_1 = [self copyView:_peakView];
        _peakView_1.frame = CGRectMake(0, 0, peakView_width, peakView_width);
        _peakView_1.image = [_peakView_1.image imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
        _peakView_1.tintColor = _peakColor;
        [self addSubview:_peakView_1];
        
        if ([_peakView_2 superview]) {
            [_peakView_2 removeFromSuperview];
        }
        _peakView_2 = [self copyView:_peakView];
        _peakView_2.frame = CGRectMake(CGRectGetWidth(self.frame) -peakView_width, 0, peakView_width, peakView_width);
        _peakView_2.image = [_peakView_2.image imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
        _peakView_2.tintColor = _peakColor;
        [self addSubview:_peakView_2];
        
        if ([_peakView_3 superview]) {
            [_peakView_3 removeFromSuperview];
        }
        _peakView_3 = [self copyView:_peakView];
        _peakView_3.frame = CGRectMake(0, CGRectGetHeight(self.frame)-peakView_width, peakView_width, peakView_width);
        _peakView_3.image = [_peakView_3.image imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
        _peakView_3.tintColor = _peakColor;
        [self addSubview:_peakView_3];
        
        if ([_peakView_4 superview]) {
            [_peakView_4 removeFromSuperview];
        }
        _peakView_4 = [self copyView:_peakView];
        _peakView_4.frame = CGRectMake(CGRectGetWidth(self.frame)-peakView_width, CGRectGetHeight(self.frame)-peakView_width, peakView_width, peakView_width);
        _peakView_4.image = [_peakView_4.image imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
        _peakView_4.tintColor = _peakColor;
        [self addSubview:_peakView_4];
    }
}

- (UIImageView *)copyView:(UIImageView *)view{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}

- (void)responseResultToDefault {
    _peakView_1.tintColor = _peakColor;
    _peakView_2.tintColor = _peakColor;
    _peakView_3.tintColor = _peakColor;
    _peakView_4.tintColor = _peakColor;

}
- (void)responseResultWithSuccess:(BOOL)success {
    if (success) {
        _peakView_1.tintColor = [UIColor greenColor];
        _peakView_2.tintColor = [UIColor greenColor];
        _peakView_3.tintColor = [UIColor greenColor];
        _peakView_4.tintColor = [UIColor greenColor];
    } else {
        _peakView_1.tintColor = [UIColor redColor];
        _peakView_2.tintColor = [UIColor redColor];
        _peakView_3.tintColor = [UIColor redColor];
        _peakView_4.tintColor = [UIColor redColor];
    }
}

@end
