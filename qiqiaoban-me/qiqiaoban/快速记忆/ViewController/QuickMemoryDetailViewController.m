//
//  QuickMemoryDetailViewController.m
//  qiqiaoban
//
//  Created by Wei on 2019/8/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QuickMemoryDetailViewController.h"
#import "LightAlertViewController.h"
#import "QuickMemoryPresenter.h"
#import "QuickMemoryLevelModel.h"
#import "QuickMemoryGameView.h"

#import "HWWaveView.h"
#import "HWProgressView.h"
#import <Masonry/Masonry.h>

#define KMaxTime  3
#define KDURATION 1.2
#define KProgressFont [UIFont systemFontOfSize:12.0f]

@interface QuickMemoryDetailViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) HWWaveView *waveView_start;

@property (nonatomic, strong) UIView *gameMainView;
@property (nonatomic, strong) HWProgressView *progressView;
@property (nonatomic, strong) QuickMemoryGameView *gameView;

@property (nonatomic, strong) UILabel *successLabel;
@property (nonatomic, strong) UILabel *totalLabel;

@property (nonatomic, strong) UIButton *leftDifferentBtn;
@property (nonatomic, strong) UIButton *rightUnDifferentBtn;

@property (nonatomic, assign) NSInteger currentLevelCount;
@property (nonatomic, assign) NSInteger maxLevelCount;
@property (nonatomic, assign) NSInteger maxTimeSEC;

@property (nonatomic, assign) NSInteger successSelectedCount;
@property (nonatomic, assign) NSInteger allUsedTimes;

@property (strong, nonatomic) NSMutableArray<QuickMemoryLevelModel*> *firstDataList;

@end

@implementation QuickMemoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backgroundImageView.image = [UIImage imageNamed:@"trafficLightDetail_background"];
    self.titleLabel.text = @"快速记忆";

    self.currentLevelCount = 0;
    self.maxTimeSEC = KMaxTime;
    
    self.firstDataList = [[NSMutableArray alloc] init];
    
    [self getMemoryData];
    [self addGameView];
    
    self.gameMainView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.view addSubview:self.waveView_start];
    [self addTimer];
}

- (void)getMemoryData {
    self.currentLevelCount = 0;
    self.maxTimeSEC = KMaxTime;
    _successSelectedCount = 0;
    self.waveView_start.progress = 1.0;
    [self.gameView responseResultToDefault];
    [self.firstDataList removeAllObjects];

    if (self.level <= 5) {
        self.maxTimeSEC = 5;
    } else if (self.level <= 10) {
        self.maxTimeSEC = 4;
    } else if (self.level <= 15) {
        self.maxTimeSEC = 3;
    } else {
        self.maxTimeSEC = 2;
    }
    
    NSArray *datas = [QuickMemoryLevelModel countWithLevel:_level];
    self.maxLevelCount = [datas[0] integerValue];
    
    self.successLabel.text = [NSString stringWithFormat:@"%ld",_successSelectedCount];
    self.totalLabel.text = [NSString stringWithFormat:@"%ld",_maxLevelCount];
    
    NSInteger maxCount = [datas[0] integerValue];
    NSInteger colorCount = [datas[1] integerValue];
    NSInteger enumCount = [datas[2] integerValue];

    NSArray *colors = [self randLists:@[KColorWithRed,KColorWithGreen,KColorWithBlue,KColorWithCyan,KColorWithOrange,KColorWithPurple,KColorWithYellow] count:colorCount];
    /**
     0 -- 圆形
     1 -- 正方形
     2 -- 五角星
     3 -- 八边形
     4 -- 六边形
     5 -- 三角形
     */
    NSArray *enums = [self randLists:@[@0,@1,@2,@3,@4,@5] count:enumCount];
    for (NSInteger i=0; i<maxCount+1; i++) {
        QuickMemoryLevelModel *model = [self getQuickMemoryLevelModel:i enumCount:enumCount colors:colors enums:enums];
        [self.firstDataList addObject:model];
    }
}

- (QuickMemoryLevelModel*)getQuickMemoryLevelModel:(NSInteger)level enumCount:(NSInteger)enumCount colors:(NSArray*)colors enums:(NSArray*)enums{
    QuickMemoryLevelModel *model = [[QuickMemoryLevelModel alloc] init];
    model.colors = [NSArray arrayWithObjects:colors[rand()%colors.count], nil];
    model.graphShapes = @[enums[rand()%enums.count]];
    model.enumCount = enumCount;
    if (_level<=8) {
        model.drawCount = MAX(rand()%4, 2);
    } else if (_level<=15) {
        model.drawCount = MAX(rand()%6, 2);
    } else {
        model.drawCount = MAX(rand()%7, 2);
    }
    if (_level <= 5) {
        model.byType = 0;
    } else if (_level <= 15) {
        model.byType = rand()%2;
    } else {
        model.byType = rand()%3;
    }
    return model;
}

