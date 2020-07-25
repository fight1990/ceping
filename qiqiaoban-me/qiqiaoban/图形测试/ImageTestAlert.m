//
//  ImageTestAlert.m
//  qiqiaoban
//
//  Created by mac on 2019/8/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ImageTestAlert.h"

#import "JSEDefine.h"

@interface ImageTestAlert()

@property (nonatomic,retain) UIView *containView;

@property (nonatomic,retain) UIButton *quitButton;

@property (nonatomic,retain) UIButton *leftSButton;

@property (nonatomic,copy) void(^butClick)();


@property (nonatomic,retain) UIImageView *starLeft;
@property (nonatomic,retain) UIImageView *starMid;
@property (nonatomic,retain) UIImageView *starRight;

@property (nonatomic,retain) UILabel *timeLabel;

@property (nonatomic,retain) UILabel *contentLabel;

@end

@implementation ImageTestAlert



+(instancetype)alert{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)setUpView{
    //self.containView;
    self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.6];
    
    UIView *contain = [[UIView alloc] init];
    contain.backgroundColor = [UIColor whiteColor];
    contain.width = JSFrame.size.width * .48;
    contain.height = contain.width *.94;
    contain.layer.cornerRadius = 14;
    contain.layer.masksToBounds = YES;
    [self addSubview:contain];
    contain.centerX = self.width * .5;
    contain.centerY = self.height * .5;
    self.containView = contain;
    //讲top 像放入
    
    
    UIImageView *star1 = [[UIImageView alloc] init];
    star1.image = [UIImage imageNamed:@"tankuang-yuansu"];
    star1.frame = CGRectMake(0, 0, 100, 100);
    [self.containView addSubview:star1];
    
    UIImageView *star2 = [[UIImageView alloc] init];
    star2.image = [UIImage imageNamed:@"tankuang-yuansu"];
    star2.frame = CGRectMake(0, 0, 100, 100);
    [self addSubview:star2];
    
    UIImageView *star3 = [[UIImageView alloc] init];
    star3.image = [UIImage imageNamed:@"tankuang-yuansu"];
    star3.frame = CGRectMake(0, 0, 100, 100);
    [self.containView addSubview:star3];
    
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = JSFont(48);
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.textColor = [UIColor blackColor];
    [self.containView addSubview:_timeLabel];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = JSFont(25);
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.textColor = JSLikeBlackColor;
    [self.containView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
    UIButton *but = [[UIButton alloc] init];
    [but setTitle:@"下一关" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [but addTarget:self action:@selector(touchToButton:) forControlEvents:UIControlEventTouchUpInside];
    [but setBackgroundColor:JSColor(55, 55, 55, 1)];
    [self.containView addSubview:but];
    self.quitButton = but;
    
    
    UIButton *but2 = [[UIButton alloc] init];
//    [but2 setTitle:@"下一关" forState:UIControlStateNormal];
    
    [but2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [but2 addTarget:self action:@selector(touchClose:) forControlEvents:UIControlEventTouchUpInside];
//    [but2 setBackgroundColor:];
    [but2 setBackgroundImage:[UIImage imageNamed:@"guanbiimage"] forState:UIControlStateNormal];
    [self.containView addSubview:but2];
    self.leftSButton = but2;
    
    
    
    star2.centerX = self.width * .5;
    star2.y = CGRectGetMinY(self.containView.frame) - 15;
    
    star1.centerX = self.containView.width * .2;
    star1.centerY = self.containView.width * .2;
    star1.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.75, 0.75), CGAffineTransformMakeRotation(M_PI_4));
   
    star3.centerX = self.containView.width * .8;
    star3.centerY = self.containView.width * .2;
    star3.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.75, 0.75), CGAffineTransformMakeRotation(-M_PI_4));

    _timeLabel.width = 200;
    _timeLabel.height = 80;
    _timeLabel.centerX = self.containView.width * .5;
    _timeLabel.centerY = self.containView.height * .45;
    
    _contentLabel.width = self.containView.width;
    _contentLabel.height = 80;
    _contentLabel.centerX = self.containView.width * .5;
    _contentLabel.centerY = self.containView.height * .63;
    
    but.width = self.containView.width * .7;
    but.height = 50;
    but.layer.cornerRadius = 25;
    but.layer.masksToBounds = YES;
    but.centerX = self.containView.width * .5;
    but.centerY = self.containView.height * .83;
    
