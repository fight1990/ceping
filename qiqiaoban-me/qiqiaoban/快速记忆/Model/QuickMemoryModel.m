//
//  QuickMemoryModel.m
//  qiqiaoban
//
//  Created by Wei on 2019/8/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QuickMemoryModel.h"
#import "MacroDefinition.h"

@implementation QuickMemoryModel

- (instancetype)initWithQuickMemoryObject:(NSDictionary*)object {
    self = [super init];
    if (self) {
        self.age = [object objectForKey:@"age"];
        self.agegroup = [object objectForKey:@"agegroup"];
        self.avgtime = [object objectForKey:@"avgtime"];
        self.center = [object objectForKey:@"center"];
        self.create_time = [object objectForKey:@"create_time"];
        self.firstrownum = [object objectForKey:@"firstrownum"];
        self.gmid = [object objectForKey:@"gmid"];
        self.mainId = [object objectForKey:@"id"];
        self.level = [object objectForKey:@"level"];
        self.login_name = [object objectForKey:@"login_name"];
        self.name = [object objectForKey:@"name"];
        self.number = [object objectForKey:@"number"];
        self.pagesize = [object objectForKey:@"pagesize"];
        self.stu_name = [object objectForKey:@"stu_name"];
        self.stu_score = KISNullObject([object objectForKey:@"stu_score"])?@"0":[object objectForKey:@"stu_score"];
        self.totlenumber = [object objectForKey:@"totlenumber"];
        self.used_times = [object objectForKey:@"used_times"];
        
        self.unLock = YES;

    }
    return self;
}

@end