- (NSArray*)randLists:(NSArray*)list count:(NSInteger)count {
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:list];
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<count; i++) {
        id item = tempArray[rand()%tempArray.count];
        [results addObject:item];
        [tempArray removeObject:item];
    }
    return results;
}

- (void)addGameView {
    [self.view addSubview:self.gameMainView];
    [self.gameMainView addSubview:self.progressView];
    [self.gameMainView addSubview:self.gameView];
    [self.gameMainView addSubview:self.successLabel];
    [self.gameMainView addSubview:self.totalLabel];
    
    [self.gameMainView addSubview:self.leftDifferentBtn];
    [self.gameMainView addSubview:self.rightUnDifferentBtn];
    
    [self makeConstraintsWithView];
}

- (void)makeConstraintsWithView {
    
    [self.successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressView.mas_bottom).offset(5);
        make.left.equalTo(self.progressView.mas_left).offset(-10);
    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressView.mas_bottom).offset(5);
        make.right.equalTo(self.progressView.mas_right).offset(10);
    }];
    
    NSArray *bottomBtns = @[self.leftDifferentBtn, self.rightUnDifferentBtn];
    [bottomBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:1.0 leadSpacing:0.0 tailSpacing:0.0];
    [bottomBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.gameMainView.mas_bottom);
        make.height.equalTo(@80);
    }];
    
}

- (HWWaveView *)waveView_start {
    if (!_waveView_start) {
        _waveView_start = [[HWWaveView alloc] initWithFrame:CGRectMake((KScreenWidth-150)/2.0, (KScreenHeight-150-KNavigationBar_Height-KStatusBarHeight) / 2.0, 150, 150)];
        _waveView_start.maxNumber = KMaxTime;
        _waveView_start.progress = 1.0;
    }
    return _waveView_start;
}

#pragma mark FirstView
- (UIView *)gameMainView {
    if (!_gameMainView) {
        _gameMainView = [[UIView alloc] initWithFrame:CGRectMake(0, KNavigationBar_Height, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-KNavigationBar_Height)];
    }
    return _gameMainView;
}

- (HWProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[HWProgressView alloc] initWithFrame:CGRectMake(25, 15.0, KScreenWidth - 50, 25)];
        _progressView.maxNumber = self.maxLevelCount;
        _progressView.progress = self.currentLevelCount/self.maxLevelCount;
        _progressView.progressColor = UIColorFromRGB(0xf27733);
    }
    return _progressView;
}

- (QuickMemoryGameView *)gameView {
    if (!_gameView) {
        
        CGFloat width = MIN(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-KNavigationBar_Height - 80)* 0.65;
        _gameView = [[QuickMemoryGameView alloc] initWithFrame:CGRectMake(0, KNavigationBar_Height, width, width)];
        CGPoint center = self.gameMainView.center;
        center.y -= 80;
        _gameView.center = center;
        _gameView.progress = 1.0;
    }
    return _gameView;
}

- (UILabel *)successLabel {
    if (!_successLabel) {
        _successLabel = [[UILabel alloc] init];
        _successLabel.font = KProgressFont;
        _successLabel.textColor = [UIColor whiteColor];
        _successLabel.textAlignment = NSTextAlignmentLeft;
        _successLabel.text = [NSString stringWithFormat:@"%ld",_successSelectedCount];
    }
    return _successLabel;
}

- (UILabel *)totalLabel {
    if (!_totalLabel) {
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.font = KProgressFont;
        _totalLabel.textColor = [UIColor whiteColor];
        _totalLabel.textAlignment = NSTextAlignmentRight;
        _totalLabel.text = [NSString stringWithFormat:@"%ld",_maxLevelCount];
    }
    return _totalLabel;
}

