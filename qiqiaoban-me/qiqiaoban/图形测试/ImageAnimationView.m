//
//  ImageAnimationView.m
//  qiqiaoban
//
//  Created by mac on 2019/8/28.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ImageAnimationView.h"

#import "UIView+Frame.h"

#import "JSEDefine.h"

#define boredWidth  20

#define offset  13


@interface ImageAnimationView ()<CAAnimationDelegate>

@property (nonatomic,retain) UIImageView *faceView;

@property (nonatomic,retain) UIImageView *midView;

@property (nonatomic,retain) UIImageView *bottomView;

@end

@implementation ImageAnimationView

-(void)setUpView{
    CATransform3D sublayerTransform = CATransform3DIdentity;//单位矩阵
    sublayerTransform.m34 = -1/500.0;
    [self.layer setSublayerTransform:sublayerTransform];
    
    self.faceView = [self getImageView];
    self.faceView.y = 0;
    
    self.midView = [self getImageView];
    self.midView.y = offset;
    
    self.bottomView = [self getImageView];
    self.bottomView.y = 2 * offset;
    
    self.faceView.layer.zPosition = 0;
    self.midView.layer.zPosition = - 30;
    self.bottomView.layer.zPosition = -60;
    
    self.faceView.image = [UIImage imageNamed:@"beijingphoto"];
    self.midView.image = [UIImage imageNamed:@"beijingphoto"];
    self.bottomView.image = [UIImage imageNamed:@"beijingphoto"];
    
    [self addSubview:self.faceView];
    [self addSubview:self.midView];
    [self addSubview:self.bottomView];
    
    
}

-(UIImageView *)getImageView{
    
    UIImageView *imageView = [[UIImageView alloc]init];
    
    imageView.frame = CGRectMake(0, 0, 100, 100);
    imageView.width = self.width;
    imageView.height = self.height - 2 * offset;
    imageView.layer.cornerRadius =5;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderColor = JSColor(224, 224, 224, 1).CGColor;
    imageView.layer.borderWidth = boredWidth;
    return imageView;
}



-(void)imageAnimationToShow:(UIImage *)image;{
    
    self.midView.image = image;
    
//    NSLog(@"%f",self.midView.layer.position.y);
    
    //用于切换的动画效果.
    //顶部view向上移动慢慢透明消失.
    CABasicAnimation *topViewMove = [CABasicAnimation animation];
    topViewMove.keyPath = @"zPosition";
    topViewMove.fromValue = @(0);
    topViewMove.toValue = @(30);
    
    
    CABasicAnimation *fade = [CABasicAnimation animation];
    fade.keyPath = @"opacity";
    fade.fromValue = @(1);
    fade.toValue = @(0);
    
    CABasicAnimation *faceMove = [CABasicAnimation animation];
    faceMove.keyPath = @"position.y";
    faceMove.fromValue = @(self.faceView.layer.position.y);
    faceMove.toValue = @(self.faceView.layer.position.y-offset);
    faceMove.duration = 0.5;
    faceMove.delegate = self;
    
    CAAnimationGroup *topGroup = [CAAnimationGroup animation];
    topGroup.animations = @[topViewMove,fade,faceMove];
    topGroup.duration = 0.46;
    topGroup.repeatCount = 1;
    topGroup.autoreverses = NO;
    topGroup.removedOnCompletion = NO;
    topGroup.delegate = self;
    topGroup.fillMode = kCAFillModeBackwards;
    
    [self.faceView.layer addAnimation:topGroup forKey:@"top"];
    
    
    
    //第二层midview的动画效果.
    CABasicAnimation *midViewMove = [CABasicAnimation animation];
    midViewMove.keyPath = @"zPosition";
    midViewMove.fromValue = @(-30);
    midViewMove.toValue = @(0);
    midViewMove.duration = 0.5;
    midViewMove.delegate = self;
    
    CABasicAnimation *midMove = [CABasicAnimation animation];
    midMove.keyPath = @"position.y";
    midMove.fromValue = @(self.midView.layer.position.y);
    midMove.toValue = @(self.midView.layer.position.y-offset);
    midMove.duration = 0.5;
    midMove.delegate = self;
    
    CAAnimationGroup *midGroup = [CAAnimationGroup animation];
    midGroup.animations = @[midViewMove,midMove];
    midGroup.duration = 0.5;
    midGroup.repeatCount = 1;
    midGroup.autoreverses = NO;
    midGroup.removedOnCompletion = NO;
    midGroup.delegate = self;
    midGroup.fillMode = kCAFillModeBackwards;
    [self.midView.layer addAnimation:midGroup forKey:@"mid"];
    
    
    
    
    //第三层bottomView 的动画效果.
    
    CABasicAnimation *botViewMove = [CABasicAnimation animation];
    botViewMove.keyPath = @"zPosition";
    botViewMove.fromValue = @(-60);
    botViewMove.toValue = @(-30);
    botViewMove.duration = 0.5;
    
    
    CABasicAnimation *botMove = [CABasicAnimation animation];
    botMove.keyPath = @"position.y";
    botMove.fromValue = @(self.bottomView.layer.position.y);
    botMove.toValue = @(self.bottomView.layer.position.y-offset);
    botMove.duration = 0.5;
    botMove.delegate = self;
    
    CAAnimationGroup *botGroup = [CAAnimationGroup animation];
    botGroup.animations = @[botViewMove,botMove];
    botGroup.duration = 0.5;
    botGroup.repeatCount = 1;
    botGroup.autoreverses = NO;
    botGroup.removedOnCompletion = NO;
    botGroup.delegate = self;
    botGroup.fillMode = kCAFillModeBackwards;
    [self.bottomView.layer addAnimation:botGroup forKey:@"mid"];
    
    _currentImage = image;
    
    self.faceView.alpha = 0;
}

-(void)setCurrentImage:(UIImage *)currentImage{
    
    _currentImage = currentImage;
    
    self.faceView.image = _currentImage;
    
}

#pragma mark - delegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    self.faceView.image = _currentImage;
    self.faceView.alpha = 1;
}

-(void)animationDidStart:(CAAnimation *)anim{
    
}


@end
