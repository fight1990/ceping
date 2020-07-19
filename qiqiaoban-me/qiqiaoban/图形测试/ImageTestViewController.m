//
//  ImageTestViewController.m
//  qiqiaoban
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ImageTestViewController.h"
#import "JSEDefine.h"
#import "ImageAnimationView.h"
#import "INetworking.h"
#import "ImageModel.h"
#import "ImageTestAlert.h"
#import <SVProgressHUD.h>
#import "JSStudentInfoManager.h"


//关于无限关卡的很多地方需要修改.

//包括关卡 图片 分配.  关卡 选择部分的 显示.

//关卡结束的显示. "下一关按钮."


@interface ImageTestViewController ()<CAAnimationDelegate>

//记忆时间
@property (nonatomic,assign) NSTimeInterval memoryTime;

//测试时间
@property (nonatomic,assign) NSTimeInterval testTime;

//倒计时label
@property (nonatomic,retain) UILabel *timeDownLabel;

//倒计时动画layer
@property (nonatomic,retain) CAShapeLayer *timeDownShapeLayer;

//计时器
@property (nonatomic,weak) NSTimer *timer;


//用于计算时间和计算用户操作时间的button
@property (nonatomic,weak) NSTimer *testTimer;

@property (nonatomic,assign) NSTimeInterval currentPastTime;

@property (nonatomic,assign) NSTimeInterval userUseTime;

//进度条
@property (nonatomic,retain) UIView *progressView;
@property (nonatomic,retain) UILabel *showTotalLabel;

//进度条
@property (nonatomic,retain) UIView *showProgressView;
@property (nonatomic,retain) UILabel *showCurrentLabel;

//用来动画的 显示 图片
@property (nonatomic,retain) ImageAnimationView *showAnimationImageView;

//保存数据.
@property (nonatomic,retain) NSMutableArray *dataArray;

@property (nonatomic,retain) NSMutableArray *selectArray;

//当前显示的图片.
@property (nonatomic,assign) NSInteger currentShowIndex;


//做题时候的view

@property (nonatomic,retain) UIView *containBackView;

@property (nonatomic,retain) UIImageView *hongcha;
@property (nonatomic,retain) UIImageView *lvgou;

@property (nonatomic,assign) NSInteger selectRightCount;

@end

@implementation ImageTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    _selectArray = [NSMutableArray array];
    _currentShowIndex = 0;
    _selectRightCount = 0;
    [self setUpView];
    [self getInfo];
}

-(void)setLevel:(NSString *)level{
    
    _level = level;
    
    NSInteger levelNum = [_level integerValue];
    
    if (levelNum<7) {
        self.memoryTime = 3;
    }else if(levelNum < 14){
        self.memoryTime = 2;
    }else{
        self.memoryTime = 1;
    }
    
    if (levelNum <= 5) {
        self.testTime = 5;
    }else if(levelNum < 10){
        self.memoryTime = 4;
    }else if(levelNum < 15){
        self.memoryTime = 3;
    }else if(levelNum <= 20){
        self.memoryTime = 2;
    }
    
}

