//
//  SDViewController.m
//  shudu
//
//  Created by mac on 2019/6/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "SDViewController.h"

#import "SDView.h"

#import "JSShuDuAlertView.h"

#import "UIView+Frame.h"

#import "INetworking.h"

#import "JSStudentInfoManager.h"

#import "JSEDefine.h"

#import "ShuduTopicModel.h"

#import "SDButtonModel.h"

#import "JSShuDuAlertView.h"

#import "NSDate+Extention.h"



@interface SDViewController ()<SDViewDelegate>

//唯一显示数独
@property (nonatomic,retain) SDView *vi;

//sb添加的新部分
@property (nonatomic,retain) UIImageView *sbBack;

//当前显示的数独的题目。
@property (nonatomic,retain) ShuduTopicModel *currentModel;









































//一个傻逼的界面. 浪费时间的界面.
@property (nonatomic,retain) UIView *someView;



@end

@implementation SDViewController
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor lightGrayColor];
    self.currentMiaokeka = 0;
    
    [self loadOneShuduInfo];
}


//获取数独的题目信息.
-(void)loadOneShuduInfo{
    
    //获取一个新的题目的时候就将旧的放弃掉了.
    self.currentModel = [[ShuduTopicModel alloc] init];
    
    [JSShuDuAlertView showAlertWithStyle:JSShuDuAlertViewStyleLoding title:@"1" andFenshu:@"1" andFuBiao:@"1" andButtonTitle:@"" endFailus:^{
    
    }];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"login_name"] = [JSStudentInfoManager manager].basicInfo.loginName;
    
    WeakObject(self);
    
    [[INetworking shareNet] GET:@"http://114.55.90.93:8081/web/app/sdkstudentsubjectList.json" withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        if (isSuccess) {
            NSError *error;
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingMutableLeaves error:&error];
            NSDictionary *modelDic = weatherDic[@"sdksubList"];
            self.currentModel.standard_time = [weatherDic[@"standard_time"] integerValue];
            self.currentModel.ageGroup = [weatherDic[@"ageGroup"] integerValue];
            self.currentModel.shuduCount = [weatherDic[@"num"] integerValue];
            self.currentModel.wrongNum = [weatherDic[@"wrongnum"] integerValue];
            NSInteger shuduTotal = 0;
            if (self.currentModel.shuduCount == 4) {
                shuduTotal = 16;
            }else if (self.currentModel.shuduCount == 6){
                shuduTotal = 36;
            }else if (self.currentModel.shuduCount == 9){
                shuduTotal = 81;
            }
            //机器人,二进制和诗
            self.currentModel.level = modelDic[@"level"];
            self.currentModel.name = modelDic[@"name"];
            self.currentModel.sudokuid = modelDic[@"id"];
        
            
            
            for (int i = 0; i < shuduTotal; i ++) {
                //根据数独的个数 对模型进行创建.
                SDButtonModel *model = [[SDButtonModel alloc] init];
                //s接口 的问题. 所以这么写
                NSString *canshupart = [NSString stringWithFormat:@"%d",i + 1];
                NSString *showNumCan = [NSString stringWithFormat:@"lattice%@",canshupart];
                NSString *scoreCan = [NSString stringWithFormat:@"score%@",canshupart];
                model.showNumStr =modelDic[showNumCan];
                model.score = [modelDic[scoreCan] floatValue];
                [self.currentModel.SDButtonModelArray addObject:model];
            }
        
            if ([weatherDic[@"flag"] isEqualToString:@"1-10"]) {
                self.currentModel.isLastTopic = NO;
            }else if([weatherDic[@"flag"] isEqualToString:@"10"]){
                self.currentModel.isLastTopic = YES;
                [JSStudentInfoManager manager].isOverShudu = YES;
            }else if([weatherDic[@"flag"] isEqualToString:@"11"]){
                self.currentModel.isLastTopic = YES;
            }else{
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
               
                //在这里讲数独显示出来.
                [JSShuDuAlertView hideAlert];
               
                [self showShudu];
                
            });
        }else{
        }
    }];
}

