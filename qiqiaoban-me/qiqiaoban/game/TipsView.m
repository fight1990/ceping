//
//  TipsView.m
//  qiqiaoban
//
//  Created by mac on 2019/3/22.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "TipsView.h"

#import "JSEDefine.h"

#import "UIView+Frame.h"

#import "UIImage+Render.h"

@interface TipsView()


@end

@implementation TipsView

-(instancetype)initWithModel:(QQBModel *)model{
    if (self = [super init]) {
        self.model = model;
        self.containSquraArray = [NSMutableArray array];
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    
    self.bounds = CGRectMake(0, 0,JSFrame.size.width , JSFrame.size.height);
    
    NSString *typeNumberStr = [self.model.type substringFromIndex:3];
    
    NSInteger typeNum = [typeNumberStr integerValue];
    
    [self setSomeViewWithType:typeNum];
    
}

-(NSInteger)currentTypeNum{
    NSString *typeNumberStr = [self.model.type substringFromIndex:3];
    NSInteger typeNum = [typeNumberStr integerValue];
    return typeNum;
}

-(void)setSomeViewWithType:(NSInteger)typeNumber{

    
    //创建所有的view
    
    //在便利数据的同时， 检测 最大最小的point; 又由于这里是
    
    CGFloat maxX = 0;
    CGFloat maxY = 0;
    CGFloat minX = 0;
    CGFloat minY = 0;
    
    for (ShapeModel *model in self.model.ShapeModelArray) {
        QQShapeSqura  *squra;
        if ([model.shapeID isEqualToString:@"1"]||[model.shapeID isEqualToString:@"2"]) {
            squra = [[QQShapeSqura alloc] initWithType:SquareTypeSmalltriangle andWithWidth:80];
        }else if ([model.shapeID isEqualToString:@"3"]||[model.shapeID isEqualToString:@"4"]){
            
            squra = [[QQShapeSqura alloc] initWithType:SquareTypeBigtriangle andWithWidth:80];
        }else if ([model.shapeID isEqualToString:@"5"]){
            
            squra = [[QQShapeSqura alloc] initWithType:SquareTypeMidTriangle andWithWidth:80];
        }else if ([model.shapeID isEqualToString:@"6"]){
            
            squra = [[QQShapeSqura alloc] initWithType:SquareTypeDiamond andWithWidth:80];
        }else{
            squra = [[QQShapeSqura alloc] initWithType:SquareTypeCorner andWithWidth:80];
        }
        [self addSubview:squra];
        
        
        squra.centerX = model.xSize.floatValue;
        squra.centerY = model.ySize.floatValue;
        squra.model = model;
        
        if (maxX < squra.centerX) {
            maxX = squra.centerX;
        }
        if (maxY < squra.centerY) {
            maxY = squra.centerY;
        }
        if (minX > squra.centerX) {
            minX = squra.centerX;
        }
        
        if (minY > squra.centerX) {
            minY = squra.centerX;
        }
        
        CGPoint minP = CGPointMake(minX - 80, minY - 80);
        CGPoint maxP = CGPointMake(maxX + 80, maxY + 80);
        SQAre area;
        area.MaxPoint = maxP;
        area.MinPoint = minP;
        self.showAre = area;
        
        
        [self.containSquraArray addObject:squra];
    }
    //根据提示的不同对每个view进行修改.
    
    if (typeNumber == 1) {
        //阴影加线框.
        for (QQShapeSqura *shape in self.containSquraArray) {
            if ([shape.model.shapeID isEqualToString:@"1"]||[shape.model.shapeID isEqualToString:@"2"]) {
                //小三角 4
                [shape setShowImage:[UIImage imageNamed:@"4-1"]];
            }else if ([shape.model.shapeID isEqualToString:@"3"]||[shape.model.shapeID isEqualToString:@"4"]){
                //大三角 1
                [shape setShowImage:[UIImage imageNamed:@"1-1"]];
                
            }else if ([shape.model.shapeID isEqualToString:@"5"]){
                //中三角 2
                [shape setShowImage:[UIImage imageNamed:@"2-1"]];
                
            }else if ([shape.model.shapeID isEqualToString:@"6"]){
                //平行菱形 6
                [shape setShowImage:[UIImage imageNamed:@"6-1"]];
                
            }else{
                //正方形 3
                [shape setShowImage:[UIImage imageNamed:@"3-1"]];
            }
        }

        
    }else if(typeNumber == 2){
        //只显示阴影
        
        for (QQShapeSqura *shape in self.containSquraArray) {
            if ([shape.model.shapeID isEqualToString:@"1"]||[shape.model.shapeID isEqualToString:@"2"]) {
                //小三角 4
                [shape setShowImage:[UIImage imageNamed:@"4-2"]];
            }else if ([shape.model.shapeID isEqualToString:@"3"]||[shape.model.shapeID isEqualToString:@"4"]){
                //大三角 1
                [shape setShowImage:[UIImage imageNamed:@"1-2"]];
                
            }else if ([shape.model.shapeID isEqualToString:@"5"]){
                //中三角 2
                [shape setShowImage:[UIImage imageNamed:@"2-2"]];
                
            }else if ([shape.model.shapeID isEqualToString:@"6"]){
                //平行菱形 6
                [shape setShowImage:[UIImage imageNamed:@"6-2"]];
                
            }else{
                //正方形 3
                [shape setShowImage:[UIImage imageNamed:@"3-2"]];
            }
        }
    
    }else if(typeNumber == 3){
        //左上角上显示小阴影
        
        for (QQShapeSqura *shape in self.containSquraArray) {
            if ([shape.model.shapeID isEqualToString:@"1"]||[shape.model.shapeID isEqualToString:@"2"]) {
                //小三角 4
                [shape setShowImage:[UIImage imageNamed:@"4-2"]];
            }else if ([shape.model.shapeID isEqualToString:@"3"]||[shape.model.shapeID isEqualToString:@"4"]){
                //大三角 1
                [shape setShowImage:[UIImage imageNamed:@"1-2"]];
                
            }else if ([shape.model.shapeID isEqualToString:@"5"]){
                //中三角 2
                [shape setShowImage:[UIImage imageNamed:@"2-2"]];
                
            }else if ([shape.model.shapeID isEqualToString:@"6"]){
                //平行菱形 6
                [shape setShowImage:[UIImage imageNamed:@"6-2"]];
                
            }else{
                //正方形 3
                [shape setShowImage:[UIImage imageNamed:@"3-2"]];
            }
        }
        
    }else if(typeNumber == 4){
        //显示一个色块
        for (QQShapeSqura *shape in self.containSquraArray) {
            if ([shape.model.shapeID isEqualToString:@"1"]||[shape.model.shapeID isEqualToString:@"2"]) {
                //小三角 4
                [shape setShowImage:[UIImage imageNamed:@"4-2"]];
            }else if ([shape.model.shapeID isEqualToString:@"3"]||[shape.model.shapeID isEqualToString:@"4"]){
                //大三角 1
                [shape setShowImage:[UIImage imageNamed:@"1-2"]];
                
            }else if ([shape.model.shapeID isEqualToString:@"5"]){
                //中三角 2
                [shape setShowImage:[UIImage imageNamed:@"2-2"]];
                
            }else if ([shape.model.shapeID isEqualToString:@"6"]){
                //平行菱形 6
                [shape setShowImage:[UIImage imageNamed:@"6-2"]];
                
            }else{
                //正方形 3
                [shape setShowImage:[UIImage imageNamed:@"3-2"]];
            }
        }
        
    }else if(typeNumber == 5){
        //显示两个色块
        for (QQShapeSqura *shape in self.containSquraArray) {
            if ([shape.model.shapeID isEqualToString:@"1"]||[shape.model.shapeID isEqualToString:@"2"]) {
                //小三角 4
                [shape setShowImage:[UIImage imageNamed:@"4-2"]];
            }else if ([shape.model.shapeID isEqualToString:@"3"]||[shape.model.shapeID isEqualToString:@"4"]){
                //大三角 1
                [shape setShowImage:[UIImage imageNamed:@"1-2"]];
                
            }else if ([shape.model.shapeID isEqualToString:@"5"]){
                //中三角 2
                [shape setShowImage:[UIImage imageNamed:@"2-2"]];
                
            }else if ([shape.model.shapeID isEqualToString:@"6"]){
                //平行菱形 6
                [shape setShowImage:[UIImage imageNamed:@"6-2"]];
                
            }else{
                //正方形 3
                [shape setShowImage:[UIImage imageNamed:@"3-2"]];
            }
        }
        
    }else if(typeNumber == 6){
        //显示三个色块.
        for (QQShapeSqura *shape in self.containSquraArray) {
            if ([shape.model.shapeID isEqualToString:@"1"]||[shape.model.shapeID isEqualToString:@"2"]) {
                //小三角 4
                [shape setShowImage:[UIImage imageNamed:@"4-2"]];
            }else if ([shape.model.shapeID isEqualToString:@"3"]||[shape.model.shapeID isEqualToString:@"4"]){
                //大三角 1
                [shape setShowImage:[UIImage imageNamed:@"1-2"]];
                
            }else if ([shape.model.shapeID isEqualToString:@"5"]){
                //中三角 2
                [shape setShowImage:[UIImage imageNamed:@"2-2"]];
                
            }else if ([shape.model.shapeID isEqualToString:@"6"]){
                //平行菱形 6
                [shape setShowImage:[UIImage imageNamed:@"6-2"]];
                
            }else{
                //正方形 3
                [shape setShowImage:[UIImage imageNamed:@"3-2"]];
            }
        }
        
            
//            shape.rightCount = shape.model.count;
//            shape.isFanzhuan = shape.model.isFanzhuan;
            
            
    }else{
    
        
        
    
    
    }
    
    
    //完成初始位置的确定
    for (QQShapeSqura *shape in self.containSquraArray) {
        [shape setOriginRightCount:shape.model.count andFanzhuan:shape.model.isFanzhuan];
    }
    
}

-(void)showAnswer{
    //显示答案.
    for (QQShapeSqura *shape in self.containSquraArray) {
        if ([shape.model.shapeID isEqualToString:@"1"]) {
            //小三角 4
            [shape setShowImage:[UIImage imageNamed:@"4"]];
        }else if ([shape.model.shapeID isEqualToString:@"2"]){
            //小三角
            [shape setShowImage:[UIImage imageNamed:@"5"]];
            
        }else if ([shape.model.shapeID isEqualToString:@"4"]){
            //大三角 2
            [shape setShowImage:[UIImage imageNamed:@"7"]];
            
        }else if ([shape.model.shapeID isEqualToString:@"3"]){
            //大三角 1
            [shape setShowImage:[UIImage imageNamed:@"1"]];
            
        }else if ([shape.model.shapeID isEqualToString:@"5"]){
            //中三角 2
            [shape setShowImage:[UIImage imageNamed:@"2"]];
            
        }else if ([shape.model.shapeID isEqualToString:@"6"]){
            //平行菱形 6
            [shape setShowImage:[UIImage imageNamed:@"6"]];
            
        }else{
            //正方形 3
            [shape setShowImage:[UIImage imageNamed:@"3"]];
        }
    }
    
    
    //            shape.rightCount = shape.model.count;
    //            shape.isFanzhuan = shape.model.isFanzhuan;


}

@end
