//
//  MemoryGameDetailViewController.m
//  qiqiaoban
//
//  Created by Wei on 2019/8/11.
//  Copyright © 2019 mac. All rights reserved.
//

#import "MemoryGameDetailViewController.h"
#import "LightAlertViewController.h"
#import "GameEnumView.h"
#import "HWCircleView.h"
#import "HWProgressView.h"
#import <Masonry/Masonry.h>
#import "TrafficLightPresenter.h"
#import "QuickFlashingPresenter.h"
#import "StroopEffectPresenter.h"

#define KMaxTime  3
#define KDURATION 1.2
#define KProgressFont [UIFont systemFontOfSize:12.0f]

@interface MemoryGameDetailViewController ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) HWCircleView *circleView_start;

@property (nonatomic, strong) UIView *gameMainView;
@property (nonatomic, strong) HWProgressView *progressView;
@property (nonatomic, strong) HWCircleView *circleView;
@property (nonatomic, strong) UIButton *titleButton;
@property (nonatomic, strong) UIButton *leftGameLight;
@property (nonatomic, strong) UIButton *rightGameLight;
@property (nonatomic, strong) UIImageView *middleGameView;

@property (nonatomic, strong) UILabel *successLabel;
@property (nonatomic, strong) UILabel *totalLabel;

@property (nonatomic, strong) UIButton *leftDifferentBtn;
@property (nonatomic, strong) UIButton *rightUnDifferentBtn;

@property (nonatomic, strong) GameEnumView *gameEnumView;

@property (nonatomic, assign) NSInteger currentLevelCount;
@property (nonatomic, assign) NSInteger maxLevelCount;
@property (nonatomic, assign) NSInteger maxTimeSEC;

@property (nonatomic, assign) NSInteger successSelectedCount;
@property (nonatomic, assign) NSInteger allUsedTimes;

@property (strong, nonatomic) NSMutableArray<MemoryGameLevelModel*> *firstDataList;

@end

@implementation MemoryGameDetailViewController

- (NSArray*)getStroopEffectData {
    
    return @[@{@"color":KColorWithRed,@"word":@"红色"},
             @{@"color":KColorWithOrange,@"word":@"橙色"},
             @{@"color":KColorWithYellow,@"word":@"黄色"},
             @{@"color":KColorWithGreen,@"word":@"绿色"},
             @{@"color":KColorWithCyan,@"word":@"青色"},
             @{@"color":KColorWithBlue,@"word":@"蓝色"},
             @{@"color":KColorWithPurple,@"word":@"紫色"},
             @{@"color":KColorWithGray,@"word":@"灰色"},
             @{@"color":KColorWithBlack,@"word":@"黑色"},
             @{@"color":KColorWithRed,@"word":@"Red"},
             @{@"color":KColorWithOrange,@"word":@"Orange"},
             @{@"color":KColorWithYellow,@"word":@"Yellow"},
             @{@"color":KColorWithGreen,@"word":@"Green"},
             @{@"color":KColorWithCyan,@"word":@"Cyan"},
             @{@"color":KColorWithBlue,@"word":@"Blue"},
             @{@"color":KColorWithPurple,@"word":@"Purple"},
             @{@"color":KColorWithGray,@"word":@"Gray"},
             @{@"color":KColorWithBlack,@"word":@"Black"},];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentLevelCount = 0;
    self.maxTimeSEC = KMaxTime;
    
    self.firstDataList = [[NSMutableArray alloc] init];

    self.backgroundImageView.image = [UIImage imageNamed:@"trafficLightDetail_background"];
    if (self.memoryGameType == XTMemoryGameTypeWithTrafficLight) {
        self.titleLabel.text = @"交通灯";
        
    } else if (self.memoryGameType == XTMemoryGameTypeWithQuickFlashing) {
        self.titleLabel.text = @"快闪图标";

    } else if (self.memoryGameType == XTMemoryGameTypeWithStroopEffect) {
        self.titleLabel.text = @"斯特鲁普测验";
        [UIColor orangeColor];
    }

    [self getMemoryData];
    
    [self addGameView];
    
    self.gameMainView.hidden = YES;
    [self.view addSubview:self.circleView_start];
    [self addTimer];
}

