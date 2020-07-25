//
//  ShuduButton.m
//  shudu
//
//  Created by mac on 2019/6/20.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ShuduButton.h"

#import "JSEDefine.h"

@implementation ShuduButton


-(void)setShowNum:(NSInteger)showNum{
    _showNum = showNum;
    if (_showNum == 0) {
        [self setTitle:@"" forState:UIControlStateNormal];
    }else{
        [self setTitle:[NSString stringWithFormat:@"%ld",_showNum] forState:UIControlStateNormal];
    }
}


//防止通过 直接给title的方式 跳过给 shownum;
-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    _showNum = title.integerValue;
    [super setTitle:title forState:state];
}


-(UIColor *)showTypeColor{
    if (!_showTypeColor) {
        _showTypeColor = JSColor(76, 200, 62, 1);
    }
    return _showTypeColor;
}

//设定填写之后的样色.  如果没有填写统一为白色.
-(UIColor *)clickTypeColor{
    if (!_clickTypeColor) {
        _clickTypeColor = [UIColor colorWithWhite:0.1 alpha:1];
    }
    return _clickTypeColor;
}


-(UIColor *)selectButtonBackColor{
    if (!_selectButtonBackColor) {
        _selectButtonBackColor = JSColor(254, 253, 91, 1);
    }
    return _selectButtonBackColor;
}

-(UIColor *)wrongButtonBackColor{
    
    if (!_wrongButtonBackColor) {
        _wrongButtonBackColor = JSColor(254, 253, 91, 1);
    }
    return _wrongButtonBackColor;
}

-(UIColor *)showTypeTitleColor{
    
    if (!_showTypeTitleColor) {
        _showTypeTitleColor = [UIColor blackColor];
    }
    return _showTypeTitleColor;
}

-(UIColor *)clickTypeTitleColor{
    
    if (!_clickTypeTitleColor) {
        _clickTypeTitleColor = JSColor(146, 0, 146, 1);
    }
    return _clickTypeTitleColor;
}



//显示错误的时候是需要改变字体颜色。
-(UIColor *)wrongTitleColor{
    
    if (!_wrongTitleColor) {
        _wrongTitleColor = [UIColor redColor];
    }
    return _wrongTitleColor;
    
}

-(void)setShuduButtonType:(ShuduButtonType)ShuduButtonType{
    
    _ShuduButtonType = ShuduButtonType;
    
    if (_ShuduButtonType & ShuduButtonTypeClick) {
        self.backgroundColor = self.clickTypeColor;
        [self setTitleColor:self.clickTypeTitleColor forState:UIControlStateNormal];
        
        if (self.showNum == 0) {
            self.backgroundColor = [UIColor whiteColor];
        }
        
        
    }
    
    if (_ShuduButtonType & ShuduButtonTypeShow) {
        self.backgroundColor = self.showTypeColor;
        [self setTitleColor:self.showTypeTitleColor forState:UIControlStateNormal];
    }
    
}



@end