//当获取到 数据之后 对数独模块进行显示.
-(void)showShudu{

    if (self.vi) {
        [self.vi removeFromSuperview];
    }
    if (self.sbBack) {
        [self.sbBack removeFromSuperview];
    }
    
    SDView *view = [[SDView alloc] init];
    if (self.currentModel.shuduCount == 9) {
        view.SDViewType = SDViewTypeNine;
    }else if(self.currentModel.shuduCount == 6){
        view.SDViewType = SDViewTypeSix;
    }else if(self.currentModel.shuduCount == 4){
        view.SDViewType = SDViewTypeFour;
    }
    
    view.width = self.view.width - 160;
    
    view.height = self.view.height - 170;
    
    view.centerX = self.view.width * .5;
    
    view.y = 170;
    
    [view creatView];
    
    
    
    //在添加view 之前 防止背景.
    
    //创建按钮的背景.
    
    
    UIImageView *clickButtonBack = [[UIImageView alloc] init];
    switch (view.SDViewType) {
        case SDViewTypeSix:
            clickButtonBack.image = [UIImage imageNamed:@"66666666666"];
            break;
        case SDViewTypeFour:
            clickButtonBack.image = [UIImage imageNamed:@"444444444"];
            break;
        case SDViewTypeNine:
            clickButtonBack.image = [UIImage imageNamed:@"999999999"];
            break;
        default:
            break;
    }
    
    clickButtonBack.width = self.view.width;
    clickButtonBack.x = 0;
    clickButtonBack.y = view.buttonHeight + view.y;
    clickButtonBack.height = self.view.height - clickButtonBack.y;
    [self.view addSubview:clickButtonBack];
    self.sbBack = clickButtonBack;
    
    
    
    
    //继续开始闯将view.
    
    
    [self.view addSubview:view];
    
    self.vi = view;
    
    view.delegate = self;
    
    [self setUpClearButtonTitle:self.currentModel.wrongNum];
    
    self.titleLabel.text = self.currentModel.name;
    
    for (int i = 0;i < self.currentModel.SDButtonModelArray.count; i ++) {
        
        ShuduButton *sdButton = self.vi.shuduButtonArray[i];
        
        SDButtonModel *sdButtonModel = self.currentModel.SDButtonModelArray[i];
        
        if ([sdButtonModel.showNumStr isEqualToString:@"0"]) {
            sdButton.ShuduButtonType = ShuduButtonTypeClick;
            sdButton.isInRightPlace = NO;
            sdButton.showNum = 0;
            sdButton.score = sdButtonModel.score;
        }else{
            sdButton.ShuduButtonType = ShuduButtonTypeShow;
            sdButton.isInRightPlace = YES;
            sdButton.showNum = sdButtonModel.showNumStr.integerValue;
        }
        
    }
    
    [self goTime];
    
}

-(void)setUpClearButtonTitle:(NSInteger)count{
    [self.vi.clearButton setTitle:[NSString stringWithFormat:@"清除本格(%ld)",count] forState:UIControlStateNormal];
}


-(void)clickButton:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)tiaoGuo{
    NSString *buttonTitle;
    
    [self stopTime];
    
    if (self.currentModel.isLastTopic) {
        buttonTitle = @"结束训练";
    }else{
        buttonTitle = @"下一题";
    }
    
    [self uploadInfo];
    WeakObject(self);
    [JSShuDuAlertView showAlertWithStyle:JSShuDuAlertViewStyleBujige title:@"1" andFenshu:@"0分" andFuBiao:@"跳过了题目" andButtonTitle:buttonTitle endFailus:^{
        
        [JSShuDuAlertView hideAlert];
        
        if(selfWeak.currentModel.isLastTopic){
            [selfWeak dismissViewControllerAnimated:YES completion:nil];
        }else{
            
            [selfWeak loadOneShuduInfo];
        }
        
    }];
}

-(void)chakanAnswer{
//    [JSShuDuAlertView showAlertWithStyle:JSShuDuAlertViewStyleLevelUp title:@"2" andFenshu:@"99分" andFuBiao:nil andButtonTitle:@"下一题" endFailus:^{
//        [JSShuDuAlertView hideAlert];
//    }];
}

