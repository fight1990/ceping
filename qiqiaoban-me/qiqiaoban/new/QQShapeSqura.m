//
//  QQShapeSqura.m
//  qiqiaoban
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "QQShapeSqura.h"


@interface QQShapeSqura ()

@property (nonatomic,assign) CGFloat squareWidth;

@property (nonatomic,assign) CGAffineTransform fanzhuanTransform;


@end

@implementation QQShapeSqura



//必须输入的两个参数.  通过这个方法 创建 色块的大小
-(instancetype)initWithType:(SquareType)type andWithWidth:(CGFloat)width{
    if (self = [super init]) {
        self.squareWidth = width;
        self.squareType = type;
        _isFanzhuan = 0;
        _inRightPlace = 0;
        _fanzhuanTransform = CGAffineTransformMakeScale(1, 1);
    }
    return self;
}

-(void)setShowImage:(UIImage *)showImage{
    _showImage = showImage;
    [self setImage:_showImage forState:UIControlStateNormal];
    [self setImage:_showImage forState:UIControlStateHighlighted];
}


-(void)setSquareType:(SquareType)squareType{
    _squareType = squareType;
    switch (squareType) {
        case SquareTypeSmalltriangle:
            self.frame = CGRectMake(0, 0, _squareWidth, _squareWidth);
            break;
            
        case SquareTypeMidTriangle:
            self.frame = CGRectMake(0, 0, _squareWidth * sqrt(2), _squareWidth * sqrt(2));
            break;
            
        case  SquareTypeBigtriangle:
            self.frame = CGRectMake(0, 0, _squareWidth * 2, _squareWidth * 2);
            break;
        case SquareTypeCorner:
            self.frame = CGRectMake(0, 0, _squareWidth, _squareWidth);
            break;
        case SquareTypeDiamond:
            self.frame = CGRectMake(0, 0, _squareWidth * 2, _squareWidth);
            break;
        default:
            break;
    }
}


-(void)setOriginRightCount:(CGFloat)count andFanzhuan:(BOOL)isFanzhuan{

    
    _rightCount = count;

//    self.transform = CGAffineTransformRotate(self.transform, (M_PI/12) * _rightCount);
    
    self.transform = CGAffineTransformMakeRotation((M_PI/12) * _rightCount);
    if(isFanzhuan&& !_isFanzhuan&&_squareType == SquareTypeDiamond){ //改变翻转为没有翻转时候
        self.transform = CGAffineTransformConcat(self.transform, CGAffineTransformMakeScale(-1,1));
    }
    
    _isFanzhuan = isFanzhuan;

}


@end
