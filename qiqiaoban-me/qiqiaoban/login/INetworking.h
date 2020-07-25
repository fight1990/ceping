//
//  INetworking.h
//  iTestAFNetworking
//
//  Created by administrator on 15/11/23.
//  Copyright © 2015年 administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

#define INetwrokingManager [INetworking shareNet]

#define SaveStr(value)\
({id tmp;\
if ([value isKindOfClass:[NSNull class]])\
tmp = nil;\
else\
 tmp = value;\
tmp;\
})\


//登录账号信息
extern NSString * const loginUrlStr;

//http://114.55.90.93:8081/web/app/saveQqbrecords.json?level=1&name=dujiaoshou&number=213&login_name=0000929fp1&used_times=200.12&stu_score=80 保存测试结果. + center

//http://114.55.90.93:8081/web/app/studentQqb.json?login_name=260061fp1 查询学生的信息




@interface INetworking : NSObject

@property (nonatomic,copy) NSString *ipstr;

/**
 *  是否存在数据网络;
 */
@property (nonatomic,readonly,assign) BOOL isNetworking;

//下载失败的block

@property (nonatomic,copy) void(^errorDolowdToDo)();

+(INetworking*)shareNet;

-(void)GET:(NSString*)URLString withParmers:(NSDictionary *)parmers do:(void(^)(id returnObject,BOOL isSuccess))myblok;

-(void)POST:(NSString*)object parameters:(id)parameters do:(void(^)(id returnObject,BOOL isSuccess))myblok;

@end

