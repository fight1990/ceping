//
//  NSString+Bounding.m
//  CNS
//
//  Created by Mac on 16/6/3.
//  Copyright © 2016年 竞思教育. All rights reserved.
//

#import "NSString+Bounding.h"

@implementation NSString (Bounding)

-(CGRect)boundingRectWithSize:(CGSize)size strFont:(UIFont *)font{
    
    NSMutableDictionary *titleDic = [NSMutableDictionary dictionary];
    titleDic[NSFontAttributeName] = font;
    CGRect valueRect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:titleDic context:nil];
    return valueRect;   
}

-(NSAttributedString *)attributedStringWithLineSpace:(CGFloat)lineSpace andWordSpace:(CGFloat)wordSpace andFont:(UIFont*)font{
//    NSDictionary *dic = [self getAttributedDicWithLineSpace:lineSpace andWordSpace:wordSpace andFont:font andAlignment:NSTextAlignmentLeft];
//    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:self attributes:dic];
//    return attributeStr;
    
    return [self attributedStringWithLineSpace:lineSpace andWordSpace:wordSpace andFont:font andAlignment:NSTextAlignmentCenter];
    
}

-(CGRect)getRectInLabelWithLineSpace:(CGFloat)lineSpace andWordSpace:(CGFloat)wordSpace andFont:(UIFont*)font WithSize:(CGSize)size {
//    NSDictionary *dic = [self getAttributedDicWithLineSpace:lineSpace andWordSpace:wordSpace andFont:font andAlignment:NSTextAlignmentLeft];
//    CGRect valueRect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return [self getRectInLabelWithLineSpace:lineSpace andWordSpace:wordSpace andFont:font WithSize:size andAlignment:NSTextAlignmentLeft];
}



-(NSDictionary*)getAttributedDicWithLineSpace:(CGFloat)lineSpace andWordSpace:(CGFloat)wordSpace andFont:(UIFont*)font  andAlignment:(NSTextAlignment)aligment{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = aligment; //对齐方式
    paraStyle.lineSpacing = lineSpace; //设置行搞
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;  //首行头缩进
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0; //头部缩进
    paraStyle.tailIndent = 0; //右 padding
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@(wordSpace)};
    return dic;
}

-(NSAttributedString *)attributedStringWithLineSpace:(CGFloat)lineSpace andWordSpace:(CGFloat)wordSpace andFont:(UIFont*)font andAlignment:(NSTextAlignment)aligment{
    
    NSDictionary *dic = [self getAttributedDicWithLineSpace:lineSpace andWordSpace:wordSpace andFont:font andAlignment:aligment];
    NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:self attributes:dic];
    return attributeStr;

}

-(CGRect)getRectInLabelWithLineSpace:(CGFloat)lineSpace andWordSpace:(CGFloat)wordSpace andFont:(UIFont*)font WithSize:(CGSize)size andAlignment:(NSTextAlignment)aligment{
    NSDictionary *dic = [self getAttributedDicWithLineSpace:lineSpace andWordSpace:wordSpace andFont:font andAlignment:aligment];
    CGRect valueRect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return valueRect;

}




@end
