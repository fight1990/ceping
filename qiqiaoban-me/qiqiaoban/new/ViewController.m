//
//  ViewController.m
//  QiQiaoBan
//
//  Created by mac on 2019/2/12.
//  Copyright © 2019年 mac. All rights reserved.
//  http://gl.ali213.net/html/2018-1/211229_41.html

#import "ViewController.h"
#import "QQShapeSqura.h"

#import "UIView+Frame.h"

#import "JSEDefine.h"

#import "QQShapeSqura.h"

#import "JSAlertView.h"

#import "INetworking.h"

#import "JSStudentInfoManager.h"

#import "NSDate+Extention.h"

#import <SVProgressHUD.h>

#import "EFCircularSlider.h"

#import "UIImage+ColorAtPixel.h"

#import "UIView+ImageExtention.h"

#import "UntouchableView.h"

@interface ViewController ()<UIGestureRecognizerDelegate>

//将所有的色块全部替换成 obshaped button 的按钮.
@property (strong, nonatomic) QQShapeSqura *triangle1;
@property (strong, nonatomic) QQShapeSqura *triangle2;
@property (strong, nonatomic) QQShapeSqura *triangle3;
@property (strong, nonatomic) QQShapeSqura *triangle4;
@property (strong, nonatomic) QQShapeSqura *triangle5;
@property (strong, nonatomic) QQShapeSqura *triangle6;
@property (strong, nonatomic) QQShapeSqura *triangle7;


@property (nonatomic,retain) UIButton *fanzhuanButton;

//用来记录这个图形翻转了多少次的属性.
@property (assign) NSInteger triangleCount1;
@property (assign) NSInteger triangleCount2;
@property (assign) NSInteger triangleCount3;
@property (assign) NSInteger triangleCount4;
@property (assign) NSInteger triangleCount5;
@property (assign) NSInteger triangleCount6;
@property (assign) NSInteger triangleCount7;

@property (nonatomic,assign) int roundCount;


@property (nonatomic,assign) NSInteger currentStudentPointNum;


@property (assign) int tapContorl;
//@property (assign) CGFloat scale;
//
@property (strong, nonatomic)UIColor  *borderColor;

//用于查看答案.
@property (nonatomic,retain) UIView *mengban;

//用于将所有的七巧板色块置于之上.
@property (nonatomic,retain) UIView *containQQBView;



@property (nonatomic,retain) UILabel *showPer;

@property (nonatomic,retain) UIImageView *sliderBack;

//是否应该停止线程的操作。
@property (nonatomic,assign) BOOL isShouldStopTheard;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isShouldStopTheard = YES;
    
    _tapContorl = 0;
    
    // 2 个小三角  2 个大三角.  1个 中三角.  1 个正方形 . 1个 菱形
    
    //边长为100    边长为200   中三角 长边为200  正方形 边长100 菱形短边为100;\
    
    
    self.containQQBView =  [[UIView alloc] init];
    
    _containQQBView.frame = self.view.bounds;
    
    _containQQBView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_containQQBView];
    
    self.triangle1 = [[QQShapeSqura alloc] initWithType:SquareTypeBigtriangle andWithWidth:80];
    self.triangle1.showImage = [UIImage imageNamed:@"1"];
    [self.triangle1 setOriginRightCount:0 andFanzhuan:NO];
    [self.containQQBView addSubview:self.triangle1];
    [self.triangle1 addTarget:self action:@selector(touchBut:) forControlEvents:UIControlEventTouchDown];
    self.triangle1.tag = 3;
    
    
    self.triangle2 = [[QQShapeSqura alloc] initWithType:SquareTypeMidTriangle andWithWidth:80];
    self.triangle2.showImage = [UIImage imageNamed:@"2"];
    [self.containQQBView addSubview:self.triangle2];
    [self.triangle2 setOriginRightCount:12 andFanzhuan:NO];
    [self.triangle2 addTarget:self action:@selector(touchBut:) forControlEvents:UIControlEventTouchDown];
    self.triangle2.tag = 5;
    
    
    self.triangle3 = [[QQShapeSqura alloc] initWithType:SquareTypeCorner andWithWidth:80];
    self.triangle3.showImage = [UIImage imageNamed:@"3"];
    [self.triangle3 setOriginRightCount:0 andFanzhuan:NO];
    [self.containQQBView addSubview:self.triangle3];
    [self.triangle3 addTarget:self action:@selector(touchBut:) forControlEvents:UIControlEventTouchDown];
    self.triangle3.tag = 7;
    
    
    self.triangle4 = [[QQShapeSqura alloc] initWithType:SquareTypeSmalltriangle andWithWidth:80];
    self.triangle4.showImage = [UIImage imageNamed:@"4"];
    [self.containQQBView addSubview:self.triangle4];
    [self.triangle4 setOriginRightCount:0 andFanzhuan:NO];
    [self.triangle4 addTarget:self action:@selector(touchBut:) forControlEvents:UIControlEventTouchDown];
    self.triangle4.tag = 1;
    
    
    self.triangle5 = [[QQShapeSqura alloc] initWithType:SquareTypeSmalltriangle andWithWidth:80];
    self.triangle5.showImage = [UIImage imageNamed:@"5"];
    [self.containQQBView addSubview:self.triangle5];
    [self.triangle5 setOriginRightCount:6 andFanzhuan:NO];
    [self.triangle5 addTarget:self action:@selector(touchBut:) forControlEvents:UIControlEventTouchDown];
    self.triangle5.tag = 2;
    
    
    self.triangle6 = [[QQShapeSqura alloc] initWithType:SquareTypeDiamond andWithWidth:80];
    self.triangle6.showImage = [UIImage imageNamed:@"6"];
    [self.containQQBView addSubview:self.triangle6];
    [self.triangle6 setOriginRightCount:0 andFanzhuan:NO];
    [self.triangle6 addTarget:self action:@selector(touchBut:) forControlEvents:UIControlEventTouchDown];
    self.triangle6.tag = 6;
    
    
    self.triangle7 = [[QQShapeSqura alloc] initWithType:SquareTypeBigtriangle andWithWidth:80];
    self.triangle7.showImage = [UIImage imageNamed:@"7"];
    [self.containQQBView addSubview:self.triangle7];
    [self.triangle7 setOriginRightCount:18 andFanzhuan:NO];
    [self.triangle7 addTarget:self action:@selector(touchBut:) forControlEvents:UIControlEventTouchDown];
    self.triangle7.tag = 4;
    
    
    //17 da  45 xiao 2 zhong  3 zheng 6 pingxing
    
    self.triangle1.x = 20;
    self.triangle1.y = JSFrame.size.height - 160 - 20;
    
    self.triangle7.x = 20 + 160 + 80 + 20;
    self.triangle7.y = self.triangle1.y;
    
    self.triangle4.x = 20;
    self.triangle4.y = CGRectGetMinY(self.triangle1.frame) - 80 - 20;
    
    self.triangle6.x = CGRectGetMaxX(self.triangle4.frame) + 10;
    self.triangle6.y = self.triangle4.y;
    
    self.triangle2.y = self.triangle4.y;
    self.triangle2.x = CGRectGetMaxX(self.triangle6.frame) + 10;
    
    self.triangle3.x = CGRectGetMaxX(self.triangle1.frame) - 30;
    self.triangle3.y = CGRectGetMaxY(self.triangle1.frame) - 40 - 80;
    
    self.triangle5.y = self.triangle3.y;
    self.triangle5.x = CGRectGetMaxX(self.triangle3.frame) + 20;
    
    
    
    
    _triangleCount1 = self.triangle1.rightCount;
    _triangleCount2 = self.triangle2.rightCount;
    _triangleCount3 = self.triangle3.rightCount;
    _triangleCount4 = self.triangle4.rightCount;
    _triangleCount5 = self.triangle5.rightCount;
    _triangleCount6 = self.triangle6.rightCount;
    _triangleCount7 = self.triangle7.rightCount;
    
    
    // pan拖拽移动手势
    UIPanGestureRecognizer *panGR1 = [[ UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan1:)];
    
    [self.triangle1 addGestureRecognizer:panGR1];
    
    UIPanGestureRecognizer *panGR2 = [[ UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan2:)];
    
    [self.triangle2 addGestureRecognizer:panGR2];
    
    UIPanGestureRecognizer *panGR3 = [[ UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan3:)];
    
    [self.triangle3 addGestureRecognizer:panGR3];
    
    UIPanGestureRecognizer *panGR4 = [[ UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan4:)];
    
    [self.triangle4 addGestureRecognizer:panGR4];
    
    UIPanGestureRecognizer *panGR5 = [[ UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan5:)];
    
    [self.triangle5 addGestureRecognizer:panGR5];
    
    UIPanGestureRecognizer *panGR6 = [[ UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan6:)];
    
    [self.triangle6 addGestureRecognizer:panGR6];
    
    UIPanGestureRecognizer *panGR7 = [[ UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan7:)];
    
    [self.triangle7 addGestureRecognizer:panGR7];
    
    
    
    
    
    
    UIImageView *sliderBack = [[UIImageView alloc] init];
    sliderBack.image = [UIImage imageNamed:@"zhuanpan"];
    self.sliderBack = sliderBack;
    
    [self.view addSubview:sliderBack];
    
    CGRect sliderFrame = CGRectMake(JSFrame.size.width-215, JSFrame.size.height-220, 200, 200);
    EFCircularSlider* circularSlider = [[EFCircularSlider alloc] initWithFrame:sliderFrame];
    [circularSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:circularSlider];
    
    
    sliderBack.bounds = circularSlider.bounds;
    
    sliderBack.centerX = circularSlider.centerX;
    sliderBack.centerY = circularSlider.centerY;
    
    
    UIButton *btn3 =[UIButton buttonWithType:0];
    [btn3 setTitle:@"翻转" forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn3 addTarget:self action:@selector(fanZhuan:) forControlEvents:UIControlEventTouchDown];
    btn3.frame =CGRectMake(10, 150, 76, 76);
    btn3.centerX = circularSlider.centerX;
    btn3.centerY = circularSlider.centerY;
    [self.view addSubview:btn3];
    btn3.backgroundColor = [UIColor whiteColor];
    btn3.layer.cornerRadius = 38;
    btn3.layer.masksToBounds = YES;
    self.fanzhuanButton = btn3;
    
    
    
    UILabel *showPer = [[UILabel alloc] init];
    
    showPer.textColor = [UIColor greenColor];
    
    showPer.font = JSBold(18);
    
    [self.view addSubview:showPer];
    
    showPer.frame = CGRectMake(JSFrame.size.width -100 - 50, 200, 120, 50);
    
    self.showPer = showPer;
}





