//
//  JSEDefine.h
//  注意力测试
//
//  Created by Mac on 16/7/14.
//  Copyright © 2016年 Mac. All rights reserved.

//ANTINOMI

#import "UIView+Frame.h"

#define JSFrame [UIScreen mainScreen].bounds

#define KScreenWidth  [[UIScreen mainScreen]bounds].size.width
#define KScreenHeight [[UIScreen mainScreen]bounds].size.height
#define kScreen_Bounds [UIScreen mainScreen].bounds
#define RGBAlpha(r, g, b, a)     [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]
#define FourOnlyNumColor RGBAlpha(29, 176, 235, 1)
#define CommonlyUsedColor RGBAlpha(128, 42, 128, 1)

#define SERVISEURL @"http://114.55.90.93:8081/web/app/"
/**
 *  状态栏大小
 */
#define JSStatusRect [[UIApplication sharedApplication] statusBarFrame]

//tabbar
#define JSTabbarFrame self.tabBarController.tabBar.frame

//导航栏frame
#define JSNavigationBounds  self.navigationController.navigationBar.frame

#define JSFont(s)  [UIFont systemFontOfSize:(s)]

#define JSBold(s)  [UIFont boldSystemFontOfSize:(s)]

#define JSColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

#define JSLikeBlackColor      JSColor(20, 20, 20, 0.8)

#define JSMainBlueColor JSColor(17,160,230,1)

#define JSMainGreenColor JSColor(20, 180, 98, 1)

#define JSMainOrangeColor JSColor(243, 90, 15, 1)

#define JSMainPuer JSColor(175, 74, 135, 1)

#define JSMainDarkPuer JSColor(140, 0, 142, 1)

//定义UIimage对象
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//定义UIImage对象
#define IMAGE(imageFileName) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:imageFileName ofType:nil]]

#ifdef DEBUG  // 调试状态
// 打开LOG功能
#define JSLog(...) NSLog(__VA_ARGS__)
#define JSFunc JSLog(@"%s", __func__);
#define DebugLog(log, ...) NSLog((@"%s [Line %d]\n\t" log), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else // 发布状态
// 关闭LOG功能
#define JSLog(...)
#define DebugLog(log, ...) ((void)0)
#define JSFunc
#endif

#define getCurentTime [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]

#define WeakObject(o) __weak __typeof(o) o##Weak = o;

#define StrongObj(o)  __strong typeof(o##Weak) o##Strong = o##Weak;

#define iMAIN(block) dispatch_async(dispatch_get_main_queue(),block)

#define MAIN(block) dispath_async(dispatch_get_main_queue(),^{\
block\
})