- (void)getMemoryData {
    self.currentLevelCount = 0;
    self.maxTimeSEC = KMaxTime;
    _successSelectedCount = 0;
    self.circleView_start.progress = 1.0;
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
    
    if (self.memoryGameType == XTMemoryGameTypeWithTrafficLight) {
        NSArray *datas = [MemoryGameLevelModel countWithLevelGameType:_memoryGameType level:_level];
        self.maxLevelCount = [datas[0] integerValue];
        
        NSInteger maxCount = [datas[0] integerValue];
        NSInteger colorCount = [datas[1] integerValue];
        NSInteger enumCount = [datas[2] integerValue] * 3;
        NSArray *colors = [self randLists:@[KColorWithRed,KColorWithGreen] count:colorCount];
        for (NSInteger i=0; i<maxCount+1; i++) {
            MemoryGameLevelModel *model = [self getTrifficLightLevelModel:maxCount colors:colors enumCount:enumCount Index:i];
            [self.firstDataList addObject:model];
        }
        
    } else if (self.memoryGameType == XTMemoryGameTypeWithQuickFlashing) {
        NSArray *datas = [MemoryGameLevelModel countWithLevelGameType:_memoryGameType level:_level];
        self.maxLevelCount = [datas[0] integerValue];
        
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
            MemoryGameLevelModel *model = [self getQuickFlashingLevelModel:maxCount colors:colors enums:enums Index:i];
            [self.firstDataList addObject:model];
        }
    } else if (self.memoryGameType == XTMemoryGameTypeWithStroopEffect) {
        NSArray *datas = [MemoryGameLevelModel countWithLevelGameType:_memoryGameType level:_level];
        self.maxLevelCount = [datas[0] integerValue];
        
        NSInteger maxCount = [datas[0] integerValue];
        NSInteger colorCount = [datas[1] integerValue];
        NSInteger enumCount = [datas[2] integerValue];
        
        NSArray *sourceEnums = nil;
        if (_level < 15) {
            sourceEnums = [[self getStroopEffectData] subarrayWithRange:NSMakeRange(0, 9)];
        } else if (_level < 22) {
            sourceEnums = [[self getStroopEffectData] subarrayWithRange:NSMakeRange(9, 18)];
        } else {
            sourceEnums = [self getStroopEffectData];
        }
        
        NSArray *randEnums = [self randLists:sourceEnums count:colorCount];
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        NSMutableArray *enums = [[NSMutableArray alloc] init];
        for (NSDictionary *object in randEnums) {
            [colors addObject:object[@"color"]];
            [enums addObject:object[@"word"]];
        }
        
        for (NSInteger i=0; i<maxCount+1; i++) {
            MemoryGameLevelModel *model = [self getStroopEffectLevelModel:maxCount colors:colors enums:enums Index:i];
            [self.firstDataList addObject:model];
        }
    }
    
    self.successLabel.text = [NSString stringWithFormat:@"%ld",_successSelectedCount];
    self.totalLabel.text = [NSString stringWithFormat:@"%ld",_maxLevelCount];
}

- (MemoryGameLevelModel*)getTrifficLightLevelModel:(NSInteger)maxCount colors:(NSArray<UIColor*>*)colors enumCount:(NSInteger)enumCount Index:(NSInteger)index {
    MemoryGameLevelModel *model = [[MemoryGameLevelModel alloc] init];
    NSMutableArray *colorIndexs = [[NSMutableArray alloc] init];
    [colorIndexs addObject:[NSNumber numberWithInt:rand()%3]];

    model.colorIndexs = colorIndexs;
    model.maxCount = enumCount;
    model.colors = colors;
    
    return model;
}

- (MemoryGameLevelModel*)getQuickFlashingLevelModel:(NSInteger)maxCount colors:(NSArray*)colors enums:(NSArray*)enums Index:(NSInteger)index {
    MemoryGameLevelModel *model = [[MemoryGameLevelModel alloc] init];
    model.colors = @[colors[rand()%colors.count]];
    model.graphShapes = @[enums[rand()%enums.count]];

    return model;
}

- (MemoryGameLevelModel*)getStroopEffectLevelModel:(NSInteger)maxCount colors:(NSArray*)colors enums:(NSArray*)enums Index:(NSInteger)index {
    MemoryGameLevelModel *model = [[MemoryGameLevelModel alloc] init];
    model.colors = @[colors[rand()%colors.count]];
    model.colorWords = @[enums[rand()%enums.count]];
    
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
    if (_memoryGameType != XTMemoryGameTypeWithStroopEffect) {
        [self.gameMainView addSubview:self.titleButton];
    }
    [self.gameMainView addSubview:self.circleView];
    [self.gameMainView addSubview:self.middleGameView];
    [self.gameMainView addSubview:self.leftGameLight];
    [self.gameMainView addSubview:self.rightGameLight];
    [self.middleGameView addSubview:self.gameEnumView];
    
    [self.gameMainView addSubview:self.successLabel];
    [self.gameMainView addSubview:self.totalLabel];
    
    [self.gameMainView addSubview:self.leftDifferentBtn];
    [self.gameMainView addSubview:self.rightUnDifferentBtn];
    
    [self makeConstraintsWithView];
}