-(void)touchBut:(UIButton *)sender{
    
    self.isShouldStopTheard = YES;
    
    [self.containQQBView insertSubview:sender atIndex:MAXFLOAT];
    
    if (sender == self.triangle1) {
        _tapContorl =100;
        
        self.sliderBack.transform = CGAffineTransformMakeRotation((M_PI/12)*(self.triangleCount1));
        
    }
    if (sender == self.triangle2) {
        _tapContorl =101;;
        self.sliderBack.transform = CGAffineTransformMakeRotation((M_PI/12)*(self.triangleCount2));    }
    if (sender == self.triangle3) {
        _tapContorl =102;;
        self.sliderBack.transform = CGAffineTransformMakeRotation((M_PI/12)*(self.triangleCount3));
    }
    if (sender == self.triangle4) {
        _tapContorl =103;;
        self.sliderBack.transform = CGAffineTransformMakeRotation((M_PI/12)*(self.triangleCount4));
    }
    if (sender == self.triangle5) {
        _tapContorl =104;;
        self.sliderBack.transform = CGAffineTransformMakeRotation((M_PI/12)*(self.triangleCount5));
    }
    if (sender == self.triangle6) {
        _tapContorl =105;;
        self.sliderBack.transform = CGAffineTransformMakeRotation((M_PI/12)*(self.triangleCount6));
    }
    if (sender == self.triangle7) {
        _tapContorl =106;;
        self.sliderBack.transform = CGAffineTransformMakeRotation((M_PI/12)*(self.triangleCount7));    }
}

//图片的移动
-(void)pan1:(UIPanGestureRecognizer *)gr{
    
    self.currentStudentPointNum = 0;
    
    CGPoint  translation = [gr translationInView:self.containQQBView];
    //双击不回 原因在此
    CGPoint center = self.triangle1.center;
    center.x += translation.x;
    center.y += translation.y;
    
    if (center.x < 90 || center.x > JSFrame.size.width-90 || center.y < 90 || center.y > JSFrame.size.height - 90) {
        return;
    }
    //JSFrame.size.width-215, JSFrame.size.height-220
    if (center.x >JSFrame.size.width - 215 -90&&center.y > JSFrame.size.height - 220 -90) {
        return;
    }
    
    
    self.triangle1.center = center;
    
    [gr setTranslation:CGPointZero inView:self.containQQBView];
    
    _tapContorl =100;
    if(gr.state == UIGestureRecognizerStateEnded){
        [self panOver];
    }
    
    
    
}

-(void)pan2:(UIPanGestureRecognizer *)gr
{
    
    self.currentStudentPointNum = 0;
    CGPoint  translation = [gr translationInView:self.containQQBView];
    //双击不回 原因在此
    CGPoint center = self.triangle2.center;
    center.x += translation.x;
    center.y += translation.y;
    
    if (center.x < 80 || center.x > JSFrame.size.width-80 || center.y < 80 || center.y > JSFrame.size.height - 90) {
        return;
    }
    if (center.x >JSFrame.size.width - 215 -90&&center.y > JSFrame.size.height - 220 -90) {
        return;
    }
    
    
    self.triangle2.center = center;
    
    [gr setTranslation:CGPointZero inView:self.containQQBView];
    
    _tapContorl =101;
    if(gr.state == UIGestureRecognizerStateEnded){
        [self panOver];
    }
}

