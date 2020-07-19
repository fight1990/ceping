//
//  JSStudentInfoManager.m
//  qiqiaoban
//
//  Created by mac on 2019/3/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "JSStudentInfoManager.h"

@interface JSStudentInfoManager ()


@property (nonatomic,assign) BOOL isSetAge;

@end

@implementation JSStudentInfoManager

static JSStudentInfoManager *manager = nil;

+ (instancetype)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}


-(BOOL)isSetAge{
    return ([self.basicInfo.birthday isKindOfClass:[NSString  class]] && self.basicInfo.birthday.length);
}

@end