- (void)makeConstraintsWithView {
    [self.gameMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(KNavigationBar_Height);
    }];
    
    [self.successLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressView.mas_bottom).offset(5);
        make.left.equalTo(self.progressView.mas_left).offset(-10);
    }];
    
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.progressView.mas_bottom).offset(5);
        make.right.equalTo(self.progressView.mas_right).offset(10);
    }];
    
    [self.middleGameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.gameMainView.mas_centerX);
        make.centerY.equalTo(self.gameMainView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(420/7.0*6.5, 420/7.0*6.5*0.8));
    }];
    [self.leftGameLight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.middleGameView.mas_centerY);
        make.right.equalTo(self.middleGameView.mas_left);
    }];
    [self.rightGameLight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.middleGameView.mas_centerY);
        make.left.equalTo(self.middleGameView.mas_right);
    }];
    
    [self.gameEnumView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.middleGameView);
    }];
    
    NSArray *bottomBtns = @[self.leftDifferentBtn, self.rightUnDifferentBtn];
    [bottomBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:1.0 leadSpacing:0.0 tailSpacing:0.0];
    [bottomBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.gameMainView.mas_bottom);
        make.height.equalTo(@80);
    }];
    
}

- (HWCircleView *)circleView_start {
    if (!_circleView_start) {
        _circleView_start = [[HWCircleView alloc] initWithFrame:CGRectMake((KScreenWidth-150)/2.0, (KScreenHeight-150-KNavigationBar_Height-KStatusBarHeight) / 2.0, 150, 150)];
        _circleView_start.maxNumber = KMaxTime;
        _circleView_start.progress = 1.0;
    }
    return _circleView_start;
}

#pragma mark FirstView
- (UIView *)gameMainView {
    if (!_gameMainView) {
        _gameMainView = [[UIView alloc] init];
    }
    return _gameMainView;
}

- (HWProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[HWProgressView alloc] initWithFrame:CGRectMake(25, 15.0, KScreenWidth - 50, 10)];
        _progressView.maxNumber = self.maxLevelCount;
        _progressView.progress = self.currentLevelCount/self.maxLevelCount;
    }
    return _progressView;
}