-(void)setUpView{
    
    //创建背景.
    UIImageView *backGro = [[UIImageView alloc] init];
    backGro.frame = CGRectMake(0, 0, JSFrame.size.width, JSFrame.size.height);
    backGro.image = [UIImage imageNamed:@"beijingphoto2"];
    [self.view addSubview:backGro];
    
    
    //创建topview
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    topView.frame = CGRectMake(0, 0, self.view.width, 80);
    [self.view addSubview:topView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor grayColor];
    lineView.frame = CGRectMake(0, 80, self.view.width, 1);
    [self.view addSubview:lineView];
    
    UIButton *butReturn = [[UIButton alloc] init];
    [butReturn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    
    [butReturn sizeToFit];
    
    butReturn.width = butReturn.width * .7;
    
    butReturn.height = butReturn.height * .7;
    
    butReturn.centerY = 50;
    
    butReturn.x = 15;
    
    [butReturn addTarget:self action:@selector(fanhui:) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:butReturn];
    
    
    
    //创建倒计时的label;
    
    UILabel *timeDown = [[UILabel alloc] init];
    timeDown.font = JSBold(80);
    timeDown.textAlignment = NSTextAlignmentCenter;
    timeDown.frame = CGRectMake(0, 0, 150, 150);
    timeDown.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    timeDown.centerX = self.view.width * .5;
    timeDown.centerY = self.view.height * .5;
    timeDown.layer.cornerRadius = 75;
    timeDown.layer.masksToBounds = YES;
    timeDown.layer.borderWidth = 20;
    timeDown.layer.borderColor = [UIColor colorWithWhite:0.4 alpha:0.4].CGColor;
    timeDown.textColor = [UIColor blackColor];
    [self.view addSubview:timeDown];
    timeDown.text = @"3";
    self.timeDownLabel = timeDown;
    self.timeDownLabel.hidden = YES;
    
    UIBezierPath *bezier = [UIBezierPath bezierPathWithArcCenter:CGPointMake(75, 75) radius:65 startAngle:-M_PI_2 endAngle:M_PI * 2-M_PI_2 clockwise:YES];
    bezier.lineCapStyle = kCGLineCapRound;
    
    bezier.lineJoinStyle = kCGLineJoinRound;
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(0, 0, 150, 150);
    layer.path = bezier.CGPath;
    layer.lineWidth = 14;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineCap =  kCALineCapRound;
    layer.strokeColor = [UIColor redColor].CGColor;
    [timeDown.layer addSublayer:layer];
    layer.strokeStart = 0;
    layer.strokeEnd = 1;
    self.timeDownShapeLayer = layer;
    
    
    
    //创建进度条.
    
    UIView *progress = [[UIView alloc] init];
    progress.frame = CGRectMake(0, 0, self.view.width * .75, 28);
    progress.layer.cornerRadius = 14;
    progress.layer.masksToBounds = YES;
    progress.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
    progress.y = 120;
    progress.centerX = self.view.width * .5;
    [self.view addSubview:progress];
    self.progressView = progress;
    
    UIView *showProView = [[UIView alloc] init];
    showProView.backgroundColor = [UIColor blackColor];
    showProView.frame = progress.bounds;
    showProView.width = 1;
    [self.progressView addSubview:showProView];
    self.showProgressView = showProView;
    
    self.progressView.hidden = YES;
    
    UILabel *totalLabel = [[UILabel alloc] init];
    totalLabel.textAlignment = NSTextAlignmentCenter;
    totalLabel.textColor = [UIColor blackColor];
    totalLabel.font = JSFont(25);
    totalLabel.text = @"999";
    totalLabel.backgroundColor = [UIColor clearColor];
    [totalLabel sizeToFit];
    totalLabel.text = [NSString stringWithFormat:@"%ld",(long)self.selectArray.count];
    [self.view addSubview:totalLabel];
    totalLabel.y = CGRectGetMaxY(self.progressView.frame) + 10;
    totalLabel.centerX = CGRectGetMaxX(self.progressView.frame) - 5;
    self.showTotalLabel = totalLabel;
    
    UILabel *currentLabel = [[UILabel alloc] init];
    currentLabel.textAlignment = NSTextAlignmentCenter;
    currentLabel.textColor = [UIColor blackColor];
    currentLabel.font = JSFont(25);
    currentLabel.text = @"999";
    [currentLabel sizeToFit];
    currentLabel.text = @"1";
    currentLabel.backgroundColor = [UIColor clearColor];
    currentLabel.y = CGRectGetMaxY(self.progressView.frame) + 10;
    currentLabel.centerX = CGRectGetMinX(self.progressView.frame);
    [self.view addSubview:currentLabel];
    self.showCurrentLabel = currentLabel;
    
    self.showTotalLabel.hidden = YES;
    self.showCurrentLabel.hidden = YES;
    
}


-(void)fanhui:(UIButton *)sender{
    
    [self.timer invalidate];
    [self.testTimer invalidate];
    self.timer = nil;
    self.testTimer = nil;
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


-(void)getInfo{
    
    [SVProgressHUD show];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"level"] = self.level;
    WeakObject(self);
    [[INetworking shareNet] GET:@"http://114.55.90.93:8081/web/app/graphicmemorysubjectList.json" withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        if (isSuccess) {
            NSError *error;
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingMutableLeaves error:&error];
            
            NSInteger count = weatherDic.count - 2;
            //一共count - 2 个数组.
            
            for (int i = 0 ; i < count; i ++) {
                NSString *title = [NSString stringWithFormat:@"list%d",i+1];
                NSDictionary *urlDic = weatherDic[title];
                NSString *partUrl = urlDic[@"url"];
                ImageModel *model = [[ImageModel alloc] init];
                model.urlStr = [NSString stringWithFormat:@"http://www.yueqiao.org%@",partUrl];
                model.isSickRight = NO;
                [selfWeak.dataArray addObject:model];            }
        }
        
        
        [SVProgressHUD dismiss];
        
        selfWeak.timeDownLabel.hidden = NO;
        
        [selfWeak showAll];
        
        [selfWeak finishDataLoadAndSelectRight];
        
    }];
    
}

