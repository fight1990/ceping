//
//  QQShapeSqura.h
//  qiqiaoban
//
//  Created by mac on 2019/3/13.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "OBShapedButton.h"

#import "ShapeModel.h"

//这里是可用于点击的按钮色块

typedef NS_ENUM(NSUInteger, SquareType) {
    SquareTypeSmalltriangle = 1,//小三角形
    SquareTypeMidTriangle = 2,  //中等大小三角形
    SquareTypeBigtriangle = 3,  //大三角形.
    SquareTypeCorner = 4,       //正方形
    SquareTypeDiamond = 5       //平行四边形.
};

@interface QQShapeSqura : OBShapedButton

@property (nonatomic,retain) ShapeModel *model;


//用于判断。 是否已经被对应过。

@property (nonatomic,assign) BOOL isSurePlace;

//图形翻转次数.
@property (nonatomic,assign) NSInteger rightCount;

//是否翻转。
@property (nonatomic,assign) BOOL isFanzhuan;

//图形的类型
@property (nonatomic,assign) SquareType squareType;

//图形的显示图像
@property (nonatomic,retain) UIImage *showImage;

@property (nonatomic,assign) BOOL inRightPlace;

//初始化方法.
-(instancetype)initWithType:(SquareType)type andWithWidth:(CGFloat)width;


-(void)setOriginRightCount:(CGFloat)count andFanzhuan:(BOOL)isFanzhuan;

@end