- (UIButton *)titleButton {
    if (!_titleButton) {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.frame = CGRectMake(0, 65, KScreenWidth, 40);
        _titleButton.userInteractionEnabled = NO;
        _titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:30.0f];
        [_titleButton setTitle:@"是否与前一张相同？" forState:UIControlStateNormal];
        [_titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _titleButton;
}

- (HWCircleView *)circleView {
    if (!_circleView) {
        _circleView = [[HWCircleView alloc] initWithFrame:CGRectMake((KScreenWidth-50)/2.0, 130, 50, 50)];
        _circleView.lineWidth = 5.0f;
        _circleView.titleFont = [UIFont boldSystemFontOfSize:35];
        _circleView.maxNumber = _maxTimeSEC;
        _circleView.progress = 1.0;
    }
    return _circleView;
}

- (UIButton *)leftGameLight {
    if (!_leftGameLight) {
        _leftGameLight = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftGameLight.userInteractionEnabled = NO;
        [_leftGameLight setImage:[UIImage imageNamed:@"answer_normal"] forState:UIControlStateNormal];
    }
    return _leftGameLight;
}
- (UIButton *)rightGameLight {
    if (!_rightGameLight) {
        _rightGameLight = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightGameLight.userInteractionEnabled = NO;
        [_rightGameLight setImage:[UIImage imageNamed:@"answer_normal"] forState:UIControlStateNormal];
    }
    return _rightGameLight;
}

- (UIImageView *)middleGameView {
    if (!_middleGameView) {
        _middleGameView = [[UIImageView alloc] init];
        _middleGameView.backgroundColor = UIColorFromRGB(0xEEEEEE);
    }
    return _middleGameView;
}

- (GameEnumView *)gameEnumView {
    if (!_gameEnumView) {
        _gameEnumView = [[GameEnumView alloc] initWithXTMemoryGameType:self.memoryGameType];
    }
    return _gameEnumView;
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
        [_leftDifferentBtn setBackgroundColor:UIColorFromRGB(0xff9900)];
        if (_memoryGameType == XTMemoryGameTypeWithStroopEffect) {
            [_leftDifferentBtn setTitle:@"否" forState:UIControlStateNormal];
        } else {
            [_leftDifferentBtn setTitle:@"不同" forState:UIControlStateNormal];
        }
        _leftDifferentBtn.showsTouchWhenHighlighted = YES;
        [_leftDifferentBtn addTarget:self action:@selector(differentAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftDifferentBtn;
}

- (UIButton *)rightUnDifferentBtn {
    if (!_rightUnDifferentBtn) {
        _rightUnDifferentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightUnDifferentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:25.0f];
        [_rightUnDifferentBtn setBackgroundColor:UIColorFromRGB(0xff9900)];
        [_rightUnDifferentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (_memoryGameType == XTMemoryGameTypeWithStroopEffect) {
            [_rightUnDifferentBtn setTitle:@"是" forState:UIControlStateNormal];
        } else {
            [_rightUnDifferentBtn setTitle:@"相同" forState:UIControlStateNormal];
        }
        _rightUnDifferentBtn.showsTouchWhenHighlighted = YES;
        [_rightUnDifferentBtn addTarget:self action:@selector(unDifferentAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightUnDifferentBtn;
}

- (void)addTimer {
    [self removeTimer];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)timerAction {
    if ([self.circleView_start superview]) {
        //游戏启动倒计时结束
        self.circleView_start.progress -= 0.02 / KMaxTime;
        if (self.circleView_start.progress <= 0.000001) {
            [self.circleView_start removeFromSuperview];
            [self removeTimer];
            
            NSLog(@"游戏启动完成");
            if (_memoryGameType == XTMemoryGameTypeWithStroopEffect) {
                [self startGame];
            } else {
                [self showGuideGameView];
            }
        }
    } else{
        //记忆训练选择结果倒计时结束
        self.circleView.progress -= 0.02 / _maxTimeSEC;
        if (self.circleView.progress <= 0.000001) {
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
                    [self resultAlert];
                } else {
                    [self startGame];
                }
            });
        }
    }
}

- (void)showGuideGameView {
    
    self.gameEnumView.levelModel = self.firstDataList[_currentLevelCount];
    
    self.gameMainView.hidden = NO;
    self.progressView.hidden = YES;
    self.titleButton.hidden = YES;
    self.circleView.hidden = YES;
    
    self.successLabel.hidden = YES;
    self.totalLabel.hidden = YES;
    
    self.leftDifferentBtn.hidden = YES;
    self.rightUnDifferentBtn.hidden = YES;
    [self.leftGameLight setImage:[UIImage imageNamed:@"answer_normal"] forState:UIControlStateNormal];
    [self.rightGameLight setImage:[UIImage imageNamed:@"answer_normal"] forState:UIControlStateNormal];

    self.gameMainView.alpha = 0.0;

    [UIView animateWithDuration:KDURATION delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.gameMainView.alpha = 1.0;
    } completion:^(BOOL finished) {
        //倒计时记忆训练展示
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KMaxTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self closeGameView];
        });
    }];
}

- (void)closeGameView {
    [UIView animateWithDuration:KDURATION delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.gameEnumView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeTimer];
        //添加定时器
        [self startGame];
    }];
}

- (void)startGame {
    if (_currentLevelCount == _maxLevelCount) {
        [self removeTimer];
        [self resultAlert];
        return;
    }
    self.currentLevelCount++;
    self.progressView.progress = self.currentLevelCount*1.0/self.maxLevelCount;
    self.progressView.maxNumber = self.maxLevelCount;

    [self showFormallyGameView];
}

- (void)showFormallyGameView {
    self.gameEnumView.levelModel = self.firstDataList[_currentLevelCount];

    self.gameMainView.hidden = NO;
    self.progressView.hidden = NO;
    self.successLabel.hidden = NO;
    self.totalLabel.hidden = NO;
    self.titleButton.hidden = NO;
    self.circleView.hidden = NO;
    self.leftDifferentBtn.hidden = NO;
    self.rightUnDifferentBtn.hidden = NO;
    [self.leftGameLight setImage:[UIImage imageNamed:@"answer_normal"] forState:UIControlStateNormal];
    [self.rightGameLight setImage:[UIImage imageNamed:@"answer_normal"] forState:UIControlStateNormal];
    
    self.gameEnumView.alpha = 0.0;
    self.circleView.progress = 1.0;

    [UIView animateWithDuration:KDURATION delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.gameEnumView.alpha = 1.0;
    } completion:^(BOOL finished) {
        //添加定时器
        [self addTimer];
    }];
}

