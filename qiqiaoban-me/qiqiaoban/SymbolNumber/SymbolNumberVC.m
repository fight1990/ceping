//
//  SymbolNumberVC.m
//  QiQiaoBan
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "SymbolNumberVC.h"
#import "ShuduButton.h"
#import "SymbolNumberButton.h"
#import "LXTCircleView.h"
#import "LXTProgressView.h"

#import "ResultViewController.h"
#import "UIViewController+CBPopup.h"
#import "INetworking.h"
#import <SVProgressHUD.h>
#import "JSStudentInfoManager.h"

#import "HLAlertViewBlock.h"

#define squareWidth (KScreenWidth -40)/10

@interface SymbolNumberVC ()

@property(nonatomic,strong) UILabel *timeLabel;
//倒计时
@property(nonatomic,strong) UILabel *secondsLabel;
@property (nonatomic, weak) LXTCircleView *secondsView;
@property (nonatomic,assign) NSInteger lastTime;

@property(nonatomic,strong) UIView *SymbolNumberView;

@property(nonatomic,strong) NSArray *symbol;
@property(nonatomic,strong) NSMutableArray *symbolArray;
@property(nonatomic,strong) NSMutableArray *symbolResultArray;

@property(nonatomic,strong) NSArray *number;
@property(nonatomic,strong) NSMutableArray *numberArray;
@property(nonatomic,strong) NSMutableArray *numberResultArray;

@property(nonatomic,strong) NSMutableArray *resultArray;
@property(nonatomic,strong) NSMutableArray *answerArray;

@property (nonatomic,retain) NSMutableArray *answerButtonArray;
@property (nonatomic,retain) SymbolNumberButton *currentSelectButton;

@property (nonatomic,assign) NSInteger rightNumAmount;


@property (nonatomic,assign) NSInteger reloadAmount;
@property (nonatomic,assign) NSInteger surplusAmount;

@property (nonatomic, weak) LXTCircleView *circleView;
@property (nonatomic, weak) LXTProgressView *progressView;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSTimer *queTimer;
@property (nonatomic,assign) NSInteger seconds;

@property (nonatomic, strong) NSTimer *lastTimer;
@end

@implementation SymbolNumberVC

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.titleNum ==999) {
        self.title =[NSString stringWithFormat:@"无限关卡",self.titleNum];
    }else{
        self.title =[NSString stringWithFormat:@"第%ld关",self.titleNum];
    }
    
    self.view.backgroundColor =[UIColor whiteColor];
    
    UIImageView *backgroundView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    backgroundView.image =[UIImage imageNamed:@"beijing1"];
    [self.view addSubview:backgroundView];
    
    self.secondsLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 80, 200, 200)];
    self.secondsLabel.font =[UIFont systemFontOfSize:80];
    self.secondsLabel.textColor =[UIColor whiteColor];
    self.secondsLabel.text =@"3";
    self.secondsLabel.textAlignment =NSTextAlignmentCenter;
    self.secondsLabel.center =CGPointMake(KScreenWidth/2, KScreenHeight/2);
    [self.view addSubview:self.secondsLabel];
    
    self.lastTime =3;
    
    self.lastTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.lastTimer forMode:NSRunLoopCommonModes];
    
    if (self.queAmount%10 >1) {
        self.reloadAmount = self.queAmount/10;
    }else{
        self.reloadAmount = self.queAmount/10 -1;
    }
    self.surplusAmount =self.queAmount%10;
    
    self.rightNumAmount = 0;
    
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 40, 30)];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    UIView *backBtnView = [[UIView alloc] initWithFrame:backBtn.bounds];
    backBtnView.bounds = CGRectOffset(backBtnView.bounds, -6, 0);
    [backBtnView addSubview:backBtn];
    UIImageView *backImage =[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 25, 25)];
    backImage.image =[UIImage imageNamed:@"fanhui"];
    [backBtnView addSubview:backImage];
    
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtnView];
    self.navigationItem.leftBarButtonItem =backBarBtn;
    
    
}