-(void)pan3:(UIPanGestureRecognizer *)gr
{
    self.currentStudentPointNum = 0;
    CGPoint  translation = [gr translationInView:self.containQQBView];
    //双击不回 原因在此
    CGPoint center = self.triangle3.center;
    center.x += translation.x;
    center.y += translation.y;
    
    if (center.x < 80 || center.x > JSFrame.size.width-80 || center.y < 80 || center.y > JSFrame.size.height - 90) {
        return;
    }
    if (center.x >JSFrame.size.width - 215 -90&&center.y > JSFrame.size.height - 220 -90) {
        return;
    }
    
    
    self.triangle3.center = center;
    
    [gr setTranslation:CGPointZero inView:self.containQQBView];
    _tapContorl =102;
    if(gr.state == UIGestureRecognizerStateEnded){
        
        [self panOver];
    }
}

-(void)pan4:(UIPanGestureRecognizer *)gr
{
    
    self.currentStudentPointNum = 0;
    CGPoint  translation = [gr translationInView:self.containQQBView];
    //双击不回 原因在此
    CGPoint center = self.triangle4.center;
    center.x += translation.x;
    center.y += translation.y;
    
    if (center.x < 80 || center.x > JSFrame.size.width-80 || center.y < 80 || center.y > JSFrame.size.height - 90) {
        return;
    }
    if (center.x >JSFrame.size.width - 215 -90&&center.y > JSFrame.size.height - 220 -90) {
        return;
    }
    
    
    self.triangle4.center = center;
    
    [gr setTranslation:CGPointZero inView:self.containQQBView];
    _tapContorl =103;
    if(gr.state == UIGestureRecognizerStateEnded){
        
        [self panOver];
    }
}

-(void)pan5:(UIPanGestureRecognizer *)gr
{
    self.currentStudentPointNum = 0;
    CGPoint  translation = [gr translationInView:self.containQQBView];
    //双击不回 原因在此
    CGPoint center = self.triangle5.center;
    center.x += translation.x;
    center.y += translation.y;
    
    if (center.x < 80 || center.x > JSFrame.size.width-80 || center.y < 80 || center.y > JSFrame.size.height - 90) {
        return;
    }
    if (center.x >JSFrame.size.width - 215 -90&&center.y > JSFrame.size.height - 220 -90) {
        return;
    }
    
    
    self.triangle5.center = center;
    
    [gr setTranslation:CGPointZero inView:self.containQQBView];
    
    _tapContorl =104;
    if(gr.state == UIGestureRecognizerStateEnded){
        
        [self panOver];
    }
}
-(void)pan6:(UIPanGestureRecognizer *)gr
{
    
    self.currentStudentPointNum = 0;
    CGPoint  translation = [gr translationInView:self.containQQBView];
    //双击不回 原因在此
    CGPoint center = self.triangle6.center;
    center.x += translation.x;
    center.y += translation.y;
    
    if (center.x < 80 || center.x > JSFrame.size.width-80 || center.y < 80 || center.y > JSFrame.size.height - 90) {
        return;
    }
    
    if (center.x >JSFrame.size.width - 215 -90&&center.y > JSFrame.size.height - 220 -90) {
        return;
    }
    
    self.triangle6.center = center;
    
    [gr setTranslation:CGPointZero inView:self.containQQBView];
    
    _tapContorl =105;
    if(gr.state == UIGestureRecognizerStateEnded){
        
        [self panOver];
    }
}

-(void)pan7:(UIPanGestureRecognizer *)gr
{
    self.currentStudentPointNum = 0;
    
    CGPoint  translation = [gr translationInView:self.containQQBView];
    //双击不回 原因在此
    CGPoint center = self.triangle7.center;
    
    center.x += translation.x;
    center.y += translation.y;
    
    if (center.x < 80 || center.x > JSFrame.size.width-80 || center.y < 80 || center.y > JSFrame.size.height - 90) {
        return;
    }
    if (center.x >JSFrame.size.width - 215 -90&&center.y > JSFrame.size.height - 220 -90) {
        return;
    }
    
    
    self.triangle7.center = center;
    [gr setTranslation:CGPointZero inView:self.containQQBView];
    
    
    _tapContorl =106;
    if(gr.state == UIGestureRecognizerStateEnded){
        
        [self panOver];
    }
}


//一次手势结束了.
-(void)panOver{
    
    if (self.tips.currentTypeNum == 3) {
        [self caculateNewMeth];
        return;
    }
    
    
#pragma mark - 测试新的计算方式.
    
    self.currentStudentPointNum = 0;
    
    UIImage *answerImage = [self.tips convertViewToImage];
    
    UIImage *studentImage = [self.containQQBView convertViewToImage];
    
    self.isShouldStopTheard = NO;
    
    /*
     
     for (int x = self.tips.showAre.MinPoint.x; x < self.tips.showAre.MaxPoint.x; x += 5) {
     for (int y = self.tips.showAre.MinPoint.y; y < self.tips.showAre.MaxPoint.y; y += 5) {
     
     */
    
    //创建异步子线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int x = self.tips.showAre.MinPoint.x + 5; x < self.tips.showAre.MaxPoint.x - 5; x += 5) {
            
            
            //当做了其他操作的时候 立刻跳出计算.
            
            if (self.isShouldStopTheard) {
                NSLog(@"跳出外层循环了哦");
                break;
            }
            
            for (int y = self.tips.showAre.MinPoint.y + 5; y < self.tips.showAre.MaxPoint.y - 5; y += 5) {
                
                if (self.isShouldStopTheard) {
                    NSLog(@"跳出内层循环了哦");
                    break;
                }
                
                
                UIColor *answerColor = [answerImage colorAtPixel:CGPointMake(x, y)];
                
                UIColor *studentColor = [studentImage colorAtPixel:CGPointMake(x, y)];
                
                CGFloat answerAlpha = 0.0;
                CGFloat studentAlpha = 0.0;
                
                if ([answerColor respondsToSelector:@selector(getRed:green:blue:alpha:)])
                {
                    // available from iOS 5.0
                    [answerColor getRed:NULL green:NULL blue:NULL alpha:&answerAlpha];
                }
                else
                {
                    // for iOS < 5.0
                    // In iOS 6.1 this code is not working in release mode, it works only in
                    // CGColorGetAlpha always return 0.
                    CGColorRef cgPixelColor = [answerColor CGColor];
                    answerAlpha = CGColorGetAlpha(cgPixelColor);
                }
                
                
                if ([studentColor respondsToSelector:@selector(getRed:green:blue:alpha:)])
                {
                    // available from iOS 5.0
                    [studentColor getRed:NULL green:NULL blue:NULL alpha:&studentAlpha];
                }
                else
                {
                    // for iOS < 5.0
                    // In iOS 6.1 this code is not working in release mode, it works only in debug
                    // CGColorGetAlpha always return 0.
                    CGColorRef cgPixelColor = [studentColor CGColor];
                    studentAlpha = CGColorGetAlpha(cgPixelColor);
                }
                
                
                //            NSLog(@"答案显示%f___学生显示%f",answerAlpha,studentAlpha);
                
                if (answerAlpha >0.1 && studentAlpha > 0.1) {
                    
                    
                    self.currentStudentPointNum ++;
                }
            }
        }
        
        
        //        NSString *per = [NSString stringWithFormat:@"%d : %d",self.currentStudentPointNum,self.currentQQBPoint];
        
        NSString *per = [NSString stringWithFormat:@"%f",self.currentStudentPointNum*1.0/self.currentQQBPoint];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.showPer.text = per;
            
        });
        
        
        //用来判断是否可以判定当前已经完成了所有的七巧板色块摆放。
        CGFloat panduanNum = 0;
        
