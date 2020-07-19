//
//  SDView.m
//  shudu
//
//  Created by mac on 2019/6/19.
//  Copyright © 2019年 mac. All rights reserved.
//


#import "SDView.h"
#import "UIView+Frame.h"
#import "JSEDefine.h"
#import "UIImage+Render.h"



@interface SDView ()



@property (nonatomic,retain,readwrite) ShuduButton *currentSelectButton;



@end

@implementation SDView

-(void)creatView{

    
    
    if (self.shuduButtonArray.count) {
        [self.shuduButtonArray removeAllObjects];
    }
    self.shuduButtonArray = [NSMutableArray array];
    self.userInteractionEnabled = YES;

    
    CGFloat areaOffset = 0;
    CGFloat bianchang = 40;
    CGFloat buttonOffset = 0;
    CGFloat viewTotalWidth;
    CGFloat viewTotalHeight;
    CGFloat lineWidth = 0;
    int a;
    int b;
    int c;
    int d;
    
    
    switch (self.SDViewType) {
        case SDViewTypeSix:
            a = 2;
            b = 3;
            c = 3;
            d = 2;
            areaOffset = 16;
            buttonOffset = 8;
            lineWidth = 2;
            
            bianchang = (self.width - areaOffset * 2 - buttonOffset * 6 - lineWidth ) / 6.0;
            viewTotalWidth = self.width;
            viewTotalHeight = bianchang * 6 + areaOffset * 2 + buttonOffset * 7 + lineWidth * 2;
            
            break;
        case SDViewTypeFour:
            a = 2;
            b = 2;
            c = 2;
            d = 2;
            areaOffset = 16;
            buttonOffset = 8;
            lineWidth = 2;
            
            viewTotalWidth = self.width;
            viewTotalHeight = viewTotalWidth;
            
            bianchang = (viewTotalWidth - areaOffset * 2 - buttonOffset * 4 - lineWidth) / 4.0;
            
            break;
        case SDViewTypeNine:
            a = 3;
            b = 3;
            c = 3;
            d = 3;
            areaOffset = 16;
            buttonOffset = 8;
            lineWidth = 2;
            
            viewTotalWidth = self.width;
            viewTotalHeight = viewTotalWidth;
            
            bianchang = (viewTotalWidth - areaOffset * 2 - buttonOffset * 10 - lineWidth * 2) / 9.0;
            
            break;
        default:
            break;
    }
    
    //创建虚假的contain;
    
    UIView *lieContain = [[UIView alloc] init];
    lieContain.backgroundColor = JSColor(234, 234, 234, 1);
    lieContain.layer.cornerRadius = 20;
    lieContain.layer.masksToBounds = UIEventSubtypeNone;
    lieContain.layer.borderColor = JSColor(213, 213, 213, 1).CGColor;
    lieContain.layer.borderWidth = 1;
    
    lieContain.width = viewTotalWidth;
    
    lieContain.height = viewTotalHeight;
    
    lieContain.x = lieContain.y = 0;
    
    [self addSubview:lieContain];
    
    
    
    
    for (int i=0; i<a; i++) {
        for (int j=0; j<b; j++) {
            for (int k=0; k<c; k++) {
                for (int p=0; p<d; p++) {
                    ShuduButton *button = [ShuduButton buttonWithType:UIButtonTypeCustom];
                    [self.shuduButtonArray addObject:button];
                    button.frame = CGRectMake(areaOffset + i * (bianchang * b + (b + 1) * buttonOffset) + j * bianchang + j * buttonOffset ,areaOffset + k * (bianchang * d + (d + 1) * buttonOffset) + p * bianchang + p * buttonOffset, bianchang, bianchang);
                    //i 横 大区
                    //j 横 小区
                    //k 竖 大区
                    //p 竖 小区
                    //确定 button 的值
                    button.Posi = BTPositonMake(i * b + j, k * d + p);
                    button.iAre = k * a  + i;
                    button.isInRightPlace = YES;
                    //点击按钮之后的操作  剩下的后面来判断
                    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
                    //暂时没有长按的操作。
//                    [button addUILongPressGestureRecognizerWithTarget:self withAction:@selector(longPress:) withMinimumPressDuration:1];
                    //按钮样式
                    button.layer.cornerRadius = 14.0f;
                    //边框是往内部延伸。
//                    button.layer.borderWidth = .5f; // 边框的宽度;
                    button.layer.masksToBounds = YES;
                    [self addSubview:button];
                    button.titleLabel.font = [UIFont boldSystemFontOfSize:35];
                    //在这里就需要给button输入需要显示的值了。
                    
                    button.layer.shadowColor = [UIColor darkGrayColor].CGColor;
                    button.layer.shadowRadius = 1;
                    button.layer.shadowOpacity = 1;
                    
                    switch (self.SDViewType) {
                        case SDViewTypeSix:
                            button.showTypeColor = JSColor(26, 202, 155, 1);
                            button.showTypeTitleColor = [UIColor whiteColor];
                            button.clickTypeColor = JSColor(74, 121, 217, 1);
                            button.clickTypeTitleColor = [UIColor whiteColor];
                            button.selectButtonBackColor = JSColor(73, 97, 217, 1);
                            break;
                        case SDViewTypeFour:
                            
                            button.showTypeColor = JSColor(29, 176, 235, 1);
                            button.showTypeTitleColor = [UIColor whiteColor];
                            button.clickTypeColor = JSColor(89, 93, 203, 1);
                            button.clickTypeTitleColor = [UIColor whiteColor];
                            button.selectButtonBackColor = JSColor(136, 99, 184, 1);
                            break;
                        case SDViewTypeNine:
                            
                            button.showTypeColor = JSColor(76, 200, 62, 1);
                            button.showTypeTitleColor = [UIColor whiteColor];
                            button.clickTypeColor = JSColor(26, 177, 199, 1);
                            button.clickTypeTitleColor = [UIColor whiteColor];
                            button.selectButtonBackColor = JSColor(29, 176, 235, 1);
                            
                            break;
                        default:
                            break;
                    }
                }
            }
        }
    }
    
    //必须要给button上一条边框。
    

    //横向的大区的边框
    for (int i = 1; i < a; i ++) {
        //应该左边右边各有一条。
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.height = viewTotalHeight - 2;
        view.width = lineWidth;
        view.y = 1;
        view.centerX = areaOffset + i* (bianchang * b) + i *( (b + 1) * buttonOffset) - buttonOffset + (i - 1) * lineWidth ;
        [self addSubview:view];
    }

    //竖向的大区的边框
    for (int j = 1 ; j < c; j ++) {

        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.height = lineWidth;
        view.width = viewTotalWidth - 2;
        view.x = 1;
        view.centerY = areaOffset + j* (bianchang * d) + j *((d + 1) * buttonOffset) - buttonOffset + (j - 1) * lineWidth ;
        [self addSubview:view];
    }
    
    
    
    
    //在这里顺便创建按钮.
    
    CGFloat endButtonOffset = 56;
    
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.height = 55;
    clearButton.width = 185;
    clearButton.layer.cornerRadius = 27.5;
    clearButton.layer.masksToBounds = YES;
    clearButton.y = viewTotalHeight + 20;
    clearButton.x = self.width - clearButton.width;
    [clearButton setTitle:@"清除本格" forState:UIControlStateNormal];
    [clearButton.titleLabel setFont:JSFont(25)];
//    [clearButton setImage:[[UIImage imageNamed:@"1清除"]scaleSize:CGSizeMake(36, 36)] forState:UIControlStateNormal];
    [clearButton setBackgroundColor:JSColor(240, 1, 102, 1)];
//    [clearButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [self addSubview:clearButton];
    [clearButton addTarget:self action:@selector(touchClearButton:) forControlEvents:UIControlEventTouchUpInside];
    self.clearButton = clearButton;
    
    
    UIButton *uploadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadButton.height = 55;
    uploadButton.width = 185;
    uploadButton.layer.cornerRadius = 27.5;
    uploadButton.layer.masksToBounds = YES;
    uploadButton.y = clearButton.y;
    uploadButton.x = 0;
    [uploadButton setTitle:@"提交" forState:UIControlStateNormal];
    [uploadButton.titleLabel setFont:JSFont(25)];
    [uploadButton setImage:[[UIImage imageNamed:@"2提交"]scaleSize:CGSizeMake(36, 36)] forState:UIControlStateNormal];
    [uploadButton setBackgroundColor:[UIColor grayColor]];
    [uploadButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [self addSubview:uploadButton];
    
    [uploadButton addTarget:self action:@selector(touchUploadButton:) forControlEvents:UIControlEventTouchUpInside];
    self.uploadButton = uploadButton;
    

    //创建按钮的背景.
    
    
    self.buttonHeight = CGRectGetMaxY(uploadButton.frame) + endButtonOffset * .5;
    
    //创建点击的汉字
    for (NSInteger i=0; i< a * b; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        switch (self.SDViewType) {
            case SDViewTypeSix:
                button.backgroundColor = JSColor(73, 97, 217, 1);
                
                button.frame = CGRectMake(bianchang*i+16,CGRectGetMaxY(uploadButton.frame) + endButtonOffset, 70, 70);
                break;
            case SDViewTypeFour:
                button.backgroundColor = JSColor(136, 99, 184, 1);
                
                button.frame = CGRectMake(bianchang*i+16,CGRectGetMaxY(uploadButton.frame) + endButtonOffset, 85, 85);
                break;
            case SDViewTypeNine:
                button.backgroundColor = JSColor(29, 176, 235, 1);
                
                button.frame = CGRectMake(bianchang*i+16,CGRectGetMaxY(uploadButton.frame) + endButtonOffset, 55, 55);
                break;
            default:
                break;
        }
        
        button.centerX = self.width / (a * b + 1) * (i + 1);
        [button addTarget:self action:@selector(inputNum:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [button setTitle:[NSString stringWithFormat:@"%ld",(long)i+1] forState:UIControlStateNormal];
        button.titleLabel.font = JSFont(25);
        
        button.layer.cornerRadius = 8;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.masksToBounds = YES;
        
        button.tag=101+i;
        [self addSubview:button];
    }
    
    
    
    
    
    
    
    
}





//点击 显示数独button
-(void)clickButton:(UIButton*)but{

    ShuduButton *sdbut = (ShuduButton *)but;
    if (sdbut.ShuduButtonType & ShuduButtonTypeShow) {
        return;
    }
    
    //这里要进行判断。 当前 button 的类型
    
    //改变颜色之前需要对之前所有的按钮的x颜色进行还原。
    //不然这样会让整个棋盘的颜色都变成同一种颜色。
    //先进行所有颜色的变更。
    //需要记录当前点击了的按钮。
    
    [self setAllButtonColorOrigin];
    [self colorHang:sdbut.Posi];
    [self colorLie:sdbut.Posi];
    [self colorRongQi:sdbut.iAre];
    [self colorSelect:sdbut.Posi];
    self.currentSelectButton = sdbut;
}


//点击了 下方数字button
-(void)inputNum:(UIButton *)but{
    if (!self.currentSelectButton||self.currentSelectButton.showNum !=0) {
        return;
    }
    
    //先得到当前点击的数字。
    
    NSInteger selectNum = but.titleLabel.text.integerValue;
    //是否需要对答案进行测试正确与否。  先判断对错.
    if ([self.delegate respondsToSelector:@selector(SDView:willEnterOneNum:inButton:)]) {
        [self.delegate SDView:self willEnterOneNum:selectNum inButton:self.currentSelectButton];
    }
    //改变button的显示。
    self.currentSelectButton.showNum = selectNum;
    
    if ([self.delegate respondsToSelector:@selector(SDView:didEnterOneNum:inButton:)]) {
        [self.delegate SDView:self didEnterOneNum:selectNum inButton:self.currentSelectButton];
    }
    
}

-(ShuduButton *)buttonForPosi:(BTPostion)postion{
    for (ShuduButton *btn in self.shuduButtonArray) {
        if (BTPositonSame(btn.Posi, postion)) {
            return btn;
        }
    }
    NSAssert(0, @"是找不到的位置");
    return [ShuduButton new];
}

//将所有按钮的颜色还原。
-(void)setAllButtonColorOrigin{
    
    for (ShuduButton *btn in self.shuduButtonArray) {
        [btn setShuduButtonType:btn.ShuduButtonType];

        [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        if (btn.isInRightPlace == NO) {
//            [btn setTitleColor:btn.wrongTitleColor forState:UIControlStateNormal];
        }
        
    }
}

//显示这一行的颜色  横着的
- (void)colorHang:(BTPostion)posi{
    for (ShuduButton *btn in self.shuduButtonArray) {
        if (btn.Posi.ycount == posi.ycount) {
//            btn.backgroundColor=[UIColor cyanColor];
            
            
            switch (self.SDViewType) {
                case SDViewTypeSix:
                    [btn setBackgroundImage:[UIImage imageNamed:@"6h"] forState:UIControlStateNormal];
                    break;
                case SDViewTypeFour:
                    [btn setBackgroundImage:[UIImage imageNamed:@"3h"] forState:UIControlStateNormal];
                    break;
                case SDViewTypeNine:
                    [btn setBackgroundImage:[UIImage imageNamed:@"9h"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }
    }
}

//显示着一列的颜色  竖着的
- (void)colorLie:(BTPostion)posi{
    for (ShuduButton *btn in self.shuduButtonArray) {
        if (btn.Posi.xcount == posi.xcount) {
//            btn.backgroundColor=[UIColor cyanColor];
            
            switch (self.SDViewType) {
                case SDViewTypeSix:
                    [btn setBackgroundImage:[UIImage imageNamed:@"6h"] forState:UIControlStateNormal];
                    break;
                case SDViewTypeFour:
                    [btn setBackgroundImage:[UIImage imageNamed:@"3h"] forState:UIControlStateNormal];
                    break;
                case SDViewTypeNine:
                    [btn setBackgroundImage:[UIImage imageNamed:@"9h"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }
    }
}

//显示这个小九宫格的颜色
- (void)colorRongQi:(areaCount)area{
    for (ShuduButton *btn in self.shuduButtonArray) {
        if (btn.iAre == area) {
//            btn.backgroundColor=[UIColor cyanColor];
            
            switch (self.SDViewType) {
                case SDViewTypeSix:
                    [btn setBackgroundImage:[UIImage imageNamed:@"6h"] forState:UIControlStateNormal];
                    break;
                case SDViewTypeFour:
                    [btn setBackgroundImage:[UIImage imageNamed:@"3h"] forState:UIControlStateNormal];
                    break;
                case SDViewTypeNine:
                    [btn setBackgroundImage:[UIImage imageNamed:@"9h"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }
    }
}

-(void)colorSelect:(BTPostion)posi{
    for (ShuduButton *btn in self.shuduButtonArray) {
        if (btn.Posi.xcount == posi.xcount && btn.Posi.ycount == posi.ycount) {
            if (btn.showNum == 0) {
                //未选择
                switch (self.SDViewType) {
                    case SDViewTypeSix:
                        [btn setBackgroundImage:[UIImage imageNamed:@"2彩色"] forState:UIControlStateNormal];
                        break;
                    case SDViewTypeFour:
                        [btn setBackgroundImage:[UIImage imageNamed:@"1蓝框"] forState:UIControlStateNormal];
                        break;
                    case SDViewTypeNine:
                        [btn setBackgroundImage:[UIImage imageNamed:@"3绿框"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
                
                [btn setTitleColor:JSMainBlueColor forState:UIControlStateNormal];
                
            }else{
                //已选择
                btn.backgroundColor= btn.selectButtonBackColor;
                
            }
            
        }
    }
}


#pragma mark - 特殊按钮

//首先用协议决定是否需要可以执行按钮.

//点击清除按钮.
-(void)touchClearButton:(UIButton *)sender{
    
    if ([self.delegate respondsToSelector:@selector(SDView:canClcikClearButton:)]&& [self.delegate SDView:self canClcikClearButton:sender] ) {
        //确认可以点击按钮.
        
        //如果当前没有选中按钮. 就取消掉.
        if (!self.currentSelectButton || self.currentSelectButton.showNum ==0) {
            return;
        }
        
        //如果上面取消掉 就不会执行取消成功的方法. 视为 取消失败.
        
        if ([self.delegate respondsToSelector:@selector(SDView:canClear:)]) {
            
            if (![self.delegate SDView:self canClear:sender]) {
                return;
            }
            
        }
        [self.currentSelectButton setShowNum:0];
        if ([self.delegate respondsToSelector:@selector(SDView:didClickClearButton:)]) {
            [self.delegate SDView:self didClickClearButton:sender];
        }
    }
}



//点击上传按钮.
-(void)touchUploadButton:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(SDView:canClcikUploadButton:)]&& [self.delegate SDView:self canClcikUploadButton:sender] ) {
        //确认可以点击按钮.
        if ([self.delegate respondsToSelector:@selector(SDView:didClickUloadButton:)]) {
            [self.delegate SDView:self didClickUloadButton:sender];
        }
    }
    
}


@end
