//
//  StudentsInfo.h
//  qiqiaoban
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentsInfo : NSObject

@property (nonatomic,copy) NSString *loginName;

@property (nonatomic,copy) NSString *stuName;

@property (nonatomic,copy) NSString *passWord;

@property (nonatomic,copy) NSString *centerName;

@property (nonatomic,copy) NSString *birthday;

@property (nonatomic,assign) long stuID;


@end
