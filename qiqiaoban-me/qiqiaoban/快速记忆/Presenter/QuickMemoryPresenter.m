//
//  QuickMemoryPresenter.m
//  qiqiaoban
//
//  Created by Wei on 2019/8/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QuickMemoryPresenter.h"
#import "INetworking.h"
#import "JSStudentInfoManager.h"
#import "JSEDefine.h"
#import "MacroDefinition.h"

@implementation QuickMemoryPresenter

+ (void)getLevelDatas:(void(^)(NSArray<QuickMemoryModel*> *datas,BOOL isSuccess))resultBlock{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"stu_name"] = [JSStudentInfoManager manager].basicInfo.stuName;
    dic[@"password"] = [JSStudentInfoManager manager].basicInfo.passWord;

    [[INetworking shareNet] GET:@"http://114.55.90.93:8081/web/app/fastmemorylevelrecordList.json" withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingMutableLeaves error:nil];
        NSMutableArray *listsInfo = [[NSMutableArray alloc] init];
        NSDictionary *list1 = [responseObject[@"list1"] firstObject];
        if (!KISNullDict(list1)) {
            [listsInfo addObject:[[QuickMemoryModel alloc] initWithQuickMemoryObject:list1]];
        }
        NSDictionary *list2 = [responseObject[@"list2"] firstObject];
        if (!KISNullDict(list2) && [listsInfo count] >= 1) {
            [listsInfo addObject:[[QuickMemoryModel alloc] initWithQuickMemoryObject:list2]];
        }
        NSDictionary *list3 = [responseObject[@"list3"] firstObject];
        if (!KISNullDict(list3) && [listsInfo count] >= 2) {
            [listsInfo addObject:[[QuickMemoryModel alloc] initWithQuickMemoryObject:list3]];
        }
        NSDictionary *list4 = [responseObject[@"list4"] firstObject];
        if (!KISNullDict(list4) && [listsInfo count] >= 3) {
            [listsInfo addObject:[[QuickMemoryModel alloc] initWithQuickMemoryObject:list4]];
        }
        NSDictionary *list5 = [responseObject[@"list5"] firstObject];
        if (!KISNullDict(list5) && [listsInfo count] >= 4) {
            [listsInfo addObject:[[QuickMemoryModel alloc] initWithQuickMemoryObject:list5]];
        }
        NSDictionary *list6 = [responseObject[@"list6"] firstObject];
        if (!KISNullDict(list6) && [listsInfo count] >= 5) {
            [listsInfo addObject:[[QuickMemoryModel alloc] initWithQuickMemoryObject:list6]];
        }
        NSDictionary *list7 = [responseObject[@"list7"] firstObject];
        if (!KISNullDict(list7) && [listsInfo count] >= 6) {
            [listsInfo addObject:[[QuickMemoryModel alloc] initWithQuickMemoryObject:list7]];
        }
        NSDictionary *list8 = [responseObject[@"list8"] firstObject];
        if (!KISNullDict(list8) && [listsInfo count] >= 7) {
            [listsInfo addObject:[[QuickMemoryModel alloc] initWithQuickMemoryObject:list8]];
        }
        NSDictionary *list9 = [responseObject[@"list9"] firstObject];
        if (!KISNullDict(list9) && [listsInfo count] >= 8) {
            [listsInfo addObject:[[QuickMemoryModel alloc] initWithQuickMemoryObject:list9]];
        }
        NSDictionary *list10 = [responseObject[@"list10"] firstObject];
        if (!KISNullDict(list10) && [listsInfo count] >= 9) {
            [listsInfo addObject:[[QuickMemoryModel alloc] initWithQuickMemoryObject:list10]];
        }
        NSDictionary *list11 = [responseObject[@"list11"] firstObject];
        if (!KISNullDict(list11) && [listsInfo count] >= 10) {
            [listsInfo addObject:[[QuickMemoryModel alloc] initWithQuickMemoryObject:list11]];
        }
        NSDictionary *list12 = [responseObject[@"list12"] firstObject];
        if (!KISNullDict(list12) && [listsInfo count] >= 11) {
            [listsInfo addObject:[[QuickMemoryModel alloc] initWithQuickMemoryObject:list12]];
        }
        NSDictionary *list13 = [responseObject[@"list13"] firstObject];
        if (!KISNullDict(list13) && [listsInfo count] >= 12) {
            [listsInfo addObject:[[QuickMemoryModel alloc] initWithQuickMemoryObject:list13]];
        }
        NSDictionary *list14 = [responseObject[@"list14"] firstObject];
        if (!KISNullDict(list14) && [listsInfo count] >= 13) {
            [listsInfo addObject:[[QuickMemoryModel alloc] initWithQuickMemoryObject:list14]];
        }
        NSDictionary *list15 = [responseObject[@"list15"] firstObject];
        if (!KISNullDict(list15) && [listsInfo count] >= 14) {
            [listsInfo addObject:[[QuickMemoryModel alloc] initWithQuickMemoryObject:list15]];
        }
        NSDictionary *list16 = [responseObject[@"list16"] firstObject];
        if (!KISNullDict(list16) && [listsInfo count] >= 15) {
            [listsInfo addObject:[[QuickMemoryModel alloc] initWithQuickMemoryObject:list16]];
        }
        NSDictionary *list17 = [responseObject[@"list17"] firstObject];
        if (!KISNullDict(list17) && [listsInfo count] >= 16) {
            [listsInfo addObject:[[QuickMemoryModel alloc] initWithQuickMemoryObject:list17]];
        }
        NSDictionary *list18 = [responseObject[@"list18"] firstObject];
        if (!KISNullDict(list18) && [listsInfo count] >= 17) {
            [listsInfo addObject:[[QuickMemoryModel alloc] initWithQuickMemoryObject:list18]];
        }
        NSDictionary *list19 = [responseObject[@"list19"] firstObject];
        if (!KISNullDict(list19) && [listsInfo count] >= 18) {
            [listsInfo addObject:[[QuickMemoryModel alloc] initWithQuickMemoryObject:list19]];
        }
        NSDictionary *list20 = [responseObject[@"list20"] firstObject];
        if (!KISNullDict(list20) && [listsInfo count] >= 19) {
            [listsInfo addObject:[[QuickMemoryModel alloc] initWithQuickMemoryObject:list20]];
        }
        NSDictionary *list21 = [responseObject[@"list21"] firstObject];
        if (!KISNullDict(list21) && [listsInfo count] >= 20) {
            [listsInfo addObject:[[QuickMemoryModel alloc] initWithQuickMemoryObject:list21]];
        }
        
        if (resultBlock) {
            resultBlock(listsInfo, isSuccess);
        }
    }];
}

+ (void)setLevelParmers:(NSDictionary*)parmers resultBlock:(void(^)(QuickMemoryModel *QuickMemoryModel,BOOL isSuccess))resultBlock {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parmers];
    dic[@"password"] = [JSStudentInfoManager manager].basicInfo.passWord;
    dic[@"stu_name"] = [JSStudentInfoManager manager].basicInfo.stuName;
    dic[@"age"] = [JSStudentInfoManager manager].basicInfo.birthday;
    dic[@"center"] = [JSStudentInfoManager manager].basicInfo.centerName;
    
    [[INetworking shareNet] GET:@"http://114.55.90.93:8081/web/app/savefastmemoryrecords.json" withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingMutableLeaves error:nil];
        QuickMemoryModel *quickMemoryModel = [[QuickMemoryModel alloc] initWithQuickMemoryObject:responseObject];
        
        if (resultBlock) {
            resultBlock(quickMemoryModel,isSuccess);
        }
    }];
}
@end
