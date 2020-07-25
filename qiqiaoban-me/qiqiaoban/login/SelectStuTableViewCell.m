//
//  SelectStuTableViewCell.m
//  qiqiaoban
//
//  Created by mac on 2019/3/20.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "SelectStuTableViewCell.h"
#import "JSEDefine.h"

@implementation SelectStuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _loginNameLabel = [[UILabel alloc] init];
        _loginNameLabel.textColor = JSLikeBlackColor;
        _loginNameLabel.font = JSFont(24);
        _loginNameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_loginNameLabel];
        
        
        _stuNameLabel = [[UILabel alloc] init];
        _stuNameLabel.textColor = JSLikeBlackColor;
        _stuNameLabel.font = JSFont(24);
        _stuNameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_stuNameLabel];
        
    }
    return self;
}



+(instancetype)cellForTableview:(UITableView*)tableview{
    NSString *const identif = @"SelectStuTableViewCell";
    SelectStuTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:identif];
    if (!cell) {
        cell = [[SelectStuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identif];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return cell;
}

-(void)setModel:(StudentsInfo *)model{
    _model = model;
    
    self.loginNameLabel.text = model.loginName;
    
    self.loginNameLabel.frame = CGRectMake(30, 0, 250, 75);
    
    
    self.stuNameLabel.text = model.stuName;
    
    self.stuNameLabel.frame = CGRectMake(280, 0, 120, 75);
}


@end
