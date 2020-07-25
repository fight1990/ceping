//
//  ImageModel.m
//  qiqiaoban
//
//  Created by mac on 2019/8/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ImageModel.h"

@implementation ImageModel

-(void)setUrlStr:(NSString *)urlStr{
    _urlStr = urlStr;
    _image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
}

@end
