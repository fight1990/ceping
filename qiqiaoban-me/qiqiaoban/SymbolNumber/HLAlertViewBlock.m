//
//  HLAlertViewBlock.m
//  HLAlertView
//
//  Created by 郝靓 on 2018/6/5.
//  Copyright © 2018年 郝靓. All rights reserved.
//

#import "HLAlertViewBlock.h"
#import "UIView+HLExtension.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface HLAlertViewBlock()

/** 弹窗主内容view */
@property (nonatomic,strong) UIView   *contentView;

/** 剩余秒数 */
@property (nonatomic,copy)   NSString *remainingSeconds;

/** 结果 */
@property (nonatomic,copy)   NSString *result;

@property (nonatomic,assign) float starFloat;

/** 确认按钮 */
@property (nonatomic,copy)   UIButton *sureButton;

@end


@implementation HLAlertViewBlock

- (instancetype)initWithRemainingSeconds:(NSInteger)remainingSeconds
                             rightAmount:(NSInteger)rightAmount
                               queAmount:(NSInteger)queAmount
                                   block:(void (^)(NSInteger))block
{
    if (self = [super init]) {

        self.remainingSeconds =[NSString stringWithFormat:@"剩余 %ld 秒",remainingSeconds];
        self.result =[NSString stringWithFormat:@"共答对 %ld 个，总共 %ld 个",rightAmount,queAmount];
        float right =rightAmount;
        self.starFloat = right/queAmount ;
        
        self.buttonBlock = block;
        [self sutUpView];
    }
    return self;
}

- (void)sutUpView{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.85];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
    
    //------- 弹窗主内容 -------//
    self.contentView = [[UIView alloc]init];
    self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH/2+100, 380);
    self.contentView.center = self.center;
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 20;
    [self addSubview:self.contentView];
    
    UIImageView *starImageView =[[UIImageView alloc]initWithFrame:CGRectMake(50, 10, KScreenWidth/2, 150)];
    if (self.starFloat ==1.0) {
        starImageView.image =[UIImage imageNamed:@"3-3"];
    }else if (self.starFloat <0.8){
        starImageView.image =[UIImage imageNamed:@"4-3"];
    }else{
        starImageView.image =[UIImage imageNamed:@"2-3"];
    }
    NSLog(@"%.2f", self.starFloat);
//    starImageView.image =[UIImage imageNamed:@"1-3"];
    [self.contentView addSubview:starImageView];
    
    UIButton *backBtn =[UIButton buttonWithType:0];
    backBtn.frame =CGRectMake(KScreenWidth/2+50, 10, 40, 40);
    backBtn.backgroundColor =[UIColor clearColor];
    [backBtn setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(causeBtn:) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:backBtn];
    
    UILabel *remainingSecondsLab =[[UILabel alloc]initWithFrame:CGRectMake(50, 170, KScreenWidth/2, 50)];
    remainingSecondsLab.text =self.remainingSeconds;
    remainingSecondsLab.font =[UIFont systemFontOfSize:35];
    remainingSecondsLab.textAlignment =NSTextAlignmentCenter;
    [self.contentView addSubview:remainingSecondsLab];
    
    UILabel *resultLab =[[UILabel alloc]initWithFrame:CGRectMake(50, 240, KScreenWidth/2, 50)];
    resultLab.text =self.result;
    resultLab.font =[UIFont systemFontOfSize:30];
    resultLab.textAlignment =NSTextAlignmentCenter;
    [self.contentView addSubview:resultLab];
    
    UIButton *resultBtn =[UIButton buttonWithType:0];
    resultBtn.frame =CGRectMake(70, 310, KScreenWidth/2-40, 50);
    resultBtn.layer.cornerRadius =25;
    resultBtn.backgroundColor =[UIColor blueColor];
    if(self.starFloat <= 0.8){
        [resultBtn setTitle:@"真可惜，再试试吧" forState:UIControlStateNormal];
    }else{
        [resultBtn setTitle:@"下一关" forState:UIControlStateNormal];
    }
    [resultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resultBtn.titleLabel.font =[UIFont systemFontOfSize:30];
    [resultBtn addTarget:self action:@selector(processSure:) forControlEvents:UIControlEventTouchDown];
    [self.contentView addSubview:resultBtn];
    
    
}

- (void)show{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

-(void)back:(UIButton *)sender{
     [self dismiss];
}

- (void)processSure:(UIButton *)sender{
    if (self.buttonBlock) {
        if([sender.titleLabel.text isEqualToString:@"下一关"]){
            self.buttonBlock(AlertBlockSureButtonClick);
        }else{
            self.buttonBlock(AlertBlockAgainButtonClick);
        }  
    }
    [self dismiss];
}

- (void)causeBtn:(UIButton *)sender{
    if (self.buttonBlock) {
        self.buttonBlock(AlertBlockCauseButtonClick);
    }
    [self dismiss];
}

#pragma mark - 移除此弹窗
/** 移除此弹窗 */
- (void)dismiss{
    [self removeFromSuperview];
}
@end
