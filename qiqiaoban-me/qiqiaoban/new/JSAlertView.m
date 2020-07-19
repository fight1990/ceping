
//
//  JSAlertView.m
//  qiqiaoban
//
//  Created by mac on 2019/3/20.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "JSAlertView.h"

#import "JSEDefine.h"

@interface JSAlertView ()

@property (nonatomic,retain) UIImageView *backView;

@property (nonatomic,retain) UILabel *titleLabel;

@property (nonatomic,retain) UILabel *scoreLabel;

@property (nonatomic,retain) UILabel *fuTitleLabel;

@property (nonatomic,retain) UIButton *quitButton;

@property (nonatomic,copy) void(^butClick)();


@end

@implementation JSAlertView

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
    self.backView = [[UIImageView alloc] init];
//    self.backView.backgroundColor = [UIColor whiteColor];
//    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backView];
    
    self.backView.image = [UIImage imageNamed:@"zainuli"];
    
    [self.backView sizeToFit];
    
    self.backView.userInteractionEnabled = YES;
    
    CGFloat scale =  self.width * .65 * 1.0 / self.backView.width;
    
    self.backView.width = self.backView.width * scale;
    
    self.backView.height = self.backView.height * scale;
    
    self.backView.centerX = self.width * .5;
    
    self.backView.centerY = self.height * .5;
    
    self.titleLabel = ({
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.opaque = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = JSBold(38);
//        [_titleLabel setAttributedText:[self.titleString attributedStringWithLineSpace:4 andWordSpace:0.5 andFont:JSFont(fontsize)]];
        _titleLabel.numberOfLines = 0;
        
        _titleLabel.width = self.backView.width;
        
        _titleLabel.height = 100;
        
        _titleLabel.x = 0;
        
        _titleLabel.centerY = self.backView.height * .35;
        
        [self.backView addSubview:_titleLabel];
        
        self.titleLabel;
    });
    
    self.scoreLabel = ({
    
        _scoreLabel =[[UILabel alloc] init];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        _scoreLabel.opaque = NO;
        _scoreLabel.backgroundColor = [UIColor clearColor];
        _scoreLabel.textColor = JSMainDarkPuer;
        _scoreLabel.font = JSBold(38);
        //        [_titleLabel setAttributedText:[self.titleString attributedStringWithLineSpace:4 andWordSpace:0.5 andFont:JSFont(fontsize)]];
        _scoreLabel.numberOfLines = 0;
        
        _scoreLabel.width = self.backView.width;
        
        _scoreLabel.height = 40;
        
        _scoreLabel.centerX = self.backView.width * .5;
        
        _scoreLabel.centerY = self.backView.height * .63;
        
        [self.backView addSubview:_scoreLabel];
        
        self.scoreLabel;
    });
    
    self.fuTitleLabel = ({
        
        _fuTitleLabel =[[UILabel alloc] init];
        _fuTitleLabel.textAlignment = NSTextAlignmentCenter;
        _fuTitleLabel.opaque = NO;
        _fuTitleLabel.textColor = JSLikeBlackColor;
        _fuTitleLabel.font = JSFont(20);
        //        [_titleLabel setAttributedText:[self.titleString attributedStringWithLineSpace:4 andWordSpace:0.5 andFont:JSFont(fontsize)]];
        _fuTitleLabel.numberOfLines = 0;
        
        _fuTitleLabel.width = self.backView.width;
        
        _fuTitleLabel.height = 40;
        _fuTitleLabel.centerX = self.backView.width * .5;
        _fuTitleLabel.y = CGRectGetMaxY(self.scoreLabel.frame);
        
        [self.backView addSubview:_fuTitleLabel];
        self.fuTitleLabel;
    });
    
    self.quitButton = ({
        
        UIButton *button = [[UIButton alloc] init];
        
        button.width = self.backView.width * .6;
        
        button.height = 50;
        
        button.centerX = self.backView.width * .50;
        
        button.y = CGRectGetMaxY(self.fuTitleLabel.frame);
        
        [button setBackgroundColor:JSMainPuer];
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        button.layer.cornerRadius = 25;
        
        button.layer.masksToBounds = YES;
        
        [self.backView addSubview:button];
        
        [button addTarget:self action:@selector(touchToButton:) forControlEvents:UIControlEventTouchUpInside];
        
        self.quitButton = button;
        
        self.quitButton;
    });


}

-(void)touchToButton:(UIButton *)sender{
    if (self.butClick) {
        self.butClick();
        }
}


//+(instancetype)showMessage:(NSString *)mes forView:(UIView *)view endFailus:(void(^)(BOOL isEnd))todo{
//    JSHud *hud = [[self alloc] init];
//    [hud showAnimation:view];
//    hud.titleString = mes;
//    [hud setUpSub];
//    hud.butClick = todo;
//    
//    return hud;
//    
//}

