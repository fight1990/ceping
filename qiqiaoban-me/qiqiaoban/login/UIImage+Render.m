//
//  UIImage+Render.m
//  1.5-2015
//
//  Created by Mac on 16/1/8.
//  Copyright © 2016年 竞思. All rights reserved.
//

#import "UIImage+Render.h"

@implementation UIImage (Render)

//经过渲染的图片返回。
+(instancetype)imageWithRenderNamed:(NSString*)string{
    
    UIImage *image = [UIImage imageNamed:string];

    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

/**
 *  这个方法能返回一张指定颜色 透明度的图片
 *
 *  @param color 指定的颜色和透明度
 *
 *  @return 图片
 */

+(UIImage *)imageWithBgColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

-(UIColor*)imageToColor{

    UIColor *bgColor = [UIColor colorWithPatternImage: self];
    
    return bgColor;
    
}


- (UIImage *)scaleSize:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage; 
}


/** 设置圆形图片 */
- (UIImage *)cutCircleImage {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    // 获取上下文
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    // 设置圆形
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctr, rect);
    // 裁剪
    CGContextClip(ctr);
    // 将图片画上去
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