//读取到数据 现在进行数据的划去.  这个地方并不会很紧急.
-(void)finishDataLoadAndSelectRight{
    NSInteger selectCount = 0;
    NSInteger nowLevel = self.level.integerValue;
    if (nowLevel == 1) {
        selectCount = 3;
    }else if(nowLevel == 2 || nowLevel ==3){
        selectCount = 5;
    }else if(nowLevel == 4 || nowLevel ==5|| nowLevel ==6|| nowLevel ==7|| nowLevel ==8|| nowLevel ==9|| nowLevel ==10|| nowLevel ==14|| nowLevel ==15||nowLevel == 16){
        selectCount = 10;
    }else if(nowLevel == 11 || nowLevel ==12|| nowLevel ==13||nowLevel == 17||nowLevel == 18||nowLevel == 19){
        selectCount = 15;
    }else{
        selectCount = 20;
    }
    
    //特殊情况直接取消.
    if (selectCount > self.dataArray.count) {
        
        [SVProgressHUD showWithStatus:@"请重新开始"];
        
        return;
    }

    for (int i = 0; i < selectCount; i = self.selectArray.count) {
        
        NSInteger indexCount = arc4random() % self.dataArray.count;
        
        NSLog(@"%ld",(long)indexCount);
        
        ImageModel *model = self.dataArray[indexCount];
        
        if (![self.selectArray containsObject:model]) {
            [self.selectArray addObject:model];
        }
        
    }
    
}

-(void)showAll{
    
    //开始读秒的倒计时.
    
    [self shapeLayerAnimation];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    self.timer = timer;
    
}




//开始游戏/
-(void)gameStart{
    
    //隐藏倒计时 开始游戏.
    self.timeDownLabel.hidden = YES;
    
    self.progressView.hidden = NO;
    self.showTotalLabel.hidden = NO;
    self.showCurrentLabel.hidden = NO;
    
    
    if (self.dataArray.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"暂时无题目"];
        [SVProgressHUD dismissWithDelay:1];
        return;
    }
    
    
    //创建显示照片的view;
    
    
    
    ImageAnimationView *view = [[ImageAnimationView alloc] init];
    view.frame = CGRectMake(0, 0, self.view.width * .6, self.view.width * .6 * .711 + 26 );
    [self.view addSubview:view];
    
    view.centerX = self.view.width * .5;
    view.centerY = self.view.height * .55;
    ImageModel *model = self.dataArray[self.currentShowIndex];
    self.showAnimationImageView = view;
    [view setUpView];
    view.currentImage = model.image;
    
    [self showPictureCurrentProgress:1 andTotalCount:self.selectArray.count];
    self.testTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(caculateTime) userInfo:nil repeats:YES];
}

-(void)caculateTime{
    
    self.currentPastTime += 0.1;
    
    if (self.currentPastTime >= (self.currentShowIndex+1) * self.memoryTime) {
        
        self.currentShowIndex = self.currentShowIndex + 1;
        
        if (self.currentShowIndex < self.selectArray.count) {
            
            ImageModel *model = [self.selectArray objectAtIndex:self.currentShowIndex];
            
            [self.showAnimationImageView imageAnimationToShow:model.image];
            
            [self showPictureCurrentProgress:(self.currentShowIndex+1) andTotalCount:self.selectArray.count];
            
        }else{
            [self gameOver];
        }
    }
}





