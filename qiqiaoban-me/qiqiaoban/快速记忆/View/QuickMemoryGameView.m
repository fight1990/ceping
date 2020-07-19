//
//  QuickMemoryGameView.m
//  qiqiaoban
//
//  Created by Wei on 2019/8/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QuickMemoryGameView.h"
#import "HXSquareView.h"
#import "MacroDefinition.h"
#import "HXWaterWaveView.h"

@interface QuickMemoryGameView ()

@property (strong, nonatomic) HXSquareView *squareView_1;
@property (strong, nonatomic) HXSquareView *squareView_2;
@property (strong, nonatomic) HXSquareView *squareView_3;
@property (strong, nonatomic) HXSquareView *squareView_4;
@property (strong, nonatomic) UIImageView  *squareView_peakView;

@property (strong, nonatomic) UIView *cicrleView;
@property (strong, nonatomic) HXWaterWaveView *waterWaveView;


@end

@implementation QuickMemoryGameView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self drawGameView];
    }
    
    return self;
}

- (void)drawGameView {
    [self addSubview:self.squareView_1];
    [self addSubview:self.squareView_2];
    [self addSubview:self.squareView_3];
    [self addSubview:self.squareView_4];
    [self addSubview:self.cicrleView];
    [self addSubview:self.waterWaveView];

}

#pragma mark Getting && Setting
- (HXSquareView *)squareView_1 {
    if (!_squareView_1) {
        _squareView_1 = [[HXSquareView alloc] initWithFrame:self.bounds fillColor:[UIColorFromRGB(0x3399ff) colorWithAlphaComponent:0.85] peakColor:[UIColor whiteColor] peakView:nil];
        _squareView_1.peakView = self.squareView_peakView;
    }
    return _squareView_1;
}

- (HXSquareView *)squareView_2 {
    if (!_squareView_2) {
        _squareView_2 = [[HXSquareView alloc] initWithFrame:self.bounds fillColor:[UIColorFromRGB(0x3399ff) colorWithAlphaComponent:0.85] peakColor:[UIColor whiteColor] peakView:nil];
        _squareView_2.peakView = self.squareView_peakView;
        _squareView_2.transform = CGAffineTransformMakeRotation(M_PI*0.25);

    }
    return _squareView_2;
}

- (HXSquareView *)squareView_3 {
    if (!_squareView_3) {
        _squareView_3 = [[HXSquareView alloc] initWithFrame:self.bounds fillColor:[UIColorFromRGB(0x3399ff) colorWithAlphaComponent:0.15] peakColor:[UIColor whiteColor] peakView:nil];
        _squareView_3.transform = CGAffineTransformMakeRotation(M_PI/8.0);
    }
    return _squareView_3;
}

- (HXSquareView *)squareView_4 {
    if (!_squareView_4) {
        _squareView_4 = [[HXSquareView alloc] initWithFrame:self.bounds fillColor:[UIColorFromRGB(0x3399ff) colorWithAlphaComponent:0.15] peakColor:[UIColor whiteColor] peakView:nil];
        _squareView_4.transform = CGAffineTransformMakeRotation(M_PI/8.0*3.0);
    }
    return _squareView_4;
}

- (UIImageView *)squareView_peakView {
    if (!_squareView_peakView) {
        _squareView_peakView = [[UIImageView alloc] init];
        _squareView_peakView.image = [UIImage imageNamed:@"quickFlashShape_1"];
        _squareView_peakView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _squareView_peakView;
}

- (UIView *)cicrleView {
    if (!_cicrleView) {
        CGFloat padding = CGRectGetWidth(self.frame)/15.0+10.0;

        _cicrleView = [[UIView alloc] initWithFrame:CGRectMake(padding/2.0, padding/2.0, CGRectGetWidth(self.frame)-padding, CGRectGetHeight(self.frame)-padding)];
        _cicrleView.backgroundColor = [UIColor whiteColor];
        _cicrleView.layer.cornerRadius = CGRectGetWidth(_cicrleView.frame)/2.0;
        _cicrleView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.65].CGColor;
        _cicrleView.layer.borderWidth = 2.0;
        _cicrleView.layer.masksToBounds = YES;
    }
    return _cicrleView;
}

- (HXWaterWaveView *)waterWaveView {
    if (!_waterWaveView) {
        CGFloat padding = CGRectGetWidth(self.frame)/15.0*4+10;

        _waterWaveView = [[HXWaterWaveView alloc] initWithFrame:CGRectMake(padding/2.0, padding/2.0, CGRectGetWidth(self.frame)-padding, CGRectGetHeight(self.frame)-padding)];
        _waterWaveView.progress = 1.0;

    }
    return _waterWaveView;
}

- (void)startAnimationPlay {
    [self.waterWaveView startAnimationPlay];
}

- (void)initInfo {
    [self.waterWaveView initInfo];
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    self.waterWaveView.progress = _progress;
}

- (void)setLevelModel:(QuickMemoryLevelModel *)levelModel {
    _levelModel = levelModel;
    [self.waterWaveView removeDisplayLinkAction];
    [self.waterWaveView setPeakType:[_levelModel.graphShapes[rand()%_levelModel.graphShapes.count]  integerValue] byType:_levelModel.byType peakCount:_levelModel.drawCount colors:_levelModel.colors];
}

- (void)setHiddenTitle:(BOOL)hiddenTitle {
    _hiddenTitle = hiddenTitle;
    self.waterWaveView.hiddenTitle = _hiddenTitle;
}


- (void)responseResultToDefault {
    [self.squareView_1 responseResultToDefault];
    [self.squareView_2 responseResultToDefault];
    [self.squareView_3 responseResultToDefault];
    [self.squareView_4 responseResultToDefault];

}
- (void)responseResultWithSuccess:(BOOL)success {
    [self.squareView_1 responseResultWithSuccess:success];
    [self.squareView_2 responseResultWithSuccess:success];
    [self.squareView_3 responseResultWithSuccess:success];
    [self.squareView_4 responseResultWithSuccess:success];

}
@end
