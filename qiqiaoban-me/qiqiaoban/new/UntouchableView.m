//
//  UntouchableView.m
//  qiqiaoban
//
//  Created by mac on 2019/4/11.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "UntouchableView.h"
#import "UIImage+ColorAtPixel.h"
#import "UIView+ImageExtention.h"


@interface UntouchableView ()

@property (nonatomic,assign) CGPoint previousTouchPoint;

@property (nonatomic,assign) BOOL previousTouchHitTestResponse;

@end

@implementation UntouchableView


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // Return NO if even super returns NO (i.e., if point lies outside our bounds)
    BOOL superResult = [super pointInside:point withEvent:event];
    if (!superResult) {
        return superResult;
    }
    
    // Don't check again if we just queried the same point
    // (because pointInside:withEvent: gets often called multiple times)
    if (CGPointEqualToPoint(point, self.previousTouchPoint)) {
        return self.previousTouchHitTestResponse;
    } else {
        self.previousTouchPoint = point;
    }
    
    BOOL response = NO;
    
    UIImage *image = [self convertViewToImage];
    
    UIColor *pixelColor = [image colorAtPixel:point];
    CGFloat alpha = 0.0;
    
    if ([pixelColor respondsToSelector:@selector(getRed:green:blue:alpha:)])
    {
        // available from iOS 5.0
        [pixelColor getRed:NULL green:NULL blue:NULL alpha:&alpha];
    }
    else
    {
        // for iOS < 5.0
        // In iOS 6.1 this code is not working in release mode, it works only in debug
        // CGColorGetAlpha always return 0.
        CGColorRef cgPixelColor = [pixelColor CGColor];
        alpha = CGColorGetAlpha(cgPixelColor);
    }
    
    response = self.previousTouchHitTestResponse = alpha > 0.1;
    
    NSLog(@"这里判断了透明度");
    
    return response;
}



@end
