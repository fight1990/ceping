//
//  JSShuDuAlertView.h
//  qiqiaoban
//
//  Created by mac on 2019/7/3.
//  Copyright © 2019年 mac. All rights reserved.
//
//用在数独里面的弹出窗口。

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JSShuDuAlertViewStyle) {
    JSShuDuAlertViewStyleOutTime = 0, //超时了                      //下次再努力吧 分数 答题超时.
    JSShuDuAlertViewStyleLoding = 1,   // 读取题目
    JSShuDuAlertViewStyleLodingError = 2,//读取题目失败
    JSShuDuAlertViewStyleBujige = 3,//不及格                       //图像不同(白  显示时间 分数
    JSShuDuAlertViewStyleVeryGood = 4,//你真棒                        //图像不同(效果  显示时间 分数
    JSShuDuAlertViewStyleLevelUp = 5, //升级了.                      //
    JSShuDuAlertViewStyleLevelDown = 6,  //d降级了。
    JSShuDuAlertViewStyleNormal = 7          //普通分数/
};


NS_ASSUME_NONNULL_BEGIN

@interface JSShuDuAlertView : UIView


@property (nonatomic,assign) JSShuDuAlertViewStyle  style;

+(void)hideAlert;

+(instancetype)showMessage:(NSString *)title forView:(UIView *)view andFenshu:(NSString *)fenshu andFuBiao:(NSString *)fubiao andButtonTitle:(NSString *)buttonTitle endFailus:(void(^)())todo;


+(void)showAlertWithStyle:(JSShuDuAlertViewStyle)style title:(NSString *)title andFenshu:(NSString *)fenshu andFuBiao:(NSString *)fubiao andButtonTitle:(NSString *)buttonTitle endFailus:(void(^)())todo;



@end

NS_ASSUME_NONNULL_END
