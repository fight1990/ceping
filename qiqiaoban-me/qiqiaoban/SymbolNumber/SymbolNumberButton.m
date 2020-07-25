//
//  SymbolNumberButton.m
//  QiQiaoBan
//
//  Created by mac on 2019/8/13.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "SymbolNumberButton.h"

@implementation SymbolNumberButton

-(void)setShowNum:(NSInteger)showNum{
    _showNum = showNum;
    [self setTitle:[NSString stringWithFormat:@"%ld",(long)_showNum] forState:UIControlStateNormal];
}

-(UIColor *)showTypeColor{
    if (!_showTypeColor) {
        _showTypeColor = [UIColor whiteColor];
    }
    return _showTypeColor;
}

-(UIColor *)clickTypeColor{
    if (!_clickTypeColor) {
        _clickTypeColor = [UIColor whiteColor];
    }
    return _clickTypeColor;
}

-(void)setSymbolNumberButtonType:(SymbolNumberButtonType)SymbolNumberButtonType{
    
    _SymbolNumberButtonType = SymbolNumberButtonType;
    
    if (_SymbolNumberButtonType & SymbolNumberButtonTypeClick) {
        self.backgroundColor = self.clickTypeColor;
    }
    
    
    if (_SymbolNumberButtonType & SymbolNumberButtonTypeShow) {
        self.backgroundColor = self.showTypeColor;
    }
    
}

@end
