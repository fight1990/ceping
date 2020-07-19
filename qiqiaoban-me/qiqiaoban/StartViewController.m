//
//  StartViewController.m
//  qiqiaoban
//
//  Created by mac on 2019/2/19.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "StartViewController.h"

#import "INetworking.h"

#import "JSEDefine.h"

#import "JSAlertView.h"

#import <SVProgressHUD.h>

#import "JSStudentInfoManager.h"

#import "UIImage+Render.h"

@interface StartViewController ()

@property (nonatomic,retain) UIView *topView;

@property (nonatomic,retain) NSTimer *timeTimer;

@property (nonatomic,retain) NSMutableArray *labelArray;

@property (nonatomic,retain) UIView *containUIToolView;

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.labelArray = [NSMutableArray array];
    self.currentModel = [[QQBModel alloc] init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [SVProgressHUD showWithStatus:@"读取中"];
    
    self.currentMiaokeka = 0;
    
    [self setUpView];
    
    [self setUpTimer];
    
    [self loadQQB];
    
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
        [tiaoButton setTitle:@"" forState:UIControlStateNormal];
//        [tiaoButton setTitle:@"跳过本关" forState:UIControlStateNormal];
    }
    
    //meiyou daodi
    
    [tiaoButton addTarget:self action:@selector(tiaoGuo) forControlEvents:UIControlEventTouchUpInside];
    tiaoButton.titleLabel.font = JSFont(21);
    [tiaoButton setTitleColor:JSLikeBlackColor forState:UIControlStateNormal];
    [tiaoButton sizeToFit];
    
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
    
    if (1) {
        answer.backgroundColor = [UIColor clearColor];
        //        [answer setBackgroundColor:JSColor(223, 193, 226, 1)];
        //        [answer setTitle:@"查看答案" forState:UIControlStateNormal];
        [answer setTitle:@"" forState:UIControlStateNormal];
//        [answer setImage:[[UIImage imageNamed:@"chakan"] scaleSize:CGSizeMake(34, 34)] forState:UIControlStateNormal];
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
    
    containTimeView.x = JSFrame.size.width - containTimeView.width - 25;
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


-(void)loadQQB{
    //读取一个七巧板的题库.
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"login_name"] = [JSStudentInfoManager manager].basicInfo.loginName;
    
    self.tips.hidden = YES;
    
    WeakObject(self);
    [[INetworking shareNet] GET:@"http://114.55.90.93:8081/web/app/qqbstudentsubjectList.json" withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        if (isSuccess) {
            NSError *error;
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingMutableLeaves error:&error];
            NSDictionary *modelDic = weatherDic[@"subList"];;
            
            for (ShapeModel *model in self.currentModel.ShapeModelArray) {
                NSInteger a = [self.currentModel.ShapeModelArray indexOfObject:model];
                
                model.shapeID = [NSString stringWithFormat:@"%ld",a+1];
                
                NSString *countStr = [modelDic objectForKey:[NSString stringWithFormat:@"count%ld",a+1]];
                
                model.count = countStr.integerValue;
                
                model.xSize = [modelDic objectForKey:[NSString stringWithFormat:@"xzhou%ld",a+1]];
                
                model.ySize = [modelDic objectForKey:[NSString stringWithFormat:@"yzhou%ld",a+1]];
                
                NSString *fanzhuanStr = [modelDic objectForKey:[NSString stringWithFormat:@"isTurn%ld",a+1]];
                
                NSInteger fanzhuanCount = fanzhuanStr.integerValue;
                
                model.isFanzhuan = fanzhuanCount % 2;
            }
            //18106528364
/*
             
             ,copy) NSString *QQBName;
             
             //七巧板编号
             @property (nonatomic,copy) NSString *QQBNumber;
             
             //标准时间
             @property (nonatomic,copy) NSString *standardTime;
             
             //难度等级
             @property (nonatomic,copy) NSString *level;
             
             //提示等级 分为1-6级.
             @property (nonatomic,copy) NSString *type;
*/
            self.currentModel.QQBName = modelDic[@"name"];
            self.currentModel.QQBNumber = modelDic[@"number"];
            self.currentModel.standardTime = weatherDic[@"standard_time"];
            self.currentModel.level = modelDic[@"level"];
            self.currentModel.type = modelDic[@"type"];
            self.currentModel.ageGrounp = weatherDic[@"Agegroup"];
            
            
            
            
            if ([weatherDic[@"flag"] isEqualToString:@"1-10"]) {
                self.currentModel.currentCountType = ShapeModelCountTypeLess;
            }else if([weatherDic[@"flag"] isEqualToString:@"10"]){
                self.currentModel.currentCountType = ShapeModelCountTypeTen;
            }else if([weatherDic[@"flag"] isEqualToString:@"11"]){
                self.currentModel.currentCountType = ShapeModelCountTypeOver;
                
                [JSStudentInfoManager manager].isOverToday = YES;
                
            }else{
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [selfWeak loadOneQQBOk];
                self.titleLabel.text = [NSString stringWithFormat:@"(级别%@) %@",self.currentModel.level,self.currentModel.QQBName];
            });
        }else{
        }
    }];
}