//        if (self.tips.currentTypeNum == 6) {
//            panduanNum = 0.970;
//        }else if (self.tips.currentTypeNum == 5) {
//            panduanNum = 0.965;
//        }else if (self.tips.currentTypeNum == 4) {
//            panduanNum = 0.960;
//        }else{
//            panduanNum = 0.953;
//        }
        if (self.tips.currentTypeNum == 6) {
            panduanNum = 0.980;
        }else if (self.tips.currentTypeNum == 5) {
            panduanNum = 0.980;
        }else if (self.tips.currentTypeNum == 4) {
            panduanNum = 0.980;
        }else{
            panduanNum = 0.980
            ;
        }
        
        
        if (self.currentStudentPointNum * 1.0 / self.currentQQBPoint > panduanNum) {
            NSLog(@"做题正确 . 你太狠了 ");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self overOneQQB];
            });
        }
    });
}



//如果是第三种 也就是 只是最上角显示图形的 显示方法就需要用到特殊的计算方式了。
-(void)caculateNewMeth{
    
    //三角形 必须 24 次
    //正方形 是   6次
    //平行四边形 是 12 次
    
    //保存和标准图形的相隔距离
    CGFloat offsetX = 0;
    CGFloat offsetY = 0;
    
    //首先判断的是中三角形。 因为中三角形 是唯一的。
    for (QQShapeSqura *squra in self.tips.containSquraArray) {
        if (squra.squareType == self.triangle2.squareType) {
            //这个设定应该还是可以用的。
            if ((squra.rightCount % 24) == (_triangleCount2 % 24)){
                offsetX = squra.centerX - self.triangle2.centerX;
                offsetY = squra.centerY -self.triangle2.centerY;
            }else{
                return;
            }
        }
    }
    
    //有限判断 唯一的图形。
    //接下来是正方形。   roger
    
    for (QQShapeSqura *squra in self.tips.containSquraArray) {
        //遍历处正确的squra
        if (squra.squareType == self.triangle3.squareType){
            if ((squra.rightCount % 6) == (_triangleCount3 % 6) ) {
                CGPoint newPoint = CGPointMake(squra.centerX - offsetX, squra.centerY - offsetY);
                if ([self distanceBetweenTwoPoint:newPoint point2:self.triangle3.center] < 20) {
                    
                }else{
                    //距离不对。
                    self.showPer.text = @"正方形距离不对";
                    return;
                }
            }else{
                //角度不对。
                self.showPer.text = @"正方形角度不对";
                return;
            }
        }
    }
    
    
    //接下里是平行四边形。
    
    //平行四边形
    for (QQShapeSqura *squra in self.tips.containSquraArray) {
        if (squra.squareType == self.triangle6.squareType ){
            
            if ((squra.rightCount % 12) == (_triangleCount6 % 12) && squra.isFanzhuan == self.triangle6.isFanzhuan) {
                
                CGPoint newPoint = CGPointMake(squra.centerX - offsetX, squra.centerY - offsetY);
                
                if ([self distanceBetweenTwoPoint:newPoint point2:self.triangle6.center] < 20) {

                }else{
                    self.showPer.text = @"四边形距离不对";
                    return;
                }
            }else{
                self.showPer.text = @"四边形角度不对";
                return;
            }
        }
    }
    
    
    //计算两个大三角形。
    
    BOOL isFind = NO;
    
    for (QQShapeSqura *squra in self.tips.containSquraArray) {
        if (squra.squareType==self.triangle1.squareType&&!squra.isSurePlace&&(squra.rightCount % 24) == (_triangleCount1 % 24)) {
            CGPoint newPoint = CGPointMake(squra.centerX - offsetX, squra.centerY - offsetY);
            NSLog(@"一个小三角相隔：%f",[self distanceBetweenTwoPoint:newPoint point2:self.triangle1.center]);
            if ([self distanceBetweenTwoPoint:newPoint point2:self.triangle1.center] < 20) {
                //正确的。
                squra.isSurePlace = YES;
                isFind = YES;
                break;
            }
        }
    }
    
    if (!isFind) {
        
        
        self.showPer.text = @"小三角不对";
        
        return;
    }
    
    
    
    //计算另外一个大三角形。 重置 参数。
    isFind = NO;
    
    for (QQShapeSqura *squra in self.tips.containSquraArray) {
        if (squra.squareType==self.triangle7.squareType&&!squra.isSurePlace&&(squra.rightCount % 24) == (_triangleCount7 % 24)) {
            CGPoint newPoint = CGPointMake(squra.centerX - offsetX, squra.centerY - offsetY);
            
            NSLog(@"一个小三角相隔：%f",[self distanceBetweenTwoPoint:newPoint point2:self.triangle5.center]);
            if ([self distanceBetweenTwoPoint:newPoint point2:self.triangle7.center] < 20) {
                //正确的。
                squra.isSurePlace = YES;
                isFind = YES;
                break;
            }
        }
    }
    
    if (!isFind) {
        //重置之前更改过的值。
        for (QQShapeSqura *squra in self.tips.containSquraArray) {
            squra.isSurePlace = NO;
        }
        
        self.showPer.text = @"小三角不对";
        return;
    }
    
    
    
    //计算两个小三角形
    
    isFind = NO;
    
    for (QQShapeSqura *squra in self.tips.containSquraArray) {
        if (squra.squareType==self.triangle4.squareType&&!squra.isSurePlace&&(squra.rightCount % 24) == (_triangleCount4 % 24)) {
            CGPoint newPoint = CGPointMake(squra.centerX - offsetX, squra.centerY - offsetY);
            
            NSLog(@"一个大三角相隔：%f",[self distanceBetweenTwoPoint:newPoint point2:self.triangle5.center]);
            if ([self distanceBetweenTwoPoint:newPoint point2:self.triangle4.center] < 20) {
                //正确的。
                squra.isSurePlace = YES;
                isFind = YES;
                break;
            }
        }
    }
    
    if (!isFind) {
        //重置之前更改过的值。
        for (QQShapeSqura *squra in self.tips.containSquraArray) {
            squra.isSurePlace = NO;
        }
        
        self.showPer.text = @"大三角不对";
        return;
    }
    
    //计算另外一个大三角形。 重置 参数。
    isFind = NO;
    
    for (QQShapeSqura *squra in self.tips.containSquraArray) {
        if (squra.squareType==self.triangle5.squareType&&!squra.isSurePlace&&(squra.rightCount % 24) == (_triangleCount5 % 24)) {
            CGPoint newPoint = CGPointMake(squra.centerX - offsetX, squra.centerY - offsetY);
            NSLog(@"一个大三角相隔：%f",[self distanceBetweenTwoPoint:newPoint point2:self.triangle5.center]);
            if ([self distanceBetweenTwoPoint:newPoint point2:self.triangle5.center] < 20) {
                //正确的。
                squra.isSurePlace = YES;
                isFind = YES;
                break;
            }
        }
    }
    if (!isFind) {
        //重置之前更改过的值。
        for (QQShapeSqura *squra in self.tips.containSquraArray) {
            squra.isSurePlace = NO;
        }
        
        self.showPer.text = @"大三角不对";
        return;
    }
    
    [self overOneQQB];
}

