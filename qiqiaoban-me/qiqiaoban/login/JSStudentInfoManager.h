//
//  JSStudentInfoManager.h
//  qiqiaoban
//
//  Created by mac on 2019/3/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StudentsInfo.h"

@interface JSStudentInfoManager : NSObject

@property (nonatomic,retain) StudentsInfo *basicInfo;

@property (nonatomic,assign,readonly) BOOL isSetAge;

//拼图是否完成
@property (nonatomic,assign) BOOL isOverToday;

//数独是否完成.
@property (nonatomic,assign) BOOL isOverShudu;

+(instancetype)manager;


@end
