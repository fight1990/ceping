//
//  SelectStuTableViewCell.h
//  qiqiaoban
//
//  Created by mac on 2019/3/20.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StudentsInfo.h"

@interface SelectStuTableViewCell : UITableViewCell

@property (nonatomic,retain) UILabel *loginNameLabel;

@property (nonatomic,retain) UILabel *stuNameLabel;

@property (nonatomic,retain) StudentsInfo *model;

+(instancetype)cellForTableview:(UITableView*)tableview;

@end