-(void)overOneQQB{
    
    self.timeView.hidden = YES;
    
    NSTimeInterval biaozhun = self.currentModel.standardTime.doubleValue;
    
    NSTimeInterval costTIme = self.currentMiaokeka;
    //
    CGFloat zhanbi = costTIme * 1.0 / biaozhun;
    
    NSString *fenshu;
    NSString *title;
    NSString *miao = [NSString stringWithFormat:@"本轮用时: %ld秒",(long)self.currentMiaokeka];
    JSAlertViewStyle style = JSAlertViewStylePutong;
    
    
    if (zhanbi >= 9) {
        fenshu = @"0";
        title = @"下次努力";
    }else if(zhanbi > 3){
        fenshu = @"10";
        title = @"下次努力";
    }else if(zhanbi > 1.5){
        fenshu = @"20";
        title = @"下次努力";
    }else if(zhanbi > 1){
        fenshu = @"40";
        title = @"有进步";
    }else if(zhanbi > 0.8){
        fenshu = @"60";
        title = @"有进步";
    }else if(zhanbi > 0.6){
        fenshu = @"70";
        title = @"你很棒";
    }else if(zhanbi > 0.4){
        fenshu = @"80";
        title = @"你很棒";
    }else if(zhanbi > 0.3){
        fenshu = @"90";
        title = @"超级厉害";
    }else if(zhanbi > 0.2){
        fenshu = @"100";
        title = @"超级厉害";
        style = JSAlertViewStyleVeryGood;
    }else{
        fenshu = @"105";
        title = @"超级厉害";
        style = JSAlertViewStyleVeryGood;
    }
    
    self.currentModel.currentScore = fenshu;
    self.currentModel.costTime = [NSString stringWithFormat:@"%ld",(long)self.currentMiaokeka];
    WeakObject(self);
    
    NSString *showFenshu = [NSString stringWithFormat:@"%@分",fenshu];
    
    
    //保存信息
    [selfWeak saveCurrentChengjiIn:^{
        
    }];
    
    
    
    if (self.currentModel.currentCountType == ShapeModelCountTypeTen) {
        [self showOverAlertWithFen:showFenshu];
    }
    else if (self.currentModel.currentCountType == ShapeModelCountTypeLess){
        
        [JSAlertView showAlertWithStyle:style title:title andFenshu:showFenshu andFuBiao:miao andButtonTitle:@"下一关" endFailus:^{
            
            [JSAlertView hideAlert];
            
            [SVProgressHUD showWithStatus:@"读取中"];
            
            
            [selfWeak showNewOne];
        }];
    }else{
        
        //超过10个了 . 不太可能
        
        
    }
}


//计算两点距离
-(float)distanceBetweenTwoPoint:(CGPoint)point1 point2:(CGPoint)point2
{
    return sqrtf(powf(point1.x - point2.x, 2) + powf(point1.y - point2.y, 2));
}