//游戏结束了.
//暂停定时器
-(void)gameOver{
    [self.testTimer invalidate];
    
    self.progressView.hidden = YES;
    self.showTotalLabel.hidden = YES;
    self.showCurrentLabel.hidden = YES;
    
    self.showAnimationImageView.hidden = YES;
    
    self.currentPastTime = 0;
    
    self.currentShowIndex = 0;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"记忆结束,开始进入答题阶段";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = JSFont(33);
    [label sizeToFit];
    label.backgroundColor = [UIColor clearColor];
    label.centerY = self.view.height * .4;
    label.centerX = self.view.width * .5;
    [self.view addSubview:label];
    
    label.tag = 111;
    
    
    [self performSelector:@selector(beganTestViewSet) withObject:nil afterDelay:3.0];
    
}




-(void)beganTestViewSet{
    
    //删除掉label;
    UILabel *label = [self.view viewWithTag:111];
    [label removeFromSuperview];
    
    
    self.progressView.hidden = NO;
    self.showTotalLabel.hidden = NO;
    self.showCurrentLabel.hidden = NO;
    
    self.showAnimationImageView.hidden = NO;
    
    ImageModel *model = self.dataArray[self.currentShowIndex];
    self.showAnimationImageView.currentImage = model.image;

    //创建按钮.
    UIButton *butFou = [[UIButton alloc] init];
    butFou.titleLabel.font = JSFont(43);
    [butFou setBackgroundColor:JSColor(55, 55, 55, 1)];
    [butFou setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [butFou addTarget:self action:@selector(touchButFou:) forControlEvents:UIControlEventTouchUpInside];
    [butFou setTitle:@"否" forState:UIControlStateNormal];
    butFou.width = (self.view.width -3)/2.0;
    butFou.height = 100;
    butFou.x = 0;
    butFou.y = self.view.height - butFou.height;
    
    butFou.tag = 678;
    
    
    
    UIButton *butsh = [[UIButton alloc] init];
    butsh.titleLabel.font = JSFont(43);
    [butsh setBackgroundColor:JSColor(55, 55, 55, 1)];
    [butsh setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [butsh addTarget:self action:@selector(touchButSh:) forControlEvents:UIControlEventTouchUpInside];
    butsh.width = butFou.width;
    butsh.height = butFou.height;
    [butsh setTitle:@"是" forState:UIControlStateNormal];
    butsh.x = self.view.width - butsh.width;
    butsh.y = butFou.y;
    butsh.tag = 876;
    
    [self.view addSubview:butFou];
    [self.view addSubview:butsh];
    
    
    //创建用来显示的view
    
    self.timeDownLabel.hidden = NO;
    self.timeDownLabel.y = self.view.height * .2;
    
    //宽高150 弧度75;
    
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = JSColor(55, 55, 55, 0.8);
    backView.height = 120;
    backView.width = self.view.width * .70;
    backView.centerX = self.timeDownLabel.centerX;
    backView.centerY = self.timeDownLabel.centerY;
    [self.view addSubview:backView];
    backView.layer.cornerRadius = 60;
    backView.layer.masksToBounds = YES;
    self.containBackView = backView;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.view.width * .70, 120) cornerRadius:0];
    UIBezierPath *opath = [UIBezierPath bezierPath];
    [opath addArcWithCenter:CGPointMake(self.view.width * .35, 60) radius:90 startAngle:0 endAngle:2*M_PI clockwise:YES];
    //镂空
    [path appendPath:opath];
    //    [path setUsesEvenOddFillRule:YES];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(0, 0, self.view.width * .70, 120);
    layer.fillRule = kCAFillRuleEvenOdd;
    layer.path = path.CGPath;
    layer.fillColor = JSColor(55, 55, 55, 1).CGColor;
    layer.lineWidth = 1;
    layer.opacity= 1;
    backView.layer.mask = layer;
    
    

    //创建对和错的图片.
    UIImageView *gougou = [[UIImageView alloc] init];
    gougou.image = [UIImage imageNamed:@"lvgou"];
    [gougou sizeToFit];
    gougou.width = gougou.width * .4;
    gougou.height = gougou.height * .4;
    gougou.centerY = backView.centerY;
    gougou.centerX = (CGRectGetMaxX(self.timeDownLabel.frame) + CGRectGetMaxX(backView.frame))/2.0;
    [self.view addSubview:gougou];
    self.lvgou = gougou;
    
    
    UIImageView *chacha = [[UIImageView alloc] init];
    chacha.image = [UIImage imageNamed:@"hongcuo"];
    [chacha sizeToFit];
    chacha.width = chacha.width * .4;
    chacha.height = chacha.height * .4;
    chacha.centerY = backView.centerY;
    chacha.centerX = (CGRectGetMinX(self.timeDownLabel.frame) + CGRectGetMinX(backView.frame))/2.0;
    [self.view addSubview:chacha];
    self.hongcha = chacha;
    
    [self hideGouAndCha];
    
    [self beganAlabelDown];
}


