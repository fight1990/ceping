//
//  JSShuDuAlertView.m
//  qiqiaoban
//
//  Created by mac on 2019/7/3.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "JSShuDuAlertView.h"
#import "UIView+Frame.h"
#import "JSEDefine.h"

@interface JSShuDuAlertView()


@property (nonatomic,retain) UIView *containView;


//背景图
@property (nonatomic,retain) UIImageView *backViewTop;

@property (nonatomic,retain) UIImageView *backViewBott;

//头像图
@property (nonatomic,retain) UIImageView *headImageView;

//分数背景图
@property (nonatomic,retain) UIImageView *scoreImageView;

@property (nonatomic,retain) UILabel *titleLabel;

@property (nonatomic,retain) UILabel *scoreLabel;

@property (nonatomic,retain) UILabel *fuTitleLabel;

@property (nonatomic,retain) UIButton *quitButton;

@property (nonatomic,copy) void(^butClick)();

@end


@implementation JSShuDuAlertView

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
    contain.backgroundColor = [UIColor darkGrayColor];
    contain.width = JSFrame.size.width * .48;
    contain.height = contain.width * 1.325;
    contain.layer.cornerRadius = 10;
    contain.layer.masksToBounds = YES;
    [self addSubview:contain];
    contain.centerX = self.width * .5;
    contain.centerY = self.height * .5;
    self.containView = contain;
    //讲top 像放入
    
    self.backViewTop = [[UIImageView alloc] init];
    self.backViewTop.userInteractionEnabled = YES;
    [self.containView addSubview:self.backViewTop];
    
    //创建bot; 放入
    UIImageView *backBot = [[UIImageView alloc] init];
    [self.containView addSubview:backBot];
    self.backViewBott = backBot;
    self.backViewBott.userInteractionEnabled = YES;
    
    //放入headImage 没有给定位置.
    UIImageView *headImage = [[UIImageView alloc] init];
    [self.containView addSubview:headImage];
    self.headImageView = headImage;
    
    
    //在这里放入分数背景  也不给定位置.
    
    UIImageView *scoreBack = [[UIImageView alloc] init];
    [self.containView addSubview:scoreBack];
    self.scoreImageView = scoreBack;
    
    
    
    self.titleLabel = ({
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.opaque = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = JSLikeBlackColor;
        _titleLabel.font = JSFont(33);
        _titleLabel.numberOfLines = 0;
//        _titleLabel.width = self.backView.width;
//        [_titleLabel setAttributedText:[self.titleString attributedStringWithLineSpace:4 andWordSpace:0.5 andFont:JSFont(fontsize)]];
//        _titleLabel.height = 100;
//        _titleLabel.x = 0;
//        _titleLabel.y = self.backView.height;
        [self.containView addSubview:_titleLabel];
        
        self.titleLabel;
    });
    

    self.fuTitleLabel = ({
        
        _fuTitleLabel =[[UILabel alloc] init];
        _fuTitleLabel.textAlignment = NSTextAlignmentCenter;
        _fuTitleLabel.opaque = NO;
        _fuTitleLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1];
        _fuTitleLabel.font = JSFont(17);
//        [_titleLabel setAttributedText:[self.titleString attributedStringWithLineSpace:4 andWordSpace:0.5 andFont:JSFont(fontsize)]];
        _fuTitleLabel.numberOfLines = 0;
        
//        _fuTitleLabel.width = self.backView.width;
//
//        _fuTitleLabel.height = 40;
//        _fuTitleLabel.centerX = self.backView.width * .5;
//        _fuTitleLabel.y = CGRectGetMaxY(self.titleLabel.frame) + 15;
        
        [self.containView addSubview:_fuTitleLabel];
        self.fuTitleLabel;
    });
    
    
    self.scoreLabel = ({
        
        _scoreLabel =[[UILabel alloc] init];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        _scoreLabel.opaque = NO;
        _scoreLabel.backgroundColor = [UIColor clearColor];
        _scoreLabel.textColor = JSColor(0, 170, 53, 1);
        _scoreLabel.font = JSFont(32);
        //        [_titleLabel setAttributedText:[self.titleString attributedStringWithLineSpace:4 andWordSpace:0.5 andFont:JSFont(fontsize)]];
        _scoreLabel.numberOfLines = 0;
        
//        _scoreLabel.width = self.backView.width;
//
//        _scoreLabel.height = 40;
//
//        _scoreLabel.centerX = self.backView.width * .5;
//
//        _scoreLabel.y = CGRectGetMaxY(self.fuTitleLabel.frame) + 20;
        
        [self.scoreImageView addSubview:_scoreLabel];
        
        self.scoreLabel;
    });
    
    self.quitButton = ({
        
        UIButton *button = [[UIButton alloc] init];
        
        //        button.width = self.backView.width * .6;
        //
        //        button.height = 50;
        //
        //        button.centerX = self.backView.width * .50;
        //
        //        button.y = CGRectGetMaxY(self.scoreLabel.frame) + 25;
        
        [button setBackgroundColor:[UIColor whiteColor]];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        button.layer.cornerRadius = 25;
        
        button.layer.masksToBounds = YES;
        
        [self.backViewBott addSubview:button];
        
        [button addTarget:self action:@selector(touchToButton:) forControlEvents:UIControlEventTouchUpInside];
        
        self.quitButton = button;
        
        self.quitButton;
    });
    
    
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