-(void)valueChanged:(EFCircularSlider*)slider  {
    self.isShouldStopTheard = YES;
    self.currentStudentPointNum = 0;
    
    if  (_tapContorl==100)  {
        int  newCount  =[[NSString  stringWithFormat:@"%.f",  ((slider.currentValue*360)/100)/15]  intValue];
        self.roundCount  =newCount;
        if  (newCount>self.triangleCount1)  {
            self.triangle1.transform  =  CGAffineTransformRotate(self.triangle1.transform,  (M_PI/12)*(newCount-self.triangleCount1));
            self.triangleCount1  =newCount;
        }else{
            self.triangle1.transform  =  CGAffineTransformRotate(self.triangle1.transform,  -(M_PI/12)*(self.triangleCount1-newCount));
            self.triangleCount1  =newCount;
        }
        
        //        self.sliderBack.transform = self.triangle1.transform;
        //        [self touchBut:self.triangle1];
        
        
        self.sliderBack.transform = CGAffineTransformMakeRotation((M_PI/12)*(self.triangleCount1));
        
    }else  if  (_tapContorl==101){
        int  newCount  =[[NSString  stringWithFormat:@"%.f",  ((slider.currentValue*360)/100)/15]  intValue];
        self.roundCount  =newCount;
        if  (newCount>self.triangleCount2)  {
            self.triangle2.transform  =  CGAffineTransformRotate(self.triangle2.transform,  (M_PI/12)*(newCount-self.triangleCount2));
            self.triangleCount2  =newCount;
        }else{
            self.triangle2.transform  =  CGAffineTransformRotate(self.triangle2.transform,  -(M_PI/12)*(self.triangleCount2-newCount));
            self.triangleCount2  =newCount;
        }
        
        
        //        self.sliderBack.transform = self.triangle2.transform;
        //        [self touchBut:self.triangle2];
        
        self.sliderBack.transform = CGAffineTransformMakeRotation((M_PI/12)*(self.triangleCount2));
    }else  if  (_tapContorl==102){
        int  newCount  =[[NSString  stringWithFormat:@"%.f",  ((slider.currentValue*360)/100)/15]  intValue];
        self.roundCount  =newCount;
        if  (newCount>self.triangleCount3)  {
            self.triangle3.transform  =  CGAffineTransformRotate(self.triangle3.transform,  (M_PI/12)*(newCount-self.triangleCount3));
            self.triangleCount3  =newCount;
        }else{
            self.triangle3.transform  =  CGAffineTransformRotate(self.triangle3.transform,  -(M_PI/12)*(self.triangleCount3-newCount));
            self.triangleCount3  =newCount;
        }
        
        
        //        self.sliderBack.transform = self.triangle3.transform;
        //        [self touchBut:self.triangle3];
        
        self.sliderBack.transform = CGAffineTransformMakeRotation((M_PI/12)*(self.triangleCount3));
    }else  if  (_tapContorl==103){
        int  newCount  =[[NSString  stringWithFormat:@"%.f",  ((slider.currentValue*360)/100)/15]  intValue];
        self.roundCount  =newCount;
        if  (newCount>self.triangleCount4)  {
            self.triangle4.transform  =  CGAffineTransformRotate(self.triangle4.transform,  (M_PI/12)*(newCount-self.triangleCount4));
            self.triangleCount4 =newCount;
        }else{
            self.triangle4.transform = CGAffineTransformRotate(self.triangle4.transform, -(M_PI/12)*(self.triangleCount4-newCount));
            self.triangleCount4 =newCount;
        }
        //        self.sliderBack.transform = self.triangle4.transform;
        //        [self touchBut:self.triangle4];
        
        self.sliderBack.transform = CGAffineTransformMakeRotation((M_PI/12)*(self.triangleCount4));
        
    }else if (_tapContorl==104){
        int newCount =[[NSString stringWithFormat:@"%.f", ((slider.currentValue*360)/100)/15] intValue];
        self.roundCount =newCount;
        if (newCount>self.triangleCount5) {
            self.triangle5.transform = CGAffineTransformRotate(self.triangle5.transform, (M_PI/12)*(newCount-self.triangleCount5));
            self.triangleCount5 =newCount;
        }else{
            self.triangle5.transform = CGAffineTransformRotate(self.triangle5.transform, -(M_PI/12)*(self.triangleCount5-newCount));
            self.triangleCount5 =newCount;
        }
        
        //        self.sliderBack.transform = self.triangle5.transform;
        //        [self touchBut:self.triangle5];
        
        self.sliderBack.transform = CGAffineTransformMakeRotation((M_PI/12)*(self.triangleCount5));
    }else if (_tapContorl==105){
        
        //这里就是 菱形。
        
        
        int newCount =[[NSString stringWithFormat:@"%.f", ((slider.currentValue*360)/100)/15] intValue];
        self.roundCount =newCount;
        
        //当前是翻转的情况系的显示效果。
        
        if (self.triangle6.isFanzhuan) {
            if (newCount>self.triangleCount6) {
                self.triangle6.transform = CGAffineTransformRotate(self.triangle6.transform, -(M_PI/12)*(newCount-self.triangleCount6));
                self.triangleCount6 =newCount;
            }else{
                self.triangle6.transform = CGAffineTransformRotate(self.triangle6.transform, (M_PI/12)*(self.triangleCount6-newCount));
                self.triangleCount6 =newCount;
            }
        }else{
            if (newCount>self.triangleCount6) {
                self.triangle6.transform = CGAffineTransformRotate(self.triangle6.transform, (M_PI/12)*(newCount-self.triangleCount6));
                self.triangleCount6 =newCount;
            }else{
                self.triangle6.transform = CGAffineTransformRotate(self.triangle6.transform, -(M_PI/12)*(self.triangleCount6-newCount));
                self.triangleCount6 =newCount;
            }
        }
        
        //        self.sliderBack.transform = self.triangle6.transform;
        //        [self touchBut:self.triangle6];
        
        self.sliderBack.transform = CGAffineTransformMakeRotation((M_PI/12)*(self.triangleCount6));
        
    }else if (_tapContorl==106){
        int newCount =[[NSString stringWithFormat:@"%.f", ((slider.currentValue*360)/100)/15] intValue];
        self.roundCount =newCount;
        if (newCount>self.triangleCount7) {
            self.triangle7.transform = CGAffineTransformRotate(self.triangle7.transform, (M_PI/12)*(newCount-self.triangleCount7));
            self.triangleCount7 =newCount;
        }else {
            self.triangle7.transform = CGAffineTransformRotate(self.triangle7.transform, -(M_PI/12)*(self.triangleCount7-newCount));
            self.triangleCount7 =newCount;
        }
        
        //        self.sliderBack.transform = self.triangle7.transform;
        //        [self touchBut:self.triangle7];
        
        self.sliderBack.transform = CGAffineTransformMakeRotation((M_PI/12)*(self.triangleCount7));
        
    }else{
        
    }
    
}


