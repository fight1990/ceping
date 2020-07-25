//
//  NSString+Bounding.h
//  CNS
//
//  Created by Mac on 16/6/3.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface NSString (Bounding)

//这是最普通的计算.
-(CGRect)boundingRectWithSize:(CGSize)size strFont:(UIFont *)font;

-(NSAttributedString *)attributedStringWithLineSpace:(CGFloat)lineSpace andWordSpace:(CGFloat)wordSpace andFont:(UIFont*)font;

-(CGRect)getRectInLabelWithLineSpace:(CGFloat)lineSpace andWordSpace:(CGFloat)wordSpace andFont:(UIFont*)font WithSize:(CGSize)size;


-(NSAttributedString *)attributedStringWithLineSpace:(CGFloat)lineSpace andWordSpace:(CGFloat)wordSpace andFont:(UIFont*)font andAlignment:(NSTextAlignment)aligment;

-(CGRect)getRectInLabelWithLineSpace:(CGFloat)lineSpace andWordSpace:(CGFloat)wordSpace andFont:(UIFont*)font WithSize:(CGSize)size andAlignment:(NSTextAlignment)aligment;

@end


@interface TextInfo : NSObject


@end