+(void)showAlertWithStyle:(JSShuDuAlertViewStyle)style title:(NSString *)title andFenshu:(NSString *)fenshu andFuBiao:(NSString *)fubiao andButtonTitle:(NSString *)buttonTitle endFailus:(void(^)())todo{
    
    //loadNewImage  在这个方法里面对 各个控件进行的位置的调整。
    
    JSShuDuAlertView *alert = [[self alloc] init];
    
    [alert showAnimation:nil];
    
    [alert setUpView];
    
    alert.titleLabel.text = title;
    
    alert.scoreLabel.text = fenshu;
    
    alert.style = style;
    
    alert.fuTitleLabel.text = fubiao;
    
    [alert.quitButton setTitle:buttonTitle forState:UIControlStateNormal];
    
    alert.butClick = todo;
    
    if (style == JSShuDuAlertViewStyleOutTime) {
        alert.titleLabel.text = @"做对了,但超时了\n真可惜.";
        alert.scoreLabel.text = @"0分";
        [alert loadHeadImage:@"超时1" andTopView:@"超时2"];
    }else if (style == JSShuDuAlertViewStyleVeryGood){
        
        //显示
        
        alert.titleLabel.text = @"你真棒";
        alert.scoreLabel.text = fenshu;
        [alert loadHeadImage:@"13就知道你能行80-1" andTopView:@"13就知道你能行80-3"];
    }else if (style == JSShuDuAlertViewStyleLevelDown){
        alert.scoreLabel.text = fenshu;
        alert.titleLabel.text = @"降级了";
        alert.fuTitleLabel.text = @"(连续两次失误降级)";
        [alert loadHeadImage:nil andTopView:nil];
    }else if (style == JSShuDuAlertViewStyleBujige){
        
        //显示
        
        alert.titleLabel.text = @"糟了，太可惜了";
        alert.scoreLabel.text = fenshu;
        [alert loadHeadImage:@"8糟糕失误了91-1" andTopView:@"8糟糕失误了91-3"];
    }else if (style == JSShuDuAlertViewStyleLodingError){
        
        //读取失败
        
        alert.titleLabel.text = @"匹配失败";
        alert.fuTitleLabel.text = @"请检查网络是否正常";
        [alert loadHeadImage:@"16匹配失败-1" andTopView:@"16匹配失败-3"];
    }else if (style == JSShuDuAlertViewStyleLoding){
        
        //读取
        
        alert.titleLabel.text = @"正在匹配题型";
        [alert loadHeadImage:@"17正在匹配3" andTopView:@"17正在匹配4"];
    }else if(style == JSShuDuAlertViewStyleLevelUp){
        alert.scoreLabel.text = fenshu;
        alert.fuTitleLabel.text = @"(连续两次失误降级)";
        alert.titleLabel.text = @"升级了";
        [alert loadHeadImage:nil andTopView:nil];
    }else if(style == JSShuDuAlertViewStyleNormal){
        
        //显示
        
        alert.scoreLabel.text = fenshu;
        alert.titleLabel.text = @"加油";
        [alert loadHeadImage:@"11每次的进步80-1" andTopView:@"11每次的进步80-3"];
    }else{
        
        
    }
}



