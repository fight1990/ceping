//
//  LXTCircleView.m
//  qiqiaoban
//
//  Created by mac on 2019/8/26.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "LXTCircleView.h"

#define KHWCircleLineWidth 15.0f
#define KHWCircleFont [UIFont boldSystemFontOfSize:26.0f]
#define KHWCircleColor [UIColor colorWithRed:0/255.0 green:191/255.0 blue:255/255.0 alpha:1]

@interface LXTCircleView ()


@end

@implementation LXTCircleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
    }
    
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //路径
    UIBezierPath *path = [[UIBezierPath alloc] init];
    //线宽
    path.lineWidth = KHWCircleLineWidth;
    //颜色
    [[UIColor blackColor] set];
    //拐角
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    //半径
    CGFloat radius = (MIN(rect.size.width, rect.size.height) - KHWCircleLineWidth) * 0.5;
    //画弧（参数：中心、半径、起始角度(3点钟方向为0)、结束角度、是否顺时针）
    [path addArcWithCenter:(CGPoint){rect.size.width * 0.5, rect.size.height * 0.5} radius:radius startAngle:M_PI * 1.5 endAngle:M_PI * 1.5 + M_PI * 2 * 1 clockwise:YES];
    //连线
    [path stroke];
    
    
    //路径
    UIBezierPath *backgroundPath = [[UIBezierPath alloc] init];
    //线宽
    backgroundPath.lineWidth = KHWCircleLineWidth;
    //颜色
    [[UIColor whiteColor] set];
    //拐角
    backgroundPath.lineCapStyle = kCGLineCapRound;
    backgroundPath.lineJoinStyle = kCGLineJoinRound;
    //半径
    //    CGFloat radius = (MIN(rect.size.width, rect.size.height) - KHWCircleLineWidth) * 0.5;
    //画弧（参数：中心、半径、起始角度(3点钟方向为0)、结束角度、是否顺时针）
    [backgroundPath addArcWithCenter:(CGPoint){rect.size.width * 0.5, rect.size.height * 0.5} radius:radius startAngle:M_PI * 1.5 endAngle:M_PI * 1.5 + M_PI * 2 * _progress clockwise:YES];
    //连线
    [backgroundPath stroke];
}

@end
