//
//  UIView+ImageExtention.m
//  qiqiaoban
//
//  Created by mac on 2019/4/10.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "UIView+ImageExtention.h"

@implementation UIView (ImageExtention)


//通过view得到一个image;
- (UIImage *)convertViewToImage
{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

@end
