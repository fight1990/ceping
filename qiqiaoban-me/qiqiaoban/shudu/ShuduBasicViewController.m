//
//  ShuduBasicViewController.m
//  qiqiaoban
//
//  Created by mac on 2019/7/4.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ShuduBasicViewController.h"

#import "JSEDefine.h"

#import "UIImage+Render.h"

#import "UIImage+Render.h"

@interface ShuduBasicViewController ()

//显示时间的view
@property (nonatomic,retain) UIView *timeView;

@property (nonatomic,retain) UIView *topView;

@property (nonatomic,retain) NSTimer *timeTimer;

@property (nonatomic,retain) NSMutableArray *labelArray;

@property (nonatomic,retain) UIView *containUIToolView;

@end

@implementation ShuduBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.labelArray = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.currentMiaokeka = 0;
    
    [self setUpView];
    
    [self setUpTimer];
    
}

-(void)setUpView{
    
    //    contain
    
    UIView *topView = [[UIView alloc] init];
    topView.frame = CGRectMake(0, 0, JSFrame.size.width, 80);
    topView.backgroundColor = [UIColor clearColor];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 80, JSFrame.size.width, 1);
    lineView.backgroundColor = JSLikeBlackColor;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"题目";
    titleLabel.font = JSFont(25);
    titleLabel.textColor = JSLikeBlackColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.width = JSFrame.size.width * .6;
    titleLabel.height = 50;
    titleLabel.centerX = self.view.width * .5;
    titleLabel.centerY = 50;
    self.titleLabel = titleLabel;
    
    
    UIButton *tiaoButton = [[UIButton alloc] init];
    tiaoButton.backgroundColor = [UIColor clearColor];
    
    
    if (1) {
        [tiaoButton setTitle:@"跳过" forState:UIControlStateNormal];
        
        [tiaoButton setImage:[[UIImage imageNamed:@"shudutiaoguo"] scaleSize:CGSizeMake(32, 32)] forState:UIControlStateNormal];
        
        
        [tiaoButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    }
    
    //meiyou daodi
    
    [tiaoButton addTarget:self action:@selector(tiaoGuo) forControlEvents:UIControlEventTouchUpInside];
    tiaoButton.titleLabel.font = JSFont(21);
    [tiaoButton setTitleColor:JSLikeBlackColor forState:UIControlStateNormal];
    tiaoButton.height = 50;
    tiaoButton.width = 150;
    tiaoButton.layer.borderWidth = 1;
    tiaoButton.layer.borderColor = [UIColor grayColor].CGColor;
    tiaoButton.layer.cornerRadius = 25;
    tiaoButton.layer.masksToBounds = YES;
    
    tiaoButton.centerY = 50;
    tiaoButton.x = JSFrame.size.width - tiaoButton.width - 20;
    
    [self.view addSubview:topView];
    
    [self.view addSubview:lineView];
    
    [self.view addSubview:titleLabel];
    
    [self.view addSubview:tiaoButton];
    
    
    
    UIButton *fanhuiButton = [[UIButton alloc] init];
    
    [fanhuiButton setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    
    [fanhuiButton sizeToFit];
    
    fanhuiButton.width = fanhuiButton.width * .7;
    
    fanhuiButton.height = fanhuiButton.height * .7;
    
    fanhuiButton.centerY = 50;
    fanhuiButton.x = 15;
    
    [fanhuiButton addTarget:self action:@selector(fanhui:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:fanhuiButton];
    
    
    
    //查看答案的按钮.
    
    UIButton *answer = [[UIButton alloc] init];
    
    answer.hidden = YES;
    if (1) {
//        answer.backgroundColor = [UIColor clearColor];
        [answer setBackgroundColor:JSColor(223, 193, 226, 1)];
        [answer setTitle:@"查看答案" forState:UIControlStateNormal];
//        [answer setTitle:@"" forState:UIControlStateNormal];
        [answer setImage:[[UIImage imageNamed:@"chakan"] scaleSize:CGSizeMake(34, 34)] forState:UIControlStateNormal];
    }
    
    [answer addTarget:self action:@selector(chakanAnswer) forControlEvents:UIControlEventTouchUpInside];
    answer.titleLabel.font = JSFont(20);
    [answer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [answer setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    
    
    
    answer.width = 180;
    
    answer.height = 50;
    
    answer.x =  25;
    
    answer.y = 100;
    
    answer.layer.cornerRadius = 25;
    
    answer.layer.masksToBounds = YES;
    
    //    answer.layer.borderColor = JSLikeBlackColor.CGColor;
    
    //    answer.layer.borderWidth = 1;
    
    answer.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    
    [self.view addSubview:answer];
    
    //查看当前时间的label
    
    UIView *containTimeView = [[UIView alloc] init];
    containTimeView.backgroundColor = JSColor(194, 194, 254, 1);
    self.timeView = containTimeView;
    
    containTimeView.width = 250;
    containTimeView.height = 50;
    
    containTimeView.layer.cornerRadius = 26;
    containTimeView.layer.masksToBounds = YES;
    
    containTimeView.centerX = JSFrame.size.width * .5;
    containTimeView.centerY = answer.centerY;
    [self.view addSubview:containTimeView];
    
    UIImageView *timeImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    timeImage.image = [UIImage imageNamed:@"naozhong"];
    timeImage.centerY = containTimeView.height * .5;
    timeImage.x = 25;
    [containTimeView addSubview:timeImage];
    
    
    //    CGFloat containLabel = containTimeView.width - CGRectGetMaxY(timeImage.frame) - 15 - 25;
    //zhongjian 150    8 8  24 110 / 428
    //冒号 占比应该是
    for (int i = 0 ; i < 4; i++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = JSFont(20);
        label.textColor = JSLikeBlackColor;
        label.layer.cornerRadius = 7;
        label.frame = CGRectMake(0, 0, 28, 33);
        label.layer.masksToBounds = YES;
        label.backgroundColor = [UIColor whiteColor];
        label.centerY = timeImage.centerY;
        label.text = @"0";
        if (i == 0) {
            label.x = 75;
        }else if (i == 1){
            label.x = 111;
        }else if(i == 2){
            label.x = 163;
        }else{
            label.x = 199;
        }
        [containTimeView addSubview:label];
        [self.labelArray addObject:label];
    }
    
    UILabel *maohao = [[UILabel alloc] init];
    maohao.textAlignment = NSTextAlignmentCenter;
    maohao.font = JSFont(20);
    maohao.textColor = [UIColor blackColor];
    maohao.frame = CGRectMake(0, 0, 20, 33);
    maohao.backgroundColor = [UIColor clearColor];
    maohao.centerY = timeImage.centerY;
    maohao.text = @":";
    maohao.centerX = 151;
    
    
    [containTimeView addSubview:maohao];
}

-(void)setUpTimer{
    
    self.timeTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timeGo) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:_timeTimer forMode:NSRunLoopCommonModes];
    
    [self stopTime];
}

-(void)fanhui:(UIButton *)sender{
    
    [self clickQuit];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)timeGo{
    self.currentMiaokeka = self.currentMiaokeka + 1;
}

//停止
-(void)stopTime{
    [self.timeTimer setFireDate:[NSDate distantFuture]];
}

//开启
-(void)goTime{
    [self.timeTimer setFireDate:[NSDate distantPast]];
}




#pragma mark - set

-(void)setCurrentMiaokeka:(NSInteger)currentMiaokeka{
    _currentMiaokeka = currentMiaokeka;
    NSInteger a = _currentMiaokeka/60;
    NSInteger b = _currentMiaokeka%60;
    NSString *timeString = [NSString stringWithFormat:@"%02ld%02ld",a,b];
    for (UILabel *label in self.labelArray) {
        NSInteger index = [self.labelArray indexOfObject:label];
        label.text = [timeString substringWithRange:NSMakeRange(index, 1)];
    }
}



#pragma mark - fa 方法

-(void)tiaoGuo{
    
}

-(void)chakanAnswer{
    
}

-(void)clickQuit{
    
    
}


@end