//退出的按钮。
-(void)clickQuit{
    [self uploadInfo];
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - sdviewdelegate
//这里的sdview 已经做完了所有操作.
//需要对button判断对错.
-(void)SDView:(SDView *)sd didEnterOneNum:(NSInteger)num inButton:(ShuduButton *)but{
    
    //判定是否完成数独.   看来是不需要了.
    static NSInteger rightNum = 0;
    for (ShuduButton *arrayBut in sd.shuduButtonArray) {
        if (arrayBut.showNum != 0) {
            rightNum  ++;
        }
    }
    if (rightNum == self.currentModel.SDButtonModelArray.count) {
        self.currentModel.isFinish = YES;
        [sd.uploadButton setBackgroundColor:JSColor(47, 187, 88, 1)];
    }
    rightNum = 0;
}

-(void)SDView:(SDView *)sd willEnterOneNum:(NSInteger)num inButton:(ShuduButton *)but{
    
    //对当前按钮进行处理 判断是否正确
    [self checkButton:but withWillNum:num];
    
    
}


//是否 上传
-(BOOL)SDView:(SDView *)sd canClcikUploadButton:(UIButton *)but{
    if (self.currentModel.isFinish) {
        return YES;
    }else{
        return NO;
    }
}

// 点击能否收到消除按钮的反馈.
-(BOOL)SDView:(SDView *)sd canClcikClearButton:(UIButton *)but{
    return YES;
}


//能否消除数字.  如果不能  自行解决.
-(BOOL)SDView:(SDView *)sd canClear:(UIButton *)but{
    
    if (self.currentModel.useWrongTimes == 0) {
        
        UIView *view = [[UIView alloc] init];
        view.frame = self.view.bounds;
        view.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
        
        [self.view addSubview:view];
        
        UIView *containView = [[UIView alloc] init];
        containView.width = self.view.width * .51;
        containView.height = containView.width;
        containView.backgroundColor = [UIColor whiteColor];
        [view addSubview:containView];
        containView.centerX = self.view.width * .5;
        containView.centerY = self.view.height * .5;
        containView.layer.cornerRadius = 10;
        containView.layer.masksToBounds = YES;
        
        //top
        UIImageView *top = [[UIImageView alloc] init];
        top.image = [UIImage imageNamed:@"3确认清除（上）"];
        [top sizeToFit];
        CGFloat topscale = containView.width * 1.0 / top.width;
        top.width = topscale * top.width;
        top.height = topscale * top.height;
        top.x = 0;
        top.y = 0;
        [containView addSubview:top];
        
        
        //bott
        
        UIImageView *bott = [[UIImageView alloc] init];
        bott.image = [UIImage imageNamed:@"3确认清除（下）"];
        [bott sizeToFit];
        CGFloat bottscale = containView.width * 1.0 / bott.width;
        bott.width = bottscale * bott.width;
        bott.height = bottscale * bott.height;
        bott.userInteractionEnabled = YES;
        bott.x = 0;
        bott.y = containView.height - bott.height;
        [containView addSubview:bott];
        
        
        //headerBack
        
        UIImageView *headerBack = [[UIImageView alloc] init];
        headerBack.image = [UIImage imageNamed:@"3确认清除（中）"];
        [headerBack sizeToFit];
        CGFloat headerBackscale = containView.width * 1.0 / headerBack.width;
        headerBack.width = headerBackscale * headerBack.width;
        headerBack.height = headerBackscale * headerBack.height;
        headerBack.x = 0;
        headerBack.y = CGRectGetMinY(bott.frame) - headerBack.height;
        [containView addSubview:headerBack];
        
        //title
        UILabel *titleLabel  = [[UILabel alloc] init];
        titleLabel.text = @"确认消除宫格的数字";
        titleLabel.font = JSBold(35);
        [titleLabel sizeToFit];
        titleLabel.centerX = containView.width * .5;
        titleLabel.y = containView.height * .1;
        [containView addSubview:titleLabel];
        
        //content
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.text = [NSString stringWithFormat:@"剩余可免费试用次数%ld次,\n次数用完后再次使用则一次扣一分",self.currentModel.wrongNum];
        contentLabel.width = titleLabel.width * .617;
        contentLabel.height = headerBack.height * .5;
        contentLabel.font = JSFont(17);
        contentLabel.textAlignment = NSTextAlignmentLeft;
        contentLabel.numberOfLines = 0;
        contentLabel.x = titleLabel.x;
        contentLabel.centerY = headerBack.height * .65;
        [headerBack addSubview:contentLabel];
        
        //橡皮
        UIImageView *ereazer = [[UIImageView alloc] init];
        ereazer.image = [UIImage imageNamed:@"5橡皮擦"];
        [ereazer sizeToFit];
        CGFloat erazeScale = titleLabel.width * .383 / ereazer.width;
        ereazer.width = erazeScale * ereazer.width;
        ereazer.height = erazeScale * ereazer.height;
        ereazer.centerY = contentLabel.centerY;
        ereazer.x = CGRectGetMaxX(contentLabel.frame) + 20;
        [headerBack addSubview:ereazer];
        
        //按钮.
        UIButton *but1= [[UIButton alloc] init];
        [but1 setBackgroundColor:[UIColor whiteColor]];
        [but1 setTitle:@"取消" forState:UIControlStateNormal];
        [but1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        but1.height = 50;
        but1.width = containView.width * .33;
        but1.centerY = bott.height * .42;
        but1.centerX = containView.width * .23;
        but1.layer.cornerRadius = 25;
        but1.layer.masksToBounds = YES;
        
        [bott addSubview:but1];
        
        
        UIButton *but2= [[UIButton alloc] init];
        [but2 setBackgroundColor:JSColor(234, 62, 57, 1)];
        [but2 setTitle:@"是" forState:UIControlStateNormal];
        [but2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        but2.width = but1.width;
        but2.height = but1.height;
        but2.centerY = but1.centerY;
        but2.centerX = containView.width * .77;
        but2.layer.cornerRadius = 25;
        but2.layer.masksToBounds = YES;
        
        [bott addSubview:but2];
        
        self.someView = view;
        
        [but1 addTarget:self action:@selector(touchSbBut:) forControlEvents:UIControlEventTouchUpInside];
        [but2 addTarget:self action:@selector(touchSbBut:) forControlEvents:UIControlEventTouchUpInside];
        but1.tag = 1;
        but2.tag = 2;
        
        
        return NO;
    
    }else{
    
    return YES;
    }
}

-(void)touchSbBut:(UIButton *)sender{
    
    if (sender.tag == 1) {
        
        [self.someView removeFromSuperview];
        
    }else{
        
        
        
        [self.someView removeFromSuperview];
        
        self.currentModel.isFinish = NO;
        [self.vi.uploadButton setBackgroundColor:[UIColor grayColor]];
        
        
        self.currentModel.useWrongTimes ++;
        if (self.currentModel.wrongNum == 0) {
            //原本要改变button的颜色
            //        [sd.clearButton setBackgroundColor:[UIColor grayColor]];
        }
        [self.vi.currentSelectButton setShowNum:0];
        [self setUpClearButtonTitle:(self.currentModel.wrongNum - self.currentModel.useWrongTimes)];
        
        //确实清除之后.  就需要对 清除按钮的 横列竖列 所有的按钮 进行逐一检查.
        
        
        
        //将操作按钮 同排同列的 按钮装入数组.
        NSMutableArray *numedArray = [NSMutableArray array];
        for (ShuduButton *arrayBut in self.vi.shuduButtonArray) {
            if (arrayBut.titleLabel.text&&(arrayBut.iAre == self.vi.currentSelectButton.iAre || arrayBut.Posi.ycount == self.vi.currentSelectButton.Posi.ycount || arrayBut.Posi.xcount == self.vi.currentSelectButton.Posi.xcount)&&arrayBut!=self.vi.currentSelectButton) {
                [numedArray addObject:arrayBut];
            }
        }
        for (ShuduButton *but in numedArray) {
            [self checkButton:but withWillNum:but.showNum];
        }
        
    }
}

//清除后
-(void)SDView:(SDView *)sd didClickClearButton:(UIButton *)but{
    self.currentModel.isFinish = NO;
    [sd.uploadButton setBackgroundColor:[UIColor grayColor]];
   
    self.currentModel.useWrongTimes ++;
    
    if (self.currentModel.wrongNum == 0) {
        
    }
    
    [self setUpClearButtonTitle:(self.currentModel.wrongNum - self.currentModel.useWrongTimes)];
    
    //确实清除之后.  就需要对 清除按钮的 横列竖列 所有的按钮 进行逐一检查.
    
    
    
    //将操作按钮 同排同列的 按钮装入数组.
    NSMutableArray *numedArray = [NSMutableArray array];
    for (ShuduButton *arrayBut in self.vi.shuduButtonArray) {
        if (arrayBut.titleLabel.text&&(arrayBut.iAre == self.vi.currentSelectButton.iAre || arrayBut.Posi.ycount == self.vi.currentSelectButton.Posi.ycount || arrayBut.Posi.xcount == self.vi.currentSelectButton.Posi.xcount)&&arrayBut!=but) {
            [numedArray addObject:arrayBut];
        }
    }
    for (ShuduButton *but in numedArray) {
        [self checkButton:but withWillNum:but.showNum];
    }
    
    
}

//点击 上传的操作.
-(void)SDView:(SDView *)sd didClickUloadButton:(UIButton *)but{
    
    
    //在这里计算得分.
    [self stopTime];
    
    
    for (ShuduButton *but in self.vi.shuduButtonArray) {
        
        if (but.ShuduButtonType == ShuduButtonTypeClick && but.isInRightPlace == YES) {
            
            self.currentModel.totalScore = self.currentModel.totalScore + but.score;
            
        }
    }
    
    JSShuDuAlertViewStyle shuduAlertStyle;
    
    
    if (self.currentModel.totalScore < 60) {
        shuduAlertStyle = JSShuDuAlertViewStyleBujige;
    }else if (self.currentModel.totalScore > 60) {
        shuduAlertStyle = JSShuDuAlertViewStyleVeryGood;
    }else{
        shuduAlertStyle = JSShuDuAlertViewStyleVeryGood;
    }
    
    int toatl = (int)(self.currentModel.totalScore + 0.5);
    
    
    //累加分数.
    if (self.currentModel.useWrongTimes >= self.currentModel.wrongNum) {
        
        toatl = toatl - (int)(self.currentModel.useWrongTimes - self.currentModel.wrongNum);
        
    }
    
    //保证不会出现负的分数.
    if (toatl < 0) {
        toatl = 0;
    }
    
    
    
    
    
    if (self.currentMiaokeka > self.currentModel.standard_time) {
        shuduAlertStyle = JSShuDuAlertViewStyleOutTime;
        toatl = 0;
    }
    
    
    
    
    NSString *fenshu = [NSString stringWithFormat:@"%d分",toatl];
    
    NSString *buttonTitle;
    
    if (self.currentModel.isLastTopic) {
        buttonTitle = @"结束训练";
    }else{
        buttonTitle = @"下一题";
    }
    WeakObject(self);
    
    [JSShuDuAlertView showAlertWithStyle:shuduAlertStyle title:@"feichanghao" andFenshu:fenshu andFuBiao:@"" andButtonTitle:buttonTitle endFailus:^{
       
        [JSShuDuAlertView hideAlert];
        
        if(selfWeak.currentModel.isLastTopic){
            [selfWeak dismissViewControllerAnimated:YES completion:nil];
        }else{
            [selfWeak uploadInfo];
            [selfWeak loadOneShuduInfo];
        }
    }];
    
    
}

-(void)uploadInfo{
    
    JSStudentInfoManager *manager = [JSStudentInfoManager manager];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"used_times"] = [NSString stringWithFormat:@"%ld",self.currentMiaokeka];
    self.currentMiaokeka = 0;
    dic[@"level"] = self.currentModel.level;
    dic[@"agegroup"] = [NSString stringWithFormat:@"%ld",self.currentModel.ageGroup];
    dic[@"name"] = self.currentModel.name;
    dic[@"sudokuid"] = self.currentModel.sudokuid;
    dic[@"stu_name"] = manager.basicInfo.stuName;
    dic[@"login_name"] = manager.basicInfo.loginName;
    dic[@"center"] = manager.basicInfo.centerName;
    
    
    
    NSDate *birthDate = [NSDate JSDateFromString:[JSStudentInfoManager manager].basicInfo.birthday];
    
    NSString *birthStr = [birthDate dateToYear];
    
    NSInteger birthNum = [birthStr integerValue];
    
    NSString *currentStr = [[NSDate date] dateToYear];
    
    NSInteger currentNum = [currentStr integerValue];
    
    NSInteger age = currentNum - birthNum;
    
    dic[@"age"] = [NSString stringWithFormat:@"%ld",(long)age];
    
    
    
    int toatl = (int)(self.currentModel.totalScore + 0.5);
    
    if (toatl < 0) {
        toatl = 0;
    }
    
    dic[@"stu_score"] = [NSString stringWithFormat:@"%d",toatl];
    dic[@"wrongtimes"] = [NSString stringWithFormat:@"%ld",self.currentModel.useWrongTimes];
    [[INetworking shareNet] GET:@"http://114.55.90.93:8081/web/app/savesdkrecords.json" withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        
    }];
    
}


#pragma mark - checkMethod

//判断填入num的 按钮是否是正确的.
-(void)checkButton:(ShuduButton *)but withWillNum:(NSInteger)num{
    
    //如果不是可点击按钮就取消.
    if (but.ShuduButtonType != ShuduButtonTypeClick) {
        return;
    }
    
    //将操作按钮 同排同列的 按钮装入数组.
    NSMutableArray *numedArray = [NSMutableArray array];
    for (ShuduButton *arrayBut in self.vi.shuduButtonArray) {
        if (arrayBut.titleLabel.text&&(arrayBut.iAre == but.iAre || arrayBut.Posi.ycount == but.Posi.ycount || arrayBut.Posi.xcount == but.Posi.xcount)&&arrayBut!=but) {
            
            
            [numedArray addObject:@(arrayBut.showNum)];
            
            
        }
        
        
        
    }
    
    //判断这个按钮是否正确.
    if ([numedArray containsObject:@(num)]) {
        //当前的数字已经是存在的了.
//        [but setTitleColor:but.wrongTitleColor forState:UIControlStateNormal];
        but.isInRightPlace = NO;
    }else{
//        [but setTitleColor:but.clickTypeTitleColor forState:UIControlStateNormal];
        but.isInRightPlace = YES;
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