//开始一个为期三秒的倒计时.
-(void)beganAlabelDown{
    
    [self hideGouAndCha];
    
    if (self.currentShowIndex >= self.dataArray.count) {
        
        [self overAllAnser];
        
        return;
        
    }
    
    
    self.currentPastTime = 0;
    self.timeDownLabel.text = [NSString stringWithFormat:@"%d",(int)self.testTime];
    ImageModel *model = self.dataArray[self.currentShowIndex];
    
    if (self.currentShowIndex!=0) {
        [self.showAnimationImageView imageAnimationToShow:model.image];
    }else{
        self.showAnimationImageView.currentImage = model.image;
        [self showPictureCurrentProgress:0 andTotalCount:self.dataArray.count];
    }
    
//    [self shapeLayerAnimation];
    
    //计时的计数
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:.1f target:self selector:@selector(answerTimeRun) userInfo:nil repeats:YES];
    self.timer = timer;
    
    //改变label的计数.
    self.testTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(changeLabelText) userInfo:nil repeats:YES];
    
}

//自动结束了一次计时答题.       视作没有进行答题.
-(void)overOneAnserTime{
    [self.timer invalidate];
    [self.testTimer invalidate];
}

-(void)answerTimeRun{
    self.currentPastTime += 0.1;
    self.timeDownShapeLayer.strokeEnd = (self.currentPastTime / self.testTime);
}

-(void)changeLabelText{
    NSString *title = self.timeDownLabel.text;
    NSInteger currentShow = title.integerValue;
    NSInteger currentTime = currentShow - 1;
    
    if (currentTime == 0) {
        //自动计时结束. 当前应该是选择错误.
        self.currentShowIndex ++;
        
        [self overOneAnserTime];
        
        self.currentPastTime = 0;
        
        self.userUseTime += self.testTime;
        
        [self beganAlabelDown];
        
    }else{
        
        self.timeDownLabel.text = [NSString stringWithFormat:@"%ld",(long)currentTime];
        
    }
    
}