//    [but2 sizeToFit];
    but2.width = but2.height = 28;
    but2.y = 12;
    but2.x = self.containView.width - but2.width - 12;
    
    self.starLeft = star1;
    self.starMid = star2;
    self.starRight = star3;
    
}

-(void)touchToButton:(UIButton *)sender{
    
    //为了避免重复点击按钮 造成的问题。
    static BOOL isOn = NO;
    
    if (self.butClick && !isOn) {
        isOn = YES;
        self.butClick();
        isOn = NO;
    }
}


-(void)showAnimation:(UIView *)view{
    if (!view) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    self.frame = view.bounds;
    [view addSubview:self];
}
//重置位置



+(instancetype)showAlertWithStars:(NSInteger)star andTime:(NSTimeInterval)time andTotal:(NSInteger)total andRight:(NSInteger)right andButtonTitle:(NSString *)title endFailus:(void(^)())todo{
    
    ImageTestAlert *alert = [[self alloc] init];
    
    [alert showAnimation:nil];
    
    [alert setUpView];
    
    [alert.quitButton setTitle:title forState:UIControlStateNormal];
    
    alert.timeLabel.text = [NSString stringWithFormat:@"%.1f 秒",time];
    
    alert.contentLabel.text = [NSString stringWithFormat:@"答对%ld个,共计%ld个",(long)right,(long)total];
    
    if (star == 2) {
        alert.starRight.image = [UIImage imageNamed:@"tankuang-yuansu2"];
    }else if (star == 0){
        alert.starLeft.image = [UIImage imageNamed:@"tankuang-yuansu2"];
        alert.starMid.image = [UIImage imageNamed:@"tankuang-yuansu2"];
        alert.starRight.image = [UIImage imageNamed:@"tankuang-yuansu2"];
    }
    
    alert.butClick = todo;
    
    return alert;
}




-(void)touchClose:(UIButton *)sender{
    [ImageTestAlert hideAlert];
    
    if (self.butClose) {
        self.butClose();
    }
    
}




#pragma mark - 背景蒙版

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    size_t gradLocationsNum = 2;
    
    
    //  定义颜色渐变位置
    //  第一个颜色开始渐变的位置
    //  第二个颜色结束渐变的位置
    CGFloat gradLocations[2] = {0.0f, 1.0f};
    
    //    定义渐变颜色组件
    //  每四个数一组，分别对应r,g,b,透明度
    CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
    
    //  定义色彩空间引用
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
    
    //    释放颜色空间
    CGColorSpaceRelease(colorSpace);
    //Gradient center
    CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    //Gradient radius
    float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
    //Gradient draw
    CGContextDrawRadialGradient (context, gradient, gradCenter,
                                 0, gradCenter, gradRadius,
                                 kCGGradientDrawsAfterEndLocation);
    
    //    释放渐变引用
    CGGradientRelease(gradient);
}



//hide

//
+(void)hideAlert{
    [self JShideForView:nil];
}


//view为空的时候的补充.
+ (void)JShideForView:(UIView *)view
{
    if (view == nil)
        view = [[UIApplication sharedApplication].windows lastObject];
    [self JShideForView:view animated:YES];
}

//对方法的整合. 
+ (BOOL)JShideForView:(UIView *)view animated:(BOOL)animated {
    ImageTestAlert *alert  = [self JSForView:view];
    if (alert!= nil) {
        [alert hide];
        return YES;
    }
    return NO;
}

//遍历view 找到alert
+ (instancetype)JSForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (ImageTestAlert *)subview;
        }
    }
    return nil;
}

//动画效果 去掉view
-(void)hide{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
