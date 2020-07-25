
//
//  StuInfoShowTableViewCell.m
//  qiqiaoban
//
//  Created by mac on 2019/3/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "StuInfoShowTableViewCell.h"

#import "JSEDefine.h"

@implementation StuInfoShowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = JSLikeBlackColor;
        _titleLabel.font = JSFont(20);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_titleLabel];
        
        
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.textColor = JSLikeBlackColor;
        _valueLabel.font = JSFont(20);
        _valueLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_valueLabel];
    }
    return self;
}



+(instancetype)cellForTableview:(UITableView*)tableview{
    NSString *const identif = @"StuInfoShowTableViewCell";
    StuInfoShowTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:identif];
    if (!cell) {
        cell = [[StuInfoShowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identif];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    return cell;
}



-(void)showForModel:(StudentsInfo *)model andCount:(CGFloat)currentCount andCellWidth:(CGFloat)width{
    self.currentCount = currentCount;

    self.model = model;

    self.valueLabel.textColor = JSLikeBlackColor;

    if (_currentCount == 2) {
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        
        self.valueLabel.frame = CGRectMake(width - 200 - 50, 0, 200, 60);
        
    }else{

        self.accessoryType=UITableViewCellAccessoryNone;
        
        
        self.valueLabel.frame = CGRectMake(width - 200 - 30, 0, 200, 60);
    }

    self.titleLabel.frame = CGRectMake(30, 0, 100, 60);

    self.titleLabel.text = @"title";

    self.valueLabel.text = @"value";

    if (self.currentCount == 0) {
        self.titleLabel.text = @"账号";
        self.valueLabel.text = self.model.loginName;

    }else if (self.currentCount == 1){
        self.titleLabel.text = @"姓名";
        self.valueLabel.text = self.model.stuName;

    }else if (self.currentCount == 2){
        self.titleLabel.text = @"年龄";
        
        if (self.model.birthday.length) {
            self.valueLabel.text = self.model.birthday;
        }else{
            self.valueLabel.textColor = [UIColor redColor];
            self.valueLabel.text = @"未填";
        }

    }else if (self.currentCount == 3){
        self.titleLabel.text = @"中心";
        self.valueLabel.text = self.model.centerName;

    }else if (self.currentCount == 4){
        self.titleLabel.text = @"属性";
        self.valueLabel.text = @"竞思";

    }else{
        self.titleLabel.text = @"账号";
        self.valueLabel.text = self.model.loginName;
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    
    if (self.currentCount == 2) {
        [super setSelected:selected animated:animated];
    }
}

@end