//结束答题.
-(void)overAllAnser{
    
    NSInteger RightCount = 0;
    
    for (ImageModel *model in self.dataArray) {
        
        if (model.isSickRight) {
            RightCount++;
        }
    }
    
    NSInteger stars = 0;
    
    [self saveTestInfoWithScore:(RightCount*1.0 / self.dataArray.count * 100)];
    
    WeakObject(self);
    if (RightCount == self.dataArray.count) {
        stars = 3;
         ImageTestAlert *alert = [ImageTestAlert showAlertWithStars:3 andTime:self.userUseTime andTotal:self.dataArray.count andRight:RightCount andButtonTitle:@"下一关" endFailus:^{
            
            [ImageTestAlert hideAlert];
            
             NSString *newlevel = [NSString stringWithFormat:@"%d",(selfWeak.level.integerValue + 1)];
             
             [selfWeak resetAllThingAndBeganLevel:newlevel];
            
        }];
        WeakObject(self);
        [alert setButClose:^{
           
            [selfWeak.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
        }];
    }else if (RightCount*1.0 / self.dataArray.count >= .8 ){
        stars = 2;
        
        
           ImageTestAlert *alert = [ImageTestAlert showAlertWithStars:2 andTime:self.userUseTime andTotal:self.dataArray.count andRight:RightCount andButtonTitle:@"下一关" endFailus:^{
            
            [ImageTestAlert hideAlert];
               
               NSString *newlevel = [NSString stringWithFormat:@"%d",(selfWeak.level.integerValue + 1)];
            
            [selfWeak resetAllThingAndBeganLevel:newlevel];
            
        }];
        
        [alert setButClose:^{
            
            [selfWeak.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
        }];
        
    }else{
        stars = 0;
        
         ImageTestAlert *alert = [ImageTestAlert showAlertWithStars:0 andTime:self.userUseTime andTotal:self.dataArray.count andRight:RightCount andButtonTitle:@"真可惜,再试试吧" endFailus:^{
            
            [ImageTestAlert hideAlert];
            
             [selfWeak resetAllThingAndBeganLevel:selfWeak.level];
            
        }];
        
        [alert setButClose:^{
            
            [selfWeak.presentingViewController dismissViewControllerAnimated:YES completion:nil];
            
        }];
    }
    
}


//保存训练记录.
-(void)saveTestInfoWithScore:(float)score{
    int sendSocre = (int)(score * 100);
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"level"] = self.level;
    dic[@"stu_name"] = [JSStudentInfoManager manager].basicInfo.stuName;
    dic[@"password"] = [JSStudentInfoManager manager].basicInfo.passWord;
    dic[@"used_times"] = [NSString stringWithFormat:@"%f",self.userUseTime];
    dic[@"stu_score"] =  [NSString stringWithFormat:@"%d",sendSocre];
    dic[@"center"] = [JSStudentInfoManager manager].basicInfo.centerName;
    dic[@"totlenumber"] = [NSString stringWithFormat:@"%ld",(long)self.dataArray.count];
    dic[@"number"] = [NSString stringWithFormat:@"%ld",(long)self.selectRightCount];
    [[INetworking shareNet] GET:@"http://114.55.90.93:8081/web/app/savegmrecords.json" withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        NSError *error;
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",weatherDic);
        
    }];
    
    
}




#pragma mark - method

-(void)showPictureCurrentProgress:(NSInteger)showCount andTotalCount:(NSInteger)totalCount{
    
    if (showCount == totalCount) {
        self.showCurrentLabel.hidden = YES;
    }else{
        
        self.showCurrentLabel.hidden = NO;
    }
    
    
    self.showProgressView.width = self.progressView.width * (showCount * 1.0 / totalCount);
    
    self.showCurrentLabel.text = [NSString stringWithFormat:@"%ld",(long)showCount];
    
    self.showTotalLabel.text = [NSString stringWithFormat:@"%ld",(long)totalCount];
    
    self.showCurrentLabel.centerX = CGRectGetMaxX(self.showProgressView.frame) + CGRectGetMinX(self.progressView.frame);
    
}



//圆圈倒计时的方法. 倒计时 就会进行开始游戏的方法.

-(void)timerAction{
    
    NSString *title = self.timeDownLabel.text;
    NSInteger currentShow = title.integerValue;
    NSInteger currentTime = currentShow - 1;
    
    if (currentTime == 0) {
        
        [self.timer invalidate];
        
        [self gameStart];
        
    }else{
        
        self.timeDownLabel.text = [NSString stringWithFormat:@"%ld",(long)currentTime];
        
    }
    
}


-(void)shapeLayerAnimation{
    
    
    CABasicAnimation *aniamtion1 = [CABasicAnimation animation];
    aniamtion1.keyPath = @"strokeEnd";
    aniamtion1.fromValue = @0.0;
    aniamtion1.toValue = @1.0;
    aniamtion1.duration = 3;
    aniamtion1.repeatCount = 1;
    aniamtion1.autoreverses = NO;
    aniamtion1.removedOnCompletion = NO;
    aniamtion1.fillMode = kCAFillModeBackwards;
    //    aniamtion1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
//    // 第二个檫除路径路径动画
//    CABasicAnimation *aniamtion2 = [CABasicAnimation animation];
//    aniamtion2.keyPath = @"strokeStart";
//    aniamtion2.fromValue = @0.4;
//    aniamtion2.toValue = @0.1;
//    aniamtion2.duration = 1;
//    aniamtion2.autoreverses = YES;
//    aniamtion2.repeatCount = MAXFLOAT;
//
//    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    circleAnimation.duration = 1.0f;
//    circleAnimation.repeatCount = MAXFLOAT;
//    circleAnimation.toValue = @(M_PI*2);
//
//    [self.timeDownShapeLayer addAnimation:circleAnimation forKey:@"rotation"];
//    circleAnimation.delegate = self;
//    [self.timeDownShapeLayer addAnimation:aniamtion1 forKey:nil];
    [self.timeDownShapeLayer addAnimation:aniamtion1 forKey:nil];
    
}





