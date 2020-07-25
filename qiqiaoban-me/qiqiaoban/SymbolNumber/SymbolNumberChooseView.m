//
//  SymbolNumberChooseView.m
//  qiqiaoban
//
//  Created by mac on 2019/8/23.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "SymbolNumberChooseView.h"

@interface SymbolNumberChooseView()

//@property (strong, nonatomic) UIImageView *clockImage;
//@property (strong, nonatomic) UIImageView *passImage;
//
//@property (strong, nonatomic) UIImageView *unpassImage;
//
//@property (strong, nonatomic) UIImageView *starImage;
//@property (strong, nonatomic) UIImageView *labelImage;
//
//@property (strong, nonatomic) UILabel *timeLabel;
//@property (strong, nonatomic) UILabel *rightLabel;
//@property (strong, nonatomic) UILabel *passLabel;

@end

@implementation SymbolNumberChooseView

// 1.重写initWithFrame:方法，创建子控件并添加到自己上面
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        _clockImage =[[UIImageView alloc]init];
        [self addSubview:_clockImage];
        
        _passImage =[[UIImageView alloc]init];
        [self addSubview:_passImage];
        
        _unpassImage =[[UIImageView alloc]init];
        [self addSubview:_unpassImage];
        
        _starImage =[[UIImageView alloc]init];
        [self addSubview:_starImage];
        
        _labelImage =[[UIImageView alloc]init];
        [self addSubview:_labelImage];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:_timeLabel];
        
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.textColor = [UIColor blackColor];
        _rightLabel.font = [UIFont systemFontOfSize:18];
        [self addSubview:_rightLabel];
        
        
    }
    return self;
}

// 2.重写layoutSubviews，给自己内部子控件设置frame
- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.frame.size;
    _clockImage.frame  =CGRectMake(15, 25, size.width-30, size.height-30);
    
    _passImage.frame =CGRectMake(40, 40, 40, 40);
    _passImage.center =CGPointMake(size.width/2, 60);
    
    _unpassImage.frame =CGRectMake(40, 40, 40, 40);
    _unpassImage.center =CGPointMake(size.width/2, 80);
    
    _starImage.frame =CGRectMake(40, 40, 30, 30);
    _starImage.center =CGPointMake(size.width/2, 105);
    
    _labelImage.frame =CGRectMake(0, -15, 80, 80);

    _timeLabel.frame = CGRectMake(3, 15, 40, 40);
    
    _rightLabel.frame =CGRectMake(37, -5, 40, 40);
}

@end