//

//完成了数据的获取和包装
-(void)loadOneQQBOk{
    
    if (self.tips) {
        
        [self.tips removeFromSuperview];
        
    }
    
    
    if (self.currentModel.currentCountType == ShapeModelCountTypeOver) {
        
        [self fanhui:nil];
        
    }
    
    
    
    TipsView *tips = [[TipsView alloc] initWithModel:self.currentModel];
    
    self.tips = tips;
    
    [self.view addSubview:tips];
    
    tips.x = 0;
    
    tips.y = 0;
    
    self.tips.hidden = NO;
    //在这里测试 显示的tipsview的效果吧。 先要看看这个 tipsview的缩放效果如何。
    
    if (self.tips.currentTypeNum == 3) {
        self.tips.transform = CGAffineTransformMakeScale(0.5, 0.5);
        
        self.tips.x = 0;
        self.tips.y = 0;
    }

    
    [SVProgressHUD dismiss];
    
    [JSAlertView hideAlert];
    
    self.timeView.hidden = NO;
    
    self.currentMiaokeka = 0;
    
    tips.userInteractionEnabled = NO;
    
    [self getCurrentPointNum];
        
//    if ([self.delegate respondsToSelector:@selector(didLoadOneQQBAndSetView)]) {
//        [self.delegate didLoadOneQQBAndSetView];
//    }
    
    [self loadQQBInfoOver];
    
}


//当七巧板显示出来之后对 七巧板的总数point进行技术.
-(void)getCurrentPointNum{
    
    self.currentQQBPoint = 0;
    
    
    UIImage *image = [self.tips convertViewToImage];
    
    
    dispatch_queue_t countNumQueue = dispatch_queue_create([@"countQQBNum" cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(countNumQueue, ^{
        
        for (int x = self.tips.showAre.MinPoint.x+5; x < self.tips.showAre.MaxPoint.x-5; x += 5) {
            for (int y = self.tips.showAre.MinPoint.y+5; y < self.tips.showAre.MaxPoint.y-5; y += 5) {
                
                UIColor *color = [image colorAtPixel:CGPointMake(x, y)];
                
                CGFloat alpha = 0.0;
                
                if ([color respondsToSelector:@selector(getRed:green:blue:alpha:)])
                {
                    // available from iOS 5.0
                    [color getRed:NULL green:NULL blue:NULL alpha:&alpha];
                }
                else
                {
                    // for iOS < 5.0
                    // In iOS 6.1 this code is not working in release mode, it works only in debug
                    // CGColorGetAlpha always return 0.
                    CGColorRef cgPixelColor = [color CGColor];
                    alpha = CGColorGetAlpha(cgPixelColor);
                }
                
                if (alpha > 0.1) {
                    self.currentQQBPoint ++;
                }
            }
        }
        
        NSLog(@"%ld",(long)self.currentQQBPoint);
        
    });
    

    

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

-(void)loadQQBInfoOver{

}

-(void)clickQuit{


}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