//答题按钮事件.
-(void)touchButFou:(UIButton *)sender{
    
    
    NSLog(@"%lf",self.userUseTime);
    
    if (_currentPastTime == 0) {
        return;
    }
    
    
    if (self.currentShowIndex>= self.dataArray.count) {
        return;
    }
    
    
    [self overOneAnserTime];
    //所使用的时间先进行保存.
    self.userUseTime += self.currentPastTime;
    _currentPastTime =0;
    ImageModel *model = self.dataArray[self.currentShowIndex];
    
    if ([self.selectArray containsObject:model]) {
        [self hideGouAndCha];
        [self showChaCha];
        model.isSickRight = NO;
    }else{
        [self hideGouAndCha];
        [self showGouGou];
        model.isSickRight = YES;
    }
    self.currentShowIndex++;
    
    [self performSelector:@selector(beganAlabelDown) withObject:nil afterDelay:1];
}

-(void)touchButSh:(UIButton *)sender{
    
    NSLog(@"%lf",self.userUseTime);
    
    
    if (_currentPastTime == 0) {
        return;
    }
    
    
    if (self.currentShowIndex>= self.dataArray.count) {
        return;
    }
    
    [self overOneAnserTime];
    self.userUseTime += self.currentPastTime;
    
    _currentPastTime =0;
    
    
    ImageModel *model = self.dataArray[self.currentShowIndex];
    
    if ([self.selectArray containsObject:model]) {
        [self hideGouAndCha];
        [self showGouGou];
        model.isSickRight = YES;
    }else{
        [self hideGouAndCha];
        [self showChaCha];
        model.isSickRight = NO;
    }
    self.currentShowIndex++;
    [self performSelector:@selector(beganAlabelDown) withObject:nil afterDelay:1];
}

-(void)showGouGou{
    [self.view insertSubview:self.lvgou aboveSubview:self.containBackView];
    
    _selectRightCount ++;
    
    [self showPictureCurrentProgress:self.selectRightCount andTotalCount:self.dataArray.count];
}

-(void)showChaCha{
    [self.view insertSubview:self.hongcha aboveSubview:self.containBackView];
}

-(void)hideGouAndCha{
    [self.view insertSubview:self.lvgou belowSubview:self.containBackView];
    [self.view insertSubview:self.hongcha belowSubview:self.containBackView];
}



//重启所有的东西.
-(void)resetAllThingAndBeganLevel:(NSString *)level{
    
    self.memoryTime = 0;
    [self.timer invalidate];
    [self.testTimer invalidate];
    self.currentPastTime = 0;
    self.userUseTime = 0;
    
    [self.dataArray removeAllObjects];
    [self.selectArray removeAllObjects];
    self.currentShowIndex = 0;
    self.selectRightCount = 0;
    
    //隐藏那些新的view
    [self.containBackView removeFromSuperview];
    [self.lvgou removeFromSuperview];
    [self.hongcha removeFromSuperview];
    self.lvgou = nil;
    self.hongcha = nil;
    self.containBackView = nil;
    
    [[self.view viewWithTag:678] removeFromSuperview];
    [[self.view viewWithTag:876] removeFromSuperview];
    
    //从新倒计时三秒.
    self.timeDownLabel.text = @"3";
    self.timeDownLabel.centerY = self.view.height * .5;
    
    self.showAnimationImageView.hidden = YES;
    self.progressView.hidden = YES;
    self.showTotalLabel.hidden = YES;
    self.showCurrentLabel.hidden = YES;
    
    
    self.level = level;
    
    [self getInfo];
}


-(void)dealloc{
    
    NSLog(@"图形测试页面销毁");
    
}

@end