- (UIButton *)leftDifferentBtn {
    if (!_leftDifferentBtn) {
        _leftDifferentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftDifferentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:25.0f];
        [_leftDifferentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftDifferentBtn setBackgroundColor:UIColorFromRGB(0x666666)];
        [_leftDifferentBtn setTitle:@"不同" forState:UIControlStateNormal];
        _leftDifferentBtn.showsTouchWhenHighlighted = YES;
        [_leftDifferentBtn addTarget:self action:@selector(differentAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftDifferentBtn;
}

- (UIButton *)rightUnDifferentBtn {
    if (!_rightUnDifferentBtn) {
        _rightUnDifferentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightUnDifferentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:25.0f];
        [_rightUnDifferentBtn setBackgroundColor:UIColorFromRGB(0x666666)];
        [_rightUnDifferentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightUnDifferentBtn setTitle:@"相同" forState:UIControlStateNormal];
        _rightUnDifferentBtn.showsTouchWhenHighlighted = YES;
        [_rightUnDifferentBtn addTarget:self action:@selector(unDifferentAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightUnDifferentBtn;
}

- (void)addTimer {
    [self removeTimer];

    _timer = [NSTimer scheduledTimerWithTimeInterval:0.03f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction {
    if ([self.waveView_start superview]) {
        //游戏启动倒计时结束
        self.waveView_start.progress -= 0.03 / KMaxTime;
        if (self.waveView_start.progress <= 0.000001) {
            [self.waveView_start removeFromSuperview];
            [self removeTimer];
            
            NSLog(@"游戏启动完成");
            [self showGuideGameView];
        }
    } else{
        //记忆训练选择结果倒计时结束
        self.gameView.progress -= 0.03 / _maxTimeSEC;
        if (self.gameView.progress <= 0.000001) {
            [self removeTimer];
            if (_currentLevelCount != 0) {
                [self errorForSelected];
            }
            
            if (_currentLevelCount > 0) {
                _allUsedTimes += _maxTimeSEC;
            }
            NSLog(@"游戏开始倒计时完成");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.currentLevelCount >= self.maxLevelCount) {
                    //游戏最后项目
                    [self removeTimer];
                    [self resultAlert];
                } else {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self startGame];
                    });
                }
            });
        }
    }
}

- (void)startGame {
    if (_currentLevelCount == _maxLevelCount) {
        [self removeTimer];
        [self resultAlert];
        return;
    }
    self.currentLevelCount++;
    self.progressView.progress = self.currentLevelCount*1.0/self.maxLevelCount;
    
    [self showFormallyGameView];
}

- (void)showGuideGameView {
    
    self.gameView.levelModel = self.firstDataList[_currentLevelCount];
    
    self.gameMainView.hidden = NO;
    self.progressView.hidden = YES;
    self.successLabel.hidden = YES;
    self.totalLabel.hidden = YES;
    self.gameView.hidden = NO;
    [self.gameView startAnimationPlay];
    
    self.gameView.progress = 1.0;
    [self addTimer];

    self.leftDifferentBtn.hidden = YES;
    self.rightUnDifferentBtn.hidden = YES;
    
    self.gameMainView.alpha = 1.0;
    
    /*
    [UIView animateWithDuration:KDURATION delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.gameMainView.alpha = 1.0;
    } completion:^(BOOL finished) {
        //倒计时记忆训练展示
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KMaxTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self closeGameView];
        });
    }];
     */
}

- (void)showFormallyGameView {
    [self.gameView responseResultToDefault];
    self.gameView.levelModel = self.firstDataList[_currentLevelCount];
    
    self.gameMainView.hidden = NO;
    self.progressView.hidden = NO;
    self.successLabel.hidden = NO;
    self.totalLabel.hidden = NO;
///    self.gameView.alpha = 0.0;
    self.gameView.hiddenTitle = NO;
    [self.gameView initInfo];
    self.gameView.alpha = 1.0;

    
    self.leftDifferentBtn.hidden = NO;
    self.rightUnDifferentBtn.hidden = NO;
    
    [self.gameView startAnimationPlay];
    self.gameView.progress = 1.0;
    [self addTimer];
    /**
    [UIView animateWithDuration:KDURATION delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.gameView.alpha = 1.0;
    } completion:^(BOOL finished) {
        //添加定时器
        [self.gameView startAnimationPlay];
        self.gameView.progress = 1.0;
        [self addTimer];
    }];
    */
}

- (void)closeGameView {
    [UIView animateWithDuration:KDURATION delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.gameView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeTimer];
        //添加定时器
        [self startGame];
    }];
}


- (void)removeTimer {
    [_timer invalidate];
    _timer = nil;
}

#pragma mark PrivateMethod
- (void)differentAction:(UIButton*)sender {
    [self removeTimer];
    
    if ([self.firstDataList[_currentLevelCount] isEqual:self.firstDataList[_currentLevelCount-1]]) {
        [self errorForSelected];
    } else {
        [self successForSelected];
    }
}

- (void)unDifferentAction:(UIButton*)sender {
    [self removeTimer];
    if (![self.firstDataList[_currentLevelCount] isEqual:self.firstDataList[_currentLevelCount-1]]) {
        [self errorForSelected];
    } else {
        [self successForSelected];
    }
    
}