+(instancetype)showMessage:(NSString *)title forView:(UIView *)view andFenshu:(NSString *)fenshu andFuBiao:(NSString *)fubiao andButtonTitle:(NSString *)buttonTitle endFailus:(void(^)())todo;{
    
    JSShuDuAlertView *alert = [[self alloc] init];
    
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


-(void)loadHeadImage:(NSString *)headImageNmae andTopView:(NSString *)backTopName{
    
    //确定top的位置.
    self.backViewTop.image = [UIImage imageNamed:backTopName];
    [self.backViewTop sizeToFit];
    CGFloat scale =  self.containView.width * 1.0 / self.backViewTop.width;
    self.backViewTop.width = self.backViewTop.width * scale;
    self.backViewTop.height = self.backViewTop.height * scale;
    self.backViewTop.y = 0;
    self.backViewTop.x = 0;
    
    
    //确定bot的位置.
    
    
    //并不是所有的都有bot
    if (self.style == JSShuDuAlertViewStyleBujige || self.style == JSShuDuAlertViewStyleOutTime || self.style == JSShuDuAlertViewStyleVeryGood||self.style == JSShuDuAlertViewStyleNormal) {
        
        
        
        //加上小太阳.
        
        if (self.style == JSShuDuAlertViewStyleVeryGood) {
            
            UIImageView *sun = [[UIImageView alloc] init];
            sun.frame = CGRectMake(0, 0, 160, 160);
            sun.image = [UIImage imageNamed:@"13你真棒90-1"];
            
            sun.centerX = self.containView.x;
            sun.centerY = self.containView.y;
            
            [self addSubview:sun];
        }
        
        
        //如果是超时要调整大小.
        
        if (self.style == JSShuDuAlertViewStyleOutTime) {
            _titleLabel.font = JSBold(25);
        }
        
        
        
        self.backViewBott.image = [UIImage imageNamed:@"14你真棒全答对90-5"];
        [self.backViewBott sizeToFit];
        CGFloat scaleBott =  self.containView.width * 1.0 / self.backViewBott.width;
        self.backViewBott.width = self.backViewBott.width * scaleBott;
        self.backViewBott.height = self.backViewBott.height * scaleBott;
        self.backViewBott.x = 0;
        self.backViewBott.y = self.containView.height - self.backViewBott.height;
        
        //按钮确定.
        _quitButton.width = self.containView.width * .6;
        _quitButton.height = 45;
        _quitButton.centerX = self.backViewBott.width * .5;
        _quitButton.centerY = self.backViewBott.height * .5;
        
        
        //确定几个label;
        [_titleLabel sizeToFit];
        [_fuTitleLabel sizeToFit];
        [_scoreLabel sizeToFit];
        
        
        //确定header位置.
        self.headImageView.image = [UIImage imageNamed:headImageNmae];
        [self.headImageView sizeToFit];
        
        CGFloat headScale = self.containView.width * .48 / self.headImageView.width;
        self.headImageView.width = self.headImageView.width * headScale;
        self.headImageView.height = self.headImageView.height * scale;
        
        self.headImageView.centerX = self.containView.width * .5;
        self.headImageView.y = 20;
        
        //先确定scaoreImage 和 scaoeLabel;
        
        
        _scoreImageView.image = [UIImage imageNamed:@"13就知道你能行80-2"];
        [_scoreImageView sizeToFit];
        CGFloat scaleScore =  self.containView.width * 1.0 / self.scoreImageView.width;
        self.scoreImageView.width = self.scoreImageView.width * scaleScore;
        self.scoreImageView.height = self.scoreImageView.height * scaleScore;
        self.scoreImageView.x = 0;
        self.scoreImageView.y = CGRectGetMinY(self.backViewBott.frame) - self.scoreImageView.height;
        self.scoreLabel.centerX = self.scoreImageView.width * .5;
        self.scoreLabel.centerY = self.scoreImageView.height * .67;
        
        //确定另外两个label;
        //这里不需要管副标题;
        
        self.fuTitleLabel.hidden = YES;
        CGFloat kongge = CGRectGetMinY(self.scoreImageView.frame) - CGRectGetMaxY(self.headImageView.frame);
        self.titleLabel.centerX = self.containView.width * .5;
        self.titleLabel.centerY = CGRectGetMinY(self.scoreImageView.frame) - kongge * .39;
    }else if (self.style == JSShuDuAlertViewStyleLoding) {
        //
        self.backViewBott.image = [UIImage imageNamed:@"17正在匹配2"];
        [self.backViewBott sizeToFit];
        CGFloat scaleBott =  self.containView.width * 1.0 / self.backViewBott.width;
        self.backViewBott.width = self.backViewBott.width * scaleBott;
        self.backViewBott.height = self.backViewBott.height * scaleBott;
        self.backViewBott.x = 0;
        self.backViewBott.y = self.containView.height - self.backViewBott.height;
        
        self.fuTitleLabel.hidden = YES;
        
        [self.titleLabel sizeToFit];
        
        self.titleLabel.centerX = self.containView.width * .5;
        self.titleLabel.centerY = self.containView.height * .75;
        
        self.quitButton.hidden = YES;
        
    }else if (self.style == JSShuDuAlertViewStyleLodingError) {
        //16匹配失败-2底部  16匹配失败-1 header
        self.backViewBott.image = [UIImage imageNamed:@"匹配失败-2"];
        [self.backViewBott sizeToFit];
        CGFloat scaleBott =  self.containView.width * 1.0 / self.backViewBott.width;
        self.backViewBott.width = self.backViewBott.width * scaleBott;
        self.backViewBott.height = self.backViewBott.height * scaleBott;
        self.backViewBott.x = 0;
        self.backViewBott.y = self.containView.height - self.backViewBott.height;
        
        
        //确认标题.
        self.fuTitleLabel.hidden = YES;
        
        [self.titleLabel sizeToFit];
        self.titleLabel.centerX = self.containView.width * .5;
        self.titleLabel.centerY = self.containView.height * .75;
        self.quitButton.hidden = YES;
        
        
        self.headImageView.image = [UIImage imageNamed:headImageNmae];
        [self.headImageView sizeToFit];
        self.headImageView.centerX = self.containView.width * .5;
        self.headImageView.y = 20;
        
    }else{
        
        
        
    }
    
    
//    _fuTitleLabel.centerX = self.backView.width * .5;
//    _fuTitleLabel.y = CGRectGetMaxY(self.titleLabel.frame) + 8;
//
//    _scoreLabel.centerX = self.backView.width * .5;
//
//    _scoreLabel.y = CGRectGetMaxY(self.fuTitleLabel.frame) + 8;
    
    

    
}


-(void)touchClose:(UIButton *)sender{
    
    [JSShuDuAlertView hideAlert];
    
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
    JSShuDuAlertView *alert  = [self JSForView:view];
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
            
            return (JSShuDuAlertView *)subview;
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
