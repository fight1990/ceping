//
//  ImageAnimationView.h
//  qiqiaoban
//
//  Created by mac on 2019/8/28.
//  Copyright © 2019年 mac. All rights reserved.
//  用来做图片显示动画的view

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageAnimationView : UIView

-(void)setUpView;

-(void)imageAnimationToShow:(UIImage *)image;

@property (nonatomic,retain) UIImage *currentImage;


@end

NS_ASSUME_NONNULL_END
