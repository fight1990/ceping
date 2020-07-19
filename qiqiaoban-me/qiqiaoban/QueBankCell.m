//
//  QueBankCell.m
//  QiQiaoBan
//
//  Created by mac on 2019/3/12.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "QueBankCell.h"

@implementation QueBankCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

        self.backgroundView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.width)];
        
        [self.contentView addSubview:self.backgroundView];

        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.contentView.frame.size.width-20, 40)];
        _textLabel.center =CGPointMake(self.contentView.frame.size.width/2, self.contentView.frame.size.height/2);
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:25];
        [self.contentView addSubview:_textLabel];
        
    }
    
    return self;
}
@end