+(void)showAlertWithStyle:(JSAlertViewStyle)style title:(NSString *)title andFenshu:(NSString *)fenshu andFuBiao:(NSString *)fubiao andButtonTitle:(NSString *)buttonTitle endFailus:(void(^)())todo{
    
    
    
    JSAlertView *alert = [[self alloc] init];
    
    [alert showAnimation:nil];
    
    [alert setUpView];
    
    alert.titleLabel.text = title;
    
    alert.scoreLabel.text = fenshu;
    
    alert.fuTitleLabel.text = fubiao;
    
    [alert.quitButton setTitle:buttonTitle forState:UIControlStateNormal];
    
    alert.butClick = todo;
    
    if (style == JSAlertViewStyleOutTime) {
        [alert loadNewImage:@"zainuli"];
        alert.titleLabel.text = @"下次在努力吧";
        alert.scoreLabel.text = @"0分";
        alert.fuTitleLabel.text = @"答题超时";
    }else if (style == JSAlertViewStyleGiveUp){
        [alert loadNewImage:@"zainulishishi"];
        alert.titleLabel.text = @"跳过本轮,放弃作答";
        alert.scoreLabel.text = @"不自己试试";
        
        
        //跳过的时候 要再次确定
        
        UIButton *closeButton = [[UIButton alloc] init];
        
        [closeButton setBackgroundImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    
        [alert.backView addSubview:closeButton];
        
//        closeButton.backgroundColor = [UIColor redColor];
        
        closeButton.frame = CGRectMake(0, 0, 30, 30);
        
        closeButton.centerX = alert.backView.width * .82;
        
        closeButton.centerY = alert.backView.height * .2;
        
        [closeButton addTarget:alert action:@selector(touchClose:) forControlEvents:UIControlEventTouchUpInside];
        
    }else if (style == JSAlertViewStylePutong){
        [alert loadNewImage:@"youjinbu"];
    }else if (style == JSAlertViewStyleSeeAnswer){
        [alert loadNewImage:@"zainulishishi"];
        alert.titleLabel.text = @"查看答案,放弃作答";
        alert.scoreLabel.text = @"再努力试试";
        
        
        //跳过的时候 要再次确定
        
        UIButton *closeButton = [[UIButton alloc] init];
        
        [closeButton setBackgroundImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
        
        [alert.backView addSubview:closeButton];
        
        //        closeButton.backgroundColor = [UIColor redColor];
        
        closeButton.frame = CGRectMake(0, 0, 30, 30);
        
        closeButton.centerX = alert.backView.width * .82;
        
        closeButton.centerY = alert.backView.height * .2;
        
        [closeButton addTarget:alert action:@selector(touchClose:) forControlEvents:UIControlEventTouchUpInside];

        
        
    }else if (style == JSAlertViewStyleVeryGood){
        [alert loadNewImage:@"chaojilihai"];
        
    }else if (style == JSAlertViewStyleLevelUp){
        [alert loadNewImage:@"shengji"];
        
    }else{

    }
}



+(instancetype)showMessage:(NSString *)title forView:(UIView *)view andFenshu:(NSString *)fenshu andFuBiao:(NSString *)fubiao andButtonTitle:(NSString *)buttonTitle endFailus:(void(^)())todo;{

    JSAlertView *alert = [[self alloc] init];
    
    [alert showAnimation:view];
    
    [alert setUpView];
    
    alert.titleLabel.text = title;
    
    alert.scoreLabel.text = fenshu;
    
    alert.fuTitleLabel.text = fubiao;
    
    [alert.quitButton setTitle:buttonTitle forState:UIControlStateNormal];
    
    alert.butClick = todo;

    return alert;
}


-(void)showAnimation:(UIView *)view{
    if (!view) {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    self.frame = view.bounds;
    [view addSubview:self];
}
//重置位置


-(void)loadNewImage:(NSString *)imageName{

    self.backView.image = [UIImage imageNamed:imageName];
    
    [self.backView sizeToFit];
    
    CGFloat scale =  self.width * .65 * 1.0 / self.backView.width;
    
    self.backView.width = self.backView.width * scale;
    
    self.backView.height = self.backView.height * scale;
    
    self.backView.centerX = self.width * .5;
    
    self.backView.centerY = self.height * .5;
        
    _titleLabel.width = self.backView.width;
        
    _titleLabel.height = 100;
        
    _titleLabel.x = 0;
        
    _titleLabel.centerY = self.backView.height * .35;
    
    _scoreLabel.width = self.backView.width;
        
    _scoreLabel.height = 40;
        
    _scoreLabel.centerX = self.backView.width * .5;
        
    _scoreLabel.centerY = self.backView.height * .63;
        
    _fuTitleLabel.width = self.backView.width;
        
    _fuTitleLabel.height = 40;
    _fuTitleLabel.centerX = self.backView.width * .5;
    _fuTitleLabel.y = CGRectGetMaxY(self.scoreLabel.frame);
        
    _quitButton.width = self.backView.width * .6;
        
    _quitButton.height = 50;
        
    _quitButton.centerX = self.backView.width * .50;
    
    _quitButton.y = CGRectGetMaxY(self.fuTitleLabel.frame);
}


-(void)touchClose:(UIButton *)sender{

    [JSAlertView hideAlert];
    
}


//蒙版

#pragma mark - 背景蒙版
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);
    
    size_t gradLocationsNum = 2;
    
    
    //  定义颜色渐变位置
    //  第一个颜色开始渐变的位置
    //  第二个颜色结束渐变的位置
    CGFloat gradLocations[2] = {0.0f, 1.0f};
    
    //	定义渐变颜色组件
    //  每四个数一组，分别对应r,g,b,透明度
    CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.75f};
    
    //  定义色彩空间引用
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
    
    //	释放颜色空间
    CGColorSpaceRelease(colorSpace);
    //Gradient center
    CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    //Gradient radius
    float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
    //Gradient draw
    CGContextDrawRadialGradient (context, gradient, gradCenter,
                                 0, gradCenter, gradRadius,
                                 kCGGradientDrawsAfterEndLocation);
    
    //	释放渐变引用
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
    JSAlertView *alert  = [self JSForView:view];
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
            
            return (JSAlertView *)subview;
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
