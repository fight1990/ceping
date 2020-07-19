//
//  ShapeModel.h
//  qiqiaoban
//
//  Created by mac on 2019/3/22.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ShapeModel : NSObject

@property (nonatomic,assign) NSInteger count;

@property (nonatomic,assign) BOOL isFanzhuan;

@property (nonatomic,retain) NSString *xSize;

@property (nonatomic,retain) NSString *ySize;

@property (nonatomic,retain) NSString *shapeID;


@end
