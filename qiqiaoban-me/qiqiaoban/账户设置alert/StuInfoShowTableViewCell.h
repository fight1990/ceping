//
//  StuInfoShowTableViewCell.h
//  qiqiaoban
//
//  Created by mac on 2019/3/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "StudentsInfo.h"

@interface StuInfoShowTableViewCell : UITableViewCell

@property (nonatomic,retain) UILabel *titleLabel;

@property (nonatomic,retain) UILabel *valueLabel;

@property (nonatomic,retain) StudentsInfo *model;

@property (nonatomic,assign) CGFloat currentCount;

+(instancetype)cellForTableview:(UITableView*)tableview;

-(void)showForModel:(StudentsInfo *)model andCount:(CGFloat)currentCount andCellWidth:(CGFloat)width;

@end