-(void)fanZhuan:(UIButton *)sender{
    if (!sender.selected) {
        
        //第一次翻转  也就是翻到反面。
        if ( _tapContorl==100) {
            self.triangle1.transform = CGAffineTransformRotate(self.triangle1.transform, M_PI);
            self.triangle1.isFanzhuan = YES;
            _triangleCount1 = _triangleCount1 + 12;
            [self touchBut:self.triangle1];
        }else if( _tapContorl==101) {
            self.triangle2.transform = CGAffineTransformRotate(self.triangle2.transform, M_PI);;
            self.triangle2.isFanzhuan = YES;
            
            _triangleCount2 = _triangleCount2 + 12;
            [self touchBut:self.triangle2];
        }else if( _tapContorl==102){
            self.triangle3.transform = CGAffineTransformRotate(self.triangle3.transform, M_PI);;
            _triangleCount3 = _triangleCount3 + 12;
            self.triangle3.isFanzhuan = YES;
            [self touchBut:self.triangle3];
        }else if( _tapContorl==103) {
            self.triangle4.transform = CGAffineTransformRotate(self.triangle4.transform, M_PI);
            _triangleCount4 = _triangleCount4 + 12;
            self.triangle4.isFanzhuan = YES;
            [self touchBut:self.triangle4];
        }else if( _tapContorl==104){
            self.triangle5.transform = CGAffineTransformRotate(self.triangle5.transform, M_PI);
            _triangleCount5 = _triangleCount5 + 12;
            self.triangle5.isFanzhuan = YES;
            [self touchBut:self.triangle5];
        }else if( _tapContorl==105) {
            
            sender.selected =!sender.selected;
            //这里翻转的是菱形。 所以是真的翻转。
            
            self.triangle6.transform = CGAffineTransformConcat(self.triangle6.transform, CGAffineTransformMakeScale(-1, 1));
            self.triangle6.isFanzhuan = YES;
            [self touchBut:self.triangle6];
            NSLog(@"菱形翻到反面了");
            
        }else if( _tapContorl==106){
            self.triangle7.transform = CGAffineTransformRotate(self.triangle7.transform, M_PI);;
            _triangleCount7 = _triangleCount7 + 12;
            self.triangle7.isFanzhuan = YES;
            [self touchBut:self.triangle7];
        }else{
            
        }
    }else{
        if ( _tapContorl==100) {
            self.triangle1.transform = CGAffineTransformRotate(self.triangle1.transform, M_PI);
            _triangleCount1 = _triangleCount1 + 12;
            self.triangle1.isFanzhuan = NO;
            [self touchBut:self.triangle1];
        }else if( _tapContorl==101) {
            self.triangle2.transform = CGAffineTransformRotate(self.triangle2.transform, M_PI);;
            _triangleCount2 = _triangleCount2 + 12;
            self.triangle2.isFanzhuan = NO;
            [self touchBut:self.triangle2];
        }else if( _tapContorl==102){
            self.triangle3.transform = CGAffineTransformRotate(self.triangle3.transform, M_PI);;
            _triangleCount3 = _triangleCount3 + 12;
            self.triangle3.isFanzhuan = NO;
            [self touchBut:self.triangle3];
        }else if( _tapContorl==103) {
            self.triangle4.transform = CGAffineTransformRotate(self.triangle4.transform, M_PI);
            _triangleCount4 = _triangleCount4 + 12;
            self.triangle4.isFanzhuan = NO;
            [self touchBut:self.triangle4];
        }else if( _tapContorl==104){
            self.triangle5.transform = CGAffineTransformRotate(self.triangle5.transform, M_PI);
            _triangleCount5 = _triangleCount5 + 12;
            self.triangle5.isFanzhuan = NO;
            [self touchBut:self.triangle5];
        }else if( _tapContorl==105) {
            sender.selected =!sender.selected;
            self.triangle6.transform = CGAffineTransformConcat(self.triangle6.transform, CGAffineTransformMakeScale(1, -1));
            self.triangle6.isFanzhuan = NO;
            
            NSLog(@"菱形翻到正面了");
            [self touchBut:self.triangle6];
        }else if( _tapContorl==106){
            self.triangle7.transform = CGAffineTransformRotate(self.triangle7.transform, M_PI);;
            _triangleCount7 = _triangleCount7 + 12;
            self.triangle7.isFanzhuan = NO;
            [self touchBut:self.triangle7];
        }else{
        }
        
        
    }
    
    
    
}


//去掉原本的view 显示新的 重置时间 对所有的view的初始位置进行富裕, 然后对所有的计算结算结果进行盐酸 .然后 将 时间和接口传送过来的时间进行计算出现分数,现在需要对所有分数进行上传的必要吗. 现在不需要 上传接口 这个接口现在不影响使用的话就暂时不添加这个东西了.


-(void)showNewOne{
    
    [self loadQQB];
    
    [self setUpAllViewOrigin];
}

//将每个七巧板 还原到原本的位置
-(void)setUpAllViewOrigin{
    [self.triangle1 setOriginRightCount:0 andFanzhuan:NO];
    
    [self.triangle2 setOriginRightCount:12 andFanzhuan:NO];
    
    [self.triangle3 setOriginRightCount:0 andFanzhuan:NO];
    
    [self.triangle4 setOriginRightCount:0 andFanzhuan:NO];
    
    [self.triangle5 setOriginRightCount:6 andFanzhuan:NO];
    
    [self.triangle6 setOriginRightCount:0 andFanzhuan:NO];
    
    [self.triangle7 setOriginRightCount:18 andFanzhuan:NO];
    
    
    self.triangle1.inRightPlace = NO;
    self.triangle2.inRightPlace = NO;
    self.triangle3.inRightPlace = NO;
    self.triangle4.inRightPlace = NO;
    self.triangle5.inRightPlace = NO;
    self.triangle6.inRightPlace = NO;
    self.triangle7.inRightPlace = NO;
    
    
    self.triangle1.userInteractionEnabled = YES;
    self.triangle2.userInteractionEnabled = YES;
    self.triangle3.userInteractionEnabled = YES;
    self.triangle4.userInteractionEnabled = YES;
    self.triangle5.userInteractionEnabled = YES;
    self.triangle6.userInteractionEnabled = YES;
    self.triangle7.userInteractionEnabled = YES;
    
    //按钮的selected 状态应该修改.
    
    self.fanzhuanButton.selected = NO;
    
    
    //17 da  45 xiao 2 zhong  3 zheng 6 pingxing
    
    self.triangle1.x = 20;
    self.triangle1.y = JSFrame.size.height - 160 - 20;
    
    self.triangle7.x = 20 + 160 + 80 + 20;
    self.triangle7.y = self.triangle1.y;
    
    self.triangle4.x = 20;
    self.triangle4.y = CGRectGetMinY(self.triangle1.frame) - 80 - 20;
    
    self.triangle6.x = CGRectGetMaxX(self.triangle4.frame) + 10;
    self.triangle6.y = self.triangle4.y;
    
    self.triangle2.y = self.triangle4.y;
    self.triangle2.x = CGRectGetMaxX(self.triangle6.frame) + 10;
    
    self.triangle3.x = CGRectGetMaxX(self.triangle1.frame) - 30;
    self.triangle3.y = CGRectGetMaxY(self.triangle1.frame) - 40 - 80;
    
    self.triangle5.y = self.triangle3.y;
    self.triangle5.x = CGRectGetMaxX(self.triangle3.frame) + 20;
    
    
    
    
    _triangleCount1 = self.triangle1.rightCount;
    _triangleCount2 = self.triangle2.rightCount;
    _triangleCount3 = self.triangle3.rightCount;
    _triangleCount4 = self.triangle4.rightCount;
    _triangleCount5 = self.triangle5.rightCount;
    _triangleCount6 = self.triangle6.rightCount;
    _triangleCount7 = self.triangle7.rightCount;
    
    
    //这里没有对每个色块的triangle的数值进行变更
}

//根据题型 可能还需要移动一些button;

-(void)setSomeTrianle{
    
    //如果有数据 就对响应的 七巧板进行操作.     提示等级的不同 有一些有颜色的需要移动.
    for (NSString *numStr in self.currentModel.selectSQCount) {
        
        NSLog(@"对色块进行移动 和 显示");
        
        //num 为shapeID;
        NSInteger num = [numStr integerValue] + 1;
        
        QQShapeSqura *sickButton = [self.containQQBView viewWithTag:num];
        
        for (ShapeModel *model in self.currentModel.ShapeModelArray) {
            
            if (model.shapeID.integerValue == num) {
                
                sickButton.userInteractionEnabled = NO;
                //这里对需要提示的色块进行位置的移动. 但是有些属性没有赋予. 后续如果有改动 需要注意这里的更改, 有可能引起bug;
                sickButton.centerX = model.xSize.floatValue;
                sickButton.centerY = model.ySize.floatValue;
                [sickButton setOriginRightCount:model.count andFanzhuan:model.isFanzhuan];
            }
        }
    }
}

