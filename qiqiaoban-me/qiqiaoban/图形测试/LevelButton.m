//
//  LevelButton.m
//  qiqiaoban
//
//  Created by mac on 2019/8/15.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "LevelButton.h"
#import "UIView+Frame.h"

@implementation LevelButton

-(void)creatSubviewsWithButtonWidth:(CGFloat)width;{
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self setBackgroundImage:[UIImage imageNamed:@"粉"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"灰"] forState:UIControlStateHighlighted];
    
    //确认尺寸.
    
    self.width = self.height = width;
    
    //创建锁定imageview
    UIImageView *lockImageView = [[UIImageView alloc] init];
    lockImageView.frame = CGRectMake(0, 0, 41, 41);
    lockImageView.image = [UIImage imageNamed:@"suo"];
    lockImageView.centerX = self.width * .5;
    lockImageView.centerY = self.height * .5;
    lockImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:lockImageView];
    self.lockedImageView = lockImageView;
    
    //创建显示关卡imageview . 暂时不需要去给定图片.
    UIImageView *bigNumLogo = [[UIImageView alloc] init];
    bigNumLogo.frame = CGRectMake(0, 0, 41, 41);
    bigNumLogo.centerX = self.width * .5;
    bigNumLogo.centerY = self.height * .5;
    [self addSubview:bigNumLogo];
    self.bigLevelNumImageView = bigNumLogo;
    
    //显示关卡的小数字
    UIImageView *numLogo = [[UIImageView alloc] init];
    numLogo.frame = CGRectMake(0, 0, 28, 28);
    numLogo.centerX = self.width * .5;
    numLogo.y = self.height * .2;
    [self addSubview:numLogo];
    self.levelNumImageView = numLogo;
    
    
    //显示是否完成的logo;
    UIImageView *logoImage = [[UIImageView alloc] init];
    logoImage.frame = CGRectMake(0, 0, 25, 25);
    logoImage.centerX = numLogo.centerX;
    logoImage.centerY = self.height * .73;
    self.logoImageView = logoImage;
    [self addSubview:logoImage];
    
    
    
    //用来显示时间的logo;
    UIImageView *timeBackImage = [[UIImageView alloc] init];
    timeBackImage.image = [UIImage imageNamed:@"timeback"];
    timeBackImage.frame = CGRectMake(0, 0, 70, 70);
    timeBackImage.x = -14;
    timeBackImage.y = -29;
    [self addSubview:timeBackImage];
    
    self.timeBackImageView = timeBackImage;
    
    //创建label 来描述 时间
    
    UILabel *labelFen = [[UILabel alloc] init];
    labelFen.textColor = [UIColor blackColor];
    [self addSubview:labelFen];
    self.scondLabel = labelFen;
    
    
    labelFen.text = @"15'";
    labelFen.width = labelFen.height = 30;
    labelFen.font = [UIFont systemFontOfSize:15];
    labelFen.textAlignment = NSTextAlignmentCenter;
    labelFen.x = -10;
    labelFen.y = 0;
    
    
    
    /*____________-----------*/
    UILabel *labelMiao = [[UILabel alloc] init];
    labelMiao.textColor = [UIColor blackColor];
    labelMiao.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labelMiao];
    self.miaoLabel = labelMiao;
    
    labelMiao.text = @"20";
    labelMiao.width = labelMiao.height = 30;
    labelMiao.font = [UIFont systemFontOfSize:15];
    labelMiao.x = 22;
    labelMiao.y = -18;
    
    
}

-(void)setLevelButtonType:(LevelButtonType)levelButtonType{
    _levelButtonType = levelButtonType;
    switch (_levelButtonType) {
            
        case LevelButtonTypeRecordGood:
            _lockedImageView.hidden = YES;
            _bigLevelNumImageView.hidden = YES;
            _levelNumImageView.hidden = NO;
            _logoImageView.hidden = NO;
            _timeBackImageView.hidden = NO;
            _scondLabel.hidden = NO;
            _miaoLabel.hidden = NO;
            self.enabled = YES;
            
            if (self.LevelButtonSepType == LevelButtonSepTypeWords) {
                [self setBackgroundImage:[UIImage imageNamed:@"yuanlan"] forState:UIControlStateNormal];
            }else{
                [self setBackgroundImage:[UIImage imageNamed:@"粉"] forState:UIControlStateNormal];
            }
            
            _logoImageView.image = [UIImage imageNamed:@"tankuang-yuansu"];
            break;
            
        case LevelButtonTypeRecordBad:
            _lockedImageView.hidden = YES;
            _bigLevelNumImageView.hidden = YES;
            _levelNumImageView.hidden = NO;
            _logoImageView.hidden = NO;
            _timeBackImageView.hidden = NO;
            _scondLabel.hidden = NO;
            _miaoLabel.hidden = NO;
            
            self.enabled = YES;
            
            if (self.LevelButtonSepType == LevelButtonSepTypeWords) {
                [self setBackgroundImage:[UIImage imageNamed:@"yuanlan"] forState:UIControlStateNormal];
            }else{
                [self setBackgroundImage:[UIImage imageNamed:@"粉"] forState:UIControlStateNormal];
            }
            
            _logoImageView.image = [UIImage imageNamed:@"yuansu2"];
            break;

            
        case LevelButtonTypeUnlock:
            _lockedImageView.hidden = YES;
            _bigLevelNumImageView.hidden = NO;
            _levelNumImageView.hidden = YES;
            _logoImageView.hidden = YES;
            _timeBackImageView.hidden = YES;
            _scondLabel.hidden = YES;
            _miaoLabel.hidden = YES;
            
            
            
            self.enabled = YES;
            
            if (self.LevelButtonSepType == LevelButtonSepTypeWords) {
                [self setBackgroundImage:[UIImage imageNamed:@"yuanlan"] forState:UIControlStateNormal];
            }else{
                [self setBackgroundImage:[UIImage imageNamed:@"粉"] forState:UIControlStateNormal];
            }
            
            break;
        case LevelButtonTypeLock:
            _lockedImageView.hidden = NO;
            _bigLevelNumImageView.hidden = YES;
            _levelNumImageView.hidden = YES;
            _logoImageView.hidden = YES;
            _timeBackImageView.hidden = YES;
            _scondLabel.hidden = YES;
            _miaoLabel.hidden = YES;
            
            
            self.enabled = NO;
            
            [self setBackgroundImage:[UIImage imageNamed:@"灰"] forState:UIControlStateNormal];
            break;

        default:
            break;
    }
    
    
}



-(void)setTag:(NSInteger)tag{
    
    [super setTag:tag];
    
    NSString *name = [NSString stringWithFormat:@"guanka%ld",(long)(tag + 1)];
    
    _levelNumImageView.image = [UIImage imageNamed:name];
    
    _bigLevelNumImageView.image = [UIImage imageNamed:name];
}


@end