-(void)creatView{
    [self.secondsLabel removeFromSuperview];
    
    if (self.queSeconds ==999) {
        self.timeLabel.text =@"无限";
    }else{
        self.seconds =self.queSeconds;
        [self addTimer];
    }
    
    self.SymbolNumberView =[[UIView alloc]initWithFrame:CGRectMake(0, 200, KScreenWidth, 500)];
    [self.view addSubview:self.SymbolNumberView];
    
    self.timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 80, 120, 120)];
    self.timeLabel.font =[UIFont systemFontOfSize:40];
    self.timeLabel.textColor =[UIColor whiteColor];
    self.timeLabel.text =[NSString stringWithFormat:@"%ld",self.seconds];
    self.timeLabel.textAlignment =NSTextAlignmentCenter;
    self.timeLabel.center =CGPointMake(KScreenWidth/2, 220);
    [self.view addSubview:self.timeLabel];
    
    for (int i=0; i<10; i++) {
        UIButton *btn =[UIButton buttonWithType:0];
        btn.frame =CGRectMake(20+squareWidth*i, KScreenHeight -50-squareWidth, squareWidth, squareWidth);
        btn.layer.borderWidth =2;
        btn.layer.borderColor =[UIColor whiteColor].CGColor;
        [btn setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font =[UIFont systemFontOfSize:25];
        btn.tag=101+i;
        [btn addTarget:self action:@selector(inputNum:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    //圆圈
    LXTCircleView *circleView = [[LXTCircleView alloc] initWithFrame:CGRectMake(220, 100, 120, 120)];
    circleView.center =CGPointMake(KScreenWidth/2, 220);
    [self.view addSubview:circleView];
    self.circleView = circleView;
    
    //进度条
    LXTProgressView *progressView = [[LXTProgressView alloc] initWithFrame:CGRectMake(20, 90, KScreenWidth-40, 30)];
    [self.view addSubview:progressView];
    self.progressView = progressView;

    [self creatUI];
}

-(void)startAction{
    self.lastTime--;
    if (self.lastTime == 0) {
        [self removesLastTimer];
        [self creatView];
    }
    self.secondsLabel.text =[NSString stringWithFormat:@"%ld",self.lastTime];
}
- (void)removesLastTimer
{
    [self.lastTimer invalidate];
    self.lastTimer =nil;
}

-(void)back{
    [self removesLastTimer];
    [self removeTimer];
    [self removesSecondsTimer];
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:2] animated:YES];
}

-(void)goToRootview{
    [self removesLastTimer];
    [self removeTimer];
    [self removesSecondsTimer];
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:2] animated:YES];
}

- (void)addTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    _queTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(secondsTimerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_queTimer forMode:NSRunLoopCommonModes];
}

- (void)secondsTimerAction
{
    self.seconds--;
    if (self.seconds == 0) {
        [self alertViewWithBlock];
        [self removesSecondsTimer];
    }
    if (self.seconds <=5) {
        self.timeLabel.textColor =[UIColor redColor];
    }
     self.timeLabel.text =[NSString stringWithFormat:@"%ld",self.seconds];
}
- (void)removesSecondsTimer
{
    
    [_queTimer invalidate];
    _queTimer =nil;
}

- (void)timerAction
{
    float time = 1.0/self.queSeconds;
    _circleView.progress += time;

    if (_circleView.progress >= 1) {
        [self removeTimer];
        NSLog(@"完成");
    }
}

- (void)removeTimer
{
    [_timer invalidate];
    _timer = nil;
}