-(void)clickQuit{
    
    self.currentModel.currentScore = @"3";
    self.currentModel.costTime = @"0";
    
    [self saveCurrentChengjiIn:^{
        
    }];
}


//如果当前是第10题目的话 就要显示不同的alert了吧.  而且 不需要读取新的题目了.

-(void)showOverAlertWithFen:(NSString *)fenshu{
    WeakObject(self);
    [JSAlertView showAlertWithStyle:JSAlertViewStyleVeryGood title:@"完成答题" andFenshu:fenshu andFuBiao:@"" andButtonTitle:@"返回主页" endFailus:^{
        
        [JSStudentInfoManager manager].isOverToday = YES;
        
        [JSAlertView hideAlert];
        
        [selfWeak dismissViewControllerAnimated:YES completion:nil];
    }];
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma mark - 评分  重写

-(void)loadQQBInfoOver{
    
    [self setSomeTrianle];
    
    [self.view insertSubview:self.tips atIndex:0];
    
    [self.view insertSubview:self.containQQBView atIndex:1];
}

-(void)tiaoGuo{
    
    if (self.mengban) {
        return;
    }
    
    
    WeakObject(self);
    
    
    if (self.currentModel.currentCountType == ShapeModelCountTypeTen) {
        
        
        [JSAlertView showAlertWithStyle:JSAlertViewStyleVeryGood title:@"完成答题" andFenshu:nil andFuBiao:nil andButtonTitle:@"返回主页" endFailus:^{
            
            [JSAlertView hideAlert];
            
            selfWeak.currentModel.currentScore = @"1";
            selfWeak.currentModel.costTime = @"0";
            
            [SVProgressHUD showWithStatus:@"读取中"];
            
            [selfWeak saveCurrentChengjiIn:^{
                
                [SVProgressHUD dismiss];
                [selfWeak dismissViewControllerAnimated:YES completion:nil];
                
            }];
        }];
    }
    else if (self.currentModel.currentCountType == ShapeModelCountTypeLess){
        
        [JSAlertView showAlertWithStyle:JSAlertViewStyleGiveUp title:nil andFenshu:nil andFuBiao:nil andButtonTitle:@"下一关" endFailus:^{
            
            selfWeak.currentModel.currentScore = @"1";
            selfWeak.currentModel.costTime = @"0";
            
            [SVProgressHUD showWithStatus:@"读取中"];
            
            [selfWeak saveCurrentChengjiIn:^{
                [selfWeak showNewOne];
            }];
        }];
    }else{
        
        //超过10个了 . 不太可能
        
        
    }
}


//显示答案和按钮.   点击 按钮, 显示alert  隐藏时间按钮.
-(void)chakanAnswer{
    WeakObject(self);
    //展示弹出窗口.
    [JSAlertView showAlertWithStyle:JSAlertViewStyleSeeAnswer title:nil andFenshu:nil andFuBiao:nil andButtonTitle:@"查看答案" endFailus:^{
        
        [JSAlertView hideAlert];
        
        [selfWeak.tips showAnswer];
        
        [selfWeak setUpAllViewOrigin];
        
        [selfWeak showMengbanAndButton];
        
    }];
}

-(void)showMengbanAndButton{
    
    UIView *mengban = [[UIView alloc] init];
    
    mengban.frame = self.view.bounds;
    
    mengban.y = 0;
    
    mengban.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:mengban];
    
    self.mengban = mengban;
    
    UIButton *tiaoButton = [[UIButton alloc] init];
    tiaoButton.backgroundColor = [UIColor clearColor];
    [tiaoButton setTitle:@"下一关" forState:UIControlStateNormal];
    [tiaoButton addTarget:self action:@selector(NextLevel) forControlEvents:UIControlEventTouchUpInside];
    tiaoButton.titleLabel.font = JSFont(25);
    [tiaoButton setTitleColor:JSLikeBlackColor forState:UIControlStateNormal];
    [tiaoButton sizeToFit];
    tiaoButton.y = 20;
    tiaoButton.x = JSFrame.size.width - tiaoButton.width - 20;
    [self.mengban addSubview:tiaoButton];
}

//发送成绩 然后读取新的题目.

-(void)NextLevel{
    WeakObject(self);
    self.timeView.hidden = YES;
    
    
    //现在就是第十道题目。
    if (self.currentModel.currentCountType == ShapeModelCountTypeTen) {
        
        [JSAlertView showAlertWithStyle:JSAlertViewStyleVeryGood title:@"完成答题" andFenshu:nil andFuBiao:nil andButtonTitle:@"返回主页" endFailus:^{
            
            [SVProgressHUD showWithStatus:@"上传得分"];
            
            //保存 测试信息
            self.currentModel.currentScore = @"2";
            self.currentModel.costTime = @"1";
            [self saveCurrentChengjiIn:^{
                [selfWeak dismissViewControllerAnimated:YES completion:nil];
            }];
        }];
    }
    else if (self.currentModel.currentCountType == ShapeModelCountTypeLess){
        
        //显示读条.
        [SVProgressHUD showWithStatus:@"读取中"];
        
        [self.mengban removeFromSuperview];
        
        self.mengban = nil;
        
        //保存 测试信息
        self.currentModel.currentScore = @"2";
        self.currentModel.costTime = @"1";
        [self saveCurrentChengjiIn:^{
            [selfWeak showNewOne];
        }];
        
    }else{
        //超过10个了 . 不太可能
    }
}


-(void)saveCurrentChengjiIn:(void(^)())endless{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"level"] = self.currentModel.level;
    dic[@"name"] = self.currentModel.QQBName;
    dic[@"number"] = self.currentModel.QQBNumber;
    dic[@"login_name"] = [JSStudentInfoManager manager].basicInfo.loginName;
    dic[@"stu_name"] = [JSStudentInfoManager manager].basicInfo.stuName;
    dic[@"used_times"] = self.currentModel.costTime;
    dic[@"center"] = [JSStudentInfoManager manager].basicInfo.centerName;
    dic[@"stuid"] = self.currentModel.ageGrounp;
    
    NSDate *birthDate = [NSDate JSDateFromString:[JSStudentInfoManager manager].basicInfo.birthday];
    
    NSString *birthStr = [birthDate dateToYear];
    
    NSInteger birthNum = [birthStr integerValue];
    
    NSString *currentStr = [[NSDate date] dateToYear];
    
    NSInteger currentNum = [currentStr integerValue];
    
    NSInteger age = currentNum - birthNum;
    
    dic[@"age"] = [NSString stringWithFormat:@"%ld",(long)age];
    
    dic[@"stu_score"] = self.currentModel.currentScore;
    
    [[INetworking shareNet] GET:@"http://114.55.90.93:8081/web/app/saveQqbrecords.json" withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        //super duty dirty owful
        endless();
        
    }];
}

@end


