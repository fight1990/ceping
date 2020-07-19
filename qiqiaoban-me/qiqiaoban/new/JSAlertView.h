//
//  JSAlertView.h
//  qiqiaoban
//
//  Created by mac on 2019/3/20.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSString+Bounding.h"

typedef NS_ENUM(NSInteger, JSAlertViewStyle) {
    JSAlertViewStyleOutTime = 0, //超时了                      //下次再努力吧 分数 答题超时.
    JSAlertViewStyleSeeAnswer = 1,   // 看答案                 //查看答案,放弃做大 在努力试试.
    JSAlertViewStyleGiveUp = 2,//放弃作答 跳过                   //跳过本轮,放弃做大 不自己试试
    JSAlertViewStylePutong = 3,//普通分数                       //图像不同(白  显示时间 分数
    JSAlertViewStyleVeryGood = 4,//高分                        //图像不同(效果  显示时间 分数
    JSAlertViewStyleLevelUp = 5 //升级了.                      //
};


//显示分数和提示.  较为重要的部分.

@interface JSAlertView : UIView

@property (nonatomic,assign) JSAlertViewStyle  style;

+(void)hideAlert;

+(instancetype)showMessage:(NSString *)title forView:(UIView *)view andFenshu:(NSString *)fenshu andFuBiao:(NSString *)fubiao andButtonTitle:(NSString *)buttonTitle endFailus:(void(^)())todo;


+(void)showAlertWithStyle:(JSAlertViewStyle)style title:(NSString *)title andFenshu:(NSString *)fenshu andFuBiao:(NSString *)fubiao andButtonTitle:(NSString *)buttonTitle endFailus:(void(^)())todo;
@end