-(void)creatUI{
    
    if (self.answerButtonArray.count) {
        [self.answerButtonArray removeAllObjects];
    }
    self.answerButtonArray = [NSMutableArray array];
    
    self.symbol = [NSArray arrayWithObjects:@"~", @"!", @"@", @"#", @"$", @"%",@"^", @"&",@"*",@"(",@")",@"+",@"{",@"}",@":",@"<",@">",@"?",@"/",@"=",nil];
    self.symbolArray = [[NSMutableArray alloc] initWithArray:self.symbol];
    self.symbolResultArray = [[NSMutableArray alloc] init];
    NSInteger symbolCount = self.symbol.count;
    for (int i = 0; i < 10; i ++) {
        int index = arc4random() % (symbolCount - i);
        [self.symbolResultArray addObject:[self.symbolArray objectAtIndex:index]];
        [self.symbolArray removeObjectAtIndex:index];
        
    }

    self.number = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6",@"7", @"8",@"9",@"0",nil];
    self.numberArray = [[NSMutableArray alloc] initWithArray:self.number];
    self.numberResultArray = [[NSMutableArray alloc] init];
    NSInteger count = self.number.count;
    for (int i = 0; i < 10; i ++) {
        int index = arc4random() % (count - i);
        [self.numberResultArray addObject:[self.numberArray objectAtIndex:index]];
        [self.numberArray removeObjectAtIndex:index];
        
    }

    
    for (int i=0; i<10; i++) {
        UILabel *symbolLab =[[UILabel alloc]initWithFrame:CGRectMake(20+squareWidth*i, 120, squareWidth, squareWidth)];
        symbolLab.text =[NSString stringWithFormat:@"%@",self.symbolResultArray[i]];
        symbolLab.textColor =[UIColor whiteColor];
        symbolLab.textAlignment =NSTextAlignmentCenter;
        symbolLab.layer.borderWidth =2;
        symbolLab.font =[UIFont systemFontOfSize:25];
        symbolLab.layer.borderColor =[UIColor whiteColor].CGColor;
        [self.SymbolNumberView addSubview:symbolLab];
        
        UILabel *numberLab =[[UILabel alloc]initWithFrame:CGRectMake(20+squareWidth*i, 120+squareWidth, squareWidth, squareWidth)];
        numberLab.text =[NSString stringWithFormat:@"%@",self.numberResultArray[i]];
        numberLab.textColor =[UIColor whiteColor];
        numberLab.textAlignment =NSTextAlignmentCenter;
        numberLab.layer.borderWidth =2;
        numberLab.font =[UIFont systemFontOfSize:25];
        numberLab.layer.borderColor =[UIColor whiteColor].CGColor;
        [self.SymbolNumberView addSubview:numberLab];
    }
    
    self.resultArray = [[NSMutableArray alloc] init];
    self.answerArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i ++) {
        int index = arc4random()%10;
        [self.resultArray addObject:[self.symbolResultArray objectAtIndex:index]];
        [self.answerArray addObject:[self.numberResultArray objectAtIndex:index]];
        
    }
 
    for (int i=0; i<10; i++) {
        if (self.reloadAmount ==0 && self.surplusAmount >0) {
            if (i<5) {
                UILabel *queLab =[[UILabel alloc]initWithFrame:CGRectMake(20+squareWidth*i, 300, squareWidth, squareWidth)];
                queLab.text =[NSString stringWithFormat:@"%@",self.resultArray[i]];
                queLab.textColor =[UIColor whiteColor];
                queLab.textAlignment =NSTextAlignmentCenter;
                queLab.layer.borderWidth =2;
                queLab.font =[UIFont systemFontOfSize:25];
                queLab.layer.borderColor =[UIColor whiteColor].CGColor;
                [self.SymbolNumberView addSubview:queLab];
                
                SymbolNumberButton *button = [SymbolNumberButton buttonWithType:UIButtonTypeSystem];
                button.frame =CGRectMake(20+squareWidth*i, 300+squareWidth, squareWidth, squareWidth);
                button.tag =i+10;
                [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
                button.layer.borderWidth =2;
                button.layer.borderColor =[UIColor whiteColor].CGColor;
                button.titleLabel.font =[UIFont systemFontOfSize:25];
                [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                button.enabled=NO;
                [self.answerButtonArray addObject:button];
                [self.SymbolNumberView addSubview:button];
            }
        }else{
            UILabel *queLab =[[UILabel alloc]initWithFrame:CGRectMake(20+squareWidth*i, 300, squareWidth, squareWidth)];
            queLab.text =[NSString stringWithFormat:@"%@",self.resultArray[i]];
            queLab.textColor =[UIColor whiteColor];
            queLab.textAlignment =NSTextAlignmentCenter;
            queLab.layer.borderWidth =2;
            queLab.font =[UIFont systemFontOfSize:25];
            queLab.layer.borderColor =[UIColor whiteColor].CGColor;
            [self.SymbolNumberView addSubview:queLab];
            
            SymbolNumberButton *button = [SymbolNumberButton buttonWithType:UIButtonTypeSystem];
            button.frame =CGRectMake(20+squareWidth*i, 300+squareWidth, squareWidth, squareWidth);
            button.tag =i+10;
            [button setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
            button.layer.borderWidth =2;
            button.layer.borderColor =[UIColor whiteColor].CGColor;
            button.titleLabel.font =[UIFont systemFontOfSize:25];
            [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            button.enabled=NO;
            [self.answerButtonArray addObject:button];
            [self.SymbolNumberView addSubview:button];
        }
  
    }
    SymbolNumberButton * button = [self.SymbolNumberView.superview viewWithTag:10];
    [self clickButton:button];
    
}

-(void)click{

    [self.SymbolNumberView removeFromSuperview];
    self.SymbolNumberView =[[UIView alloc]initWithFrame:CGRectMake(0, 200, KScreenWidth, 500)];
    [self.view addSubview:self.SymbolNumberView];
    self.reloadAmount--;
    [self creatUI];

}

//点击 显示数独button
-(void)clickButton:(UIButton*)but{
    
    SymbolNumberButton *sdbut = (SymbolNumberButton *)but;
    //如果只是显示用的but 直接跳过。 不需要做任何操作。
//    NSLog(@"sdbut-%ld",sdbut.tag);
    if (sdbut.SymbolNumberButtonType & SymbolNumberButtonTypeShow) {
        return;
    }
    [self setAllButtonColorOrigin];
    [self initButtonsColor:sdbut];
    self.currentSelectButton = sdbut;
    
}
- (void)initButtonsColor:(UIButton *)button{
    
    button.layer.borderColor = FourOnlyNumColor.CGColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}
//将所有按钮的颜色还原。
-(void)setAllButtonColorOrigin{
    
    for (SymbolNumberButton *btn in self.answerButtonArray) {
        btn.layer.borderColor =[UIColor whiteColor].CGColor;
        [btn setSymbolNumberButtonType:btn.SymbolNumberButtonType];
    }
}


//点击了 下方数字button
-(void)inputNum:(UIButton *)but{
    
    //没有选中任何按钮的时候 就不进行任何操作。
    if (!self.currentSelectButton) {
        return;
    }
    
    //先得到当前点击的数字。
    NSInteger selectNum;

    selectNum = but.titleLabel.text.integerValue;

    NSString *answerStr =[NSString stringWithFormat:@"%@",self.answerArray[self.currentSelectButton.tag-10]];
    NSString *chooseStr =[NSString stringWithFormat:@"%ld",(long)selectNum];
    if ([answerStr isEqualToString:chooseStr]) {
        self.rightNumAmount++;
        
        float right = 1.0/self.queAmount;
        _progressView.progress += right;
    }else{
        [self.currentSelectButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    //改变button的显示。
    self.currentSelectButton.showNum = selectNum;

    [self nextBtn];
    if (self.currentSelectButton.tag ==0 && self.reloadAmount>0 ) {
        [self click];
    }else if (self.currentSelectButton.tag ==0 &&self.reloadAmount ==0){

        [self removeTimer];
        [self removesSecondsTimer];
        [self alertViewWithBlock];
        
        
    }
}
-(void)pushData{
    INetworking *net =[INetworking shareNet];
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [SVProgressHUD showWithStatus:@"数据上传中……"];
    
    //        dic[@"id"] =self.titleNum;
    dic[@"level"] =[NSString stringWithFormat:@"%ld",self.titleNum] ;
    dic[@"age"] =@"5";
    
//    dic[@"login_name"] = [JSStudentInfoManager manager].basicInfo.loginName;
    dic[@"stu_name"] = [JSStudentInfoManager manager].basicInfo.stuName;
    dic[@"password"] =[JSStudentInfoManager manager].basicInfo.passWord;
    dic[@"center"] = [JSStudentInfoManager manager].basicInfo.centerName;
    
    NSString *totleNumber =[NSString stringWithFormat:@"%ld",self.queAmount];
    NSString *number =[NSString stringWithFormat:@"%ld",self.rightNumAmount];
    dic[@"totlenumber"] =totleNumber;
    dic[@"number"] =number;
    dic[@"used_times"] =[NSString stringWithFormat:@"%ld",self.queSeconds-self.seconds];
    
    float score = [number floatValue]/[totleNumber floatValue];
    
    dic[@"stu_score"] = [NSString stringWithFormat:@"%.0f", score*100];
    
    NSString *url =[NSString stringWithFormat:@"%@%@.json",SERVISEURL,@"savesymbolicdigitalcodingrecords"];
    
    [net GET:url withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        
        if (isSuccess ==YES) {
            [SVProgressHUD showSuccessWithStatus:@"上传成功"];
            [SVProgressHUD dismissWithDelay:.7];
        }else{
            NSError *error =returnObject;
            if (error.code ==-1009) {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                    [self doSomeWork];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD showErrorWithStatus:@"无网络，请检查网络"];
                        [SVProgressHUD dismissWithDelay:.7];
                    });
                });
                
            }else if (error.code ==-1001){
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                    [self doSomeWork];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD showErrorWithStatus:@"网络超时"];
                        [SVProgressHUD dismissWithDelay:.7];
                    });
                });
            }else{
                NSLog(@"456");
                [SVProgressHUD showErrorWithStatus:@"上次失败"];
                [SVProgressHUD dismissWithDelay:.7];
            }
        }
        
    }];

}
#pragma mark --- block回调弹窗
- (void)alertViewWithBlock{
    float right =self.rightNumAmount;
    float starFloat = right/self.queAmount ;
    if (starFloat >=0.8){
        [self pushData];
    }
    
    HLAlertViewBlock * alertView = [[HLAlertViewBlock alloc]initWithRemainingSeconds:self.queSeconds-self.seconds rightAmount:self.rightNumAmount queAmount:self.queAmount block:^(NSInteger index) {
        if (index == AlertBlockSureButtonClick) {
            [self alertSureButtonClick];
        }else if (index == AlertBlockAgainButtonClick){
            [self alertAgainButtonClick];
        }else{
            [self alertCauseButtonClick];
        }
    }];
    
    [alertView show];
}
#pragma mark --- 弹窗点击事件
- (void)alertSureButtonClick{
    SymbolNumberVC *vc =[[SymbolNumberVC alloc]init];

    if (self.titleNum <6) {
        vc.queAmount =self.titleNum *5 +15;
        vc.titleNum = self.titleNum+1;
        vc.queSeconds =(self.titleNum *5 +15)*10;
    }else if (self.titleNum >=6 && self.titleNum <13){
        vc.queAmount =self.titleNum *5 ;
        vc.titleNum = self.titleNum+1;
        vc.queSeconds =(self.titleNum *5)*6;
    }else if (self.titleNum >=13 && self.titleNum <20){
        vc.queAmount =(self.titleNum-5) *5;
        vc.titleNum = self.titleNum+1;
        vc.queSeconds =((self.titleNum-5) *5)*4;
    }else if(self.titleNum ==20){
        vc.queAmount =999;
        vc.titleNum =999;
        vc.queSeconds =999;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
//    NSLog(@"点击了确认按钮");
}

- (void)alertCauseButtonClick{
    [self goToRootview];
//    NSLog(@"点击了取消按钮");
}

- (void)alertAgainButtonClick{
    SymbolNumberVC *vc =[[SymbolNumberVC alloc]init];

    vc.queAmount =self.queAmount;
    vc.titleNum = self.titleNum;
    vc.queSeconds =self.queSeconds;
    
    [self.navigationController pushViewController:vc animated:YES];
    //    NSLog(@"点击了再一次按钮");
}

- (void)doSomeWork {
    // Simulate by just waiting.
    sleep(3.);
}

-(void)nextBtn{

    SymbolNumberButton * button = [self.currentSelectButton.superview viewWithTag:self.currentSelectButton.tag+1];
    [self clickButton:button];

}

@end
