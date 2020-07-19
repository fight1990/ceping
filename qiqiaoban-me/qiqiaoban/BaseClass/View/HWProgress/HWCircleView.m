//
//  HWCircleView.m
//  HWProgress
//
//  Created by sxmaps_w on 2017/3/3.
//  Copyright © 2017年 hero_wqb. All rights reserved.
//

#import "HWCircleView.h"

#define KHWCircleLineWidth 10.0f
#define KHWCircleFont [UIFont boldSystemFontOfSize:65.0f]
#define KHWCircleColor [UIColor whiteColor]
#define KHWCircleBackgroundColor [UIColor lightGrayColor]

@interface HWCircleView ()

@property (nonatomic, strong) UILabel *cLabel;

@end

@implementation HWCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _lineWidth = KHWCircleLineWidth;
        
        [self addSubview:self.cLabel];
    }
    
    return self;
}

- (UILabel *)cLabel {
    if (!_cLabel) {
        //百分比标签
        _cLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _cLabel.font = KHWCircleFont;
        _cLabel.textColor = KHWCircleColor;
        _cLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cLabel;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    self.cLabel.text = [NSString stringWithFormat:@"%d", (int)ceil(self.maxNumber * _progress)];
    
    [self setNeedsDisplay];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.cLabel.textColor = _titleColor;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.cLabel.font = _titleFont;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    
    [super drawRect:rect];
    
    //路径
    UIBezierPath *path_background = [[UIBezierPath alloc] init];
    //线宽
    path_background.lineWidth = _lineWidth;
    //颜色
    [KHWCircleBackgroundColor set];
    //拐角
    path_background.lineCapStyle = kCGLineCapRound;
    path_background.lineJoinStyle = kCGLineJoinRound;
    //半径
    CGFloat radius_background = (MIN(rect.size.width, rect.size.height) - _lineWidth) * 0.5;
    //画弧（参数：中心、半径、起始角度(3点钟方向为0)、结束角度、是否顺时针）
    [path_background addArcWithCenter:(CGPoint){rect.size.width * 0.5, rect.size.height * 0.5} radius:radius_background startAngle:M_PI * 1.5 endAngle:M_PI * 1.5 + M_PI * 2 clockwise:YES];
    //连线
    [path_background stroke];
    [path_background closePath];
    
    //路径
    UIBezierPath *path = [[UIBezierPath alloc] init];
    //线宽
    path.lineWidth = _lineWidth;
    //颜色
    [KHWCircleColor set];
    //拐角
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    //半径
    CGFloat radius = (MIN(rect.size.width, rect.size.height) - _lineWidth) * 0.5;
    //画弧（参数：中心、半径、起始角度(3点钟方向为0)、结束角度、是否顺时针）
    [path addArcWithCenter:(CGPoint){rect.size.width * 0.5, rect.size.height * 0.5} radius:radius startAngle:M_PI * 1.5 endAngle:M_PI * 1.5 + M_PI * 2 * _progress clockwise:YES];
    //连线
    [path stroke];
}

@end