- (void)removeTimer {
    [_timer invalidate];
    _timer = nil;
}

#pragma mark PrivateMethod
- (void)differentAction:(UIButton*)sender {
    [self removeTimer];
    
    if (_memoryGameType == XTMemoryGameTypeWithStroopEffect) {
        NSArray *arrays = [self getStroopEffectData];
        
        MemoryGameLevelModel *model = self.firstDataList[_currentLevelCount];
        
        BOOL isDifferent = YES;
        for (NSDictionary *object in arrays) {
            if ([object[@"word"] isEqualToString:[model.colorWords firstObject]] && CGColorEqualToColor([(UIColor*)object[@"color"] CGColor], [model.colors firstObject].CGColor)) {
                isDifferent = NO;
                break;
            }
        }
        
        if (!isDifferent) {
            [self errorForSelected];
        } else {
            [self successForSelected];
        }
        
    } else {
        if ([self.firstDataList[_currentLevelCount] isEqual:self.firstDataList[_currentLevelCount-1]]) {
            [self errorForSelected];
        } else {
            [self successForSelected];
        }
    }
}

- (void)unDifferentAction:(UIButton*)sender {
    [self removeTimer];
    
    if (_memoryGameType == XTMemoryGameTypeWithStroopEffect) {
        NSArray *arrays = [self getStroopEffectData];
        
        MemoryGameLevelModel *model = self.firstDataList[_currentLevelCount];
        
        BOOL isDifferent = YES;
        for (NSDictionary *object in arrays) {
            if ([object[@"word"] isEqualToString:[model.colorWords firstObject]] && CGColorEqualToColor([(UIColor*)object[@"color"] CGColor], [model.colors firstObject].CGColor)) {
                isDifferent = NO;
                break;
            }
        }
        
        if (isDifferent) {
            [self errorForSelected];
        } else {
            [self successForSelected];
        }
    } else {
        if (![self.firstDataList[_currentLevelCount] isEqual:self.firstDataList[_currentLevelCount-1]]) {
            [self errorForSelected];
        } else {
            [self successForSelected];
        }
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
            [self.view addSubview:self.circleView_start];
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

        LightAlertAction *confimAction = [LightAlertAction actionWithTitle:@"真可惜，再试试吧" andTitleColor:UIColorFromRGB(0xFFFFFF) andBackgroundColor:UIColorFromRGB(0xff9900) action:^{
            KStrongSelf(self);
            [self getMemoryData];
            self.gameMainView.hidden = YES;
            [self.view addSubview:self.circleView_start];
            [self addTimer];
        }];
        [alertViewController addAction:confimAction];
        
        [self presentViewController:alertViewController animated:YES completion:nil];
    }
}

- (void)successForSelected {

    _allUsedTimes += MAX(1, ceil(self.circleView.maxNumber - self.circleView.progress*self.circleView.maxNumber));
    
    [self.leftGameLight setImage:[UIImage imageNamed:@"answer_corrent"] forState:UIControlStateNormal];
    [self.rightGameLight setImage:[UIImage imageNamed:@"answer_normal"] forState:UIControlStateNormal];

    _successSelectedCount++;
    self.successLabel.text = [NSString stringWithFormat:@"%ld",_successSelectedCount];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startGame];
    });
}

- (void)errorForSelected {

    _allUsedTimes += MAX(1, ceil(self.circleView.maxNumber - self.circleView.progress*self.circleView.maxNumber));

    [self.leftGameLight setImage:[UIImage imageNamed:@"answer_normal"] forState:UIControlStateNormal];
    [self.rightGameLight setImage:[UIImage imageNamed:@"answer_error"] forState:UIControlStateNormal];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startGame];
    });
}

- (void)uploadLevelData:(NSDictionary*)parmers {
    
    if (_memoryGameType == XTMemoryGameTypeWithTrafficLight) {
        [TrafficLightPresenter setLevelParmers:parmers resultBlock:^(MemoryGameModel * _Nonnull memoryGameModel, BOOL isSuccess) {
            
        }];
    } else if (_memoryGameType == XTMemoryGameTypeWithQuickFlashing) {
        [QuickFlashingPresenter setLevelParmers:parmers resultBlock:^(MemoryGameModel * _Nonnull memoryGameModel, BOOL isSuccess) {
            
        }];
    } else if (_memoryGameType == XTMemoryGameTypeWithStroopEffect) {
        [StroopEffectPresenter setLevelParmers:parmers resultBlock:^(MemoryGameModel * _Nonnull memoryGameModel, BOOL isSuccess) {
            
        }];
    }
}

@end