- (void)resultAlert {
    [self removeTimer];
    if (_level == 21) {
        [self getMemoryData];
        [self startGame];
        return;
    }
    
    NSString *title = [NSString stringWithFormat:@"%ld 秒", _allUsedTimes];
    NSString *content = [NSString stringWithFormat:@"答对%ld个，共计%ld关", _successSelectedCount,_maxLevelCount];
    
    if (_successSelectedCount*1.0/_maxLevelCount >= 0.8) {
        NSMutableDictionary *parmers = [[NSMutableDictionary alloc] init];
        [parmers setValue:self.gameModel.mainId forKey:@"id"];
        [parmers setValue:self.gameModel.level?:[NSString stringWithFormat:@"%ld",_level] forKey:@"level"];
        [parmers setValue:[NSString stringWithFormat:@"%ld",_allUsedTimes] forKey:@"used_times"];
        [parmers setValue:[NSString stringWithFormat:@"%ld",_maxLevelCount] forKey:@"totlenumber"];
        [parmers setValue:[NSString stringWithFormat:@"%ld",_successSelectedCount] forKey:@"number"];
        /** 得分计算 **/
        [parmers setValue:[NSString stringWithFormat:@"%ld",_successSelectedCount] forKey:@"stu_score"];
        [self uploadLevelData:parmers];
        
        if (self.gameResultBlock) {
            self.gameResultBlock(YES);
        }
        
        LightAlertViewController *alertViewController = [LightAlertViewController alertWithTitle:title andContent:content];
        KWeakSelf(self);
        alertViewController.closeHandle = ^{
            KStrongSelf(self);
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        
        NSString *string = content;
        NSString *keyString = [NSString stringWithFormat:@"%ld", _successSelectedCount];
        NSDictionary *attributedDict = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:30.0],
                                         NSForegroundColorAttributeName:[UIColor redColor]
                                         };
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        NSRange range = [string rangeOfString:keyString];
        [attributedString addAttributes:attributedDict range:range];
        
        alertViewController.alertAttributedContent = attributedString;
        if (_successSelectedCount == _maxLevelCount) {
            alertViewController.resultScore = 3;
        } else {
            alertViewController.resultScore = 2;
        }

        LightAlertAction *confimAction = [LightAlertAction actionWithTitle:@"下一关" andTitleColor:UIColorFromRGB(0xFFFFFF) andBackgroundColor:UIColorFromRGB(0xff9900) action:^{
            KStrongSelf(self);
            self.level++;
            self.gameModel = self.dataList[self.level];
            
            [self getMemoryData];
            self.gameMainView.hidden = YES;
            [self.view addSubview:self.waveView_start];
            [self addTimer];
            
        }];
        [alertViewController addAction:confimAction];
        
        [self presentViewController:alertViewController animated:YES completion:nil];
    } else {
        if (self.gameResultBlock) {
            self.gameResultBlock(NO);
        }
        
        LightAlertViewController *alertViewController = [LightAlertViewController alertWithTitle:title andContent:content];
        KWeakSelf(self);
        alertViewController.closeHandle = ^{
            KStrongSelf(self);
            [self dismissViewControllerAnimated:YES completion:nil];
        };
        
        NSString *string = content;
        NSString *keyString = [NSString stringWithFormat:@"%ld", _successSelectedCount];
        NSDictionary *attributedDict = @{
                                         NSFontAttributeName:[UIFont systemFontOfSize:30.0],
                                         NSForegroundColorAttributeName:[UIColor redColor]
                                         };
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        NSRange range = [string rangeOfString:keyString];
        [attributedString addAttributes:attributedDict range:range];
        
        alertViewController.alertAttributedContent = attributedString;
        alertViewController.resultScore = 0;

        LightAlertAction *confimAction = [LightAlertAction actionWithTitle:@"真可惜，再试试吧" andTitleColor:UIColorFromRGB(0xFFFFFF) andBackgroundColor:UIColorFromRGB(0x333333) action:^{
            KStrongSelf(self);
            [self getMemoryData];
            self.gameMainView.hidden = YES;
            [self.view addSubview:self.waveView_start];
            [self addTimer];
        }];
        [alertViewController addAction:confimAction];
        
        [self presentViewController:alertViewController animated:YES completion:nil];
    }
}

- (void)successForSelected {
    NSLog(@"答案正确✅");
    [self.gameView responseResultWithSuccess:YES];
    _allUsedTimes += MAX(1, ceil(self.gameView.maxNumber - self.gameView.progress*self.gameView.maxNumber));
    
    _successSelectedCount++;
    self.successLabel.text = [NSString stringWithFormat:@"%ld",_successSelectedCount];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startGame];
    });
}

- (void)errorForSelected {
    NSLog(@"答案错误❌");
    [self.gameView responseResultWithSuccess:NO];

    _allUsedTimes += MAX(1, ceil(self.gameView.maxNumber - self.gameView.progress*self.gameView.maxNumber));
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startGame];
    });
}

- (void)uploadLevelData:(NSDictionary*)parmers {
    
    [QuickMemoryPresenter setLevelParmers:parmers resultBlock:^(QuickMemoryModel * _Nonnull memoryGameModel, BOOL isSuccess) {
        
    }];

}

@end
