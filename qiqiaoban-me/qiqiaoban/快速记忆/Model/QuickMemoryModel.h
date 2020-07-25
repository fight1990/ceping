//
//  QuickMemoryModel.h
//  qiqiaoban
//
//  Created by Wei on 2019/8/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QuickMemoryModel : NSObject

@property (nonatomic, assign) BOOL unLock;

///交通灯
@property (nonatomic, strong) NSString *age;
@property (nonatomic, strong) NSString *agegroup;
@property (nonatomic, strong) NSString *avgtime;
@property (nonatomic, strong) NSString *center;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *firstrownum;
@property (nonatomic, strong) NSString *gmid;
@property (nonatomic, strong) NSString *mainId;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *login_name;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *pagesize;
@property (nonatomic, strong) NSString *stu_name;
@property (nonatomic, strong) NSString *stu_score;
@property (nonatomic, strong) NSString *totlenumber;
@property (nonatomic, strong) NSString *used_times;


- (instancetype)initWithQuickMemoryObject:(NSDictionary*)object;

@end

NS_ASSUME_NONNULL_END
