//
//  MacroDefinition.h
//  Artisan
//
//  Created by Wei on 2019/6/22.
//  Copyright © 2019 Butcher. All rights reserved.
//

#ifndef MacroDefinition_h
#define MacroDefinition_h

/*-- param mark 适配相关 --*/
//屏幕宽度
#define KScreenWidth   [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height

//状态栏高度
#define KStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
//标签栏高度
#define KTabBarHeight (KStatusBarHeight > 20 ? 83 : 49)
//导航栏高度
#define KNavBarHeight (KStatusBarHeight + 44)
//安全区高度
#define KSafeAreaBottom (kISiPhoneXX ? 34 : 0)

#define IPHONE_X \
({BOOL isPhoneX = NO; \
    if (@available(iOS 11.0, *)) { \
        isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0; \
    } \
    (isPhoneX); \
})

#define IS_IPHONE_6 (KScreenHeight > 667.0)

/*-- param mark 字体/颜色值设置 --*/

#define KSystemBoldFont(x) [UIFont boldSystemFontOfSize:x]
#define KSystemFont(x)     [UIFont systemFontOfSize:x]

//RGB格式
#define KRGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
//RGBA格式
#define KRGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//随机颜色
#define KRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGB_30(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.30]


/*-- param mark 系统对象 --*/
//APP对象 （单例对象）
#define KApplication [UIApplication sharedApplication]
//主窗口 （keyWindow）
#define KKeyWindow [UIApplication sharedApplication].keyWindow
//NSUserDefaults实例化
#define KUserDefaults [NSUserDefaults standardUserDefaults]
//通知中心 （单例对象）
#define KNotificationCenter [NSNotificationCenter defaultCenter]
//发送通知
#define KPostNotification(name,obj,info) [[NSNotificationCenter defaultCenter]postNotificationName:name object:obj userInfo:info]
//APP版本号
#define KVersion [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]
//系统版本号
#define KSystemVersion [[UIDevice currentDevice] systemVersion]

/*-- param mark 常用方法 --*/
//加载图片
#define KGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]
//弱引用
#define KWeakSelf(type)  __weak typeof(type) weak##type = type
//强引用
#define KStrongSelf(type)  __strong typeof(type) type = weak##type
//字符串拼接
#define KStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]


//永久存储对象
#define KSetUserDefaults(object, key) \
({ \
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults]; \
    [defaults setObject:object forKey:key]; \
    [defaults synchronize]; \
})
//获取对象
#define KGetUserDefaults(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
//删除某一个对象
#define KRemoveUserDefaults(key) \
({ \
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; \
    [defaults removeObjectForKey:_key]; \
    [defaults synchronize]; \
})
//清除 NSUserDefaults 保存的所有数据
#define KRemoveAllUserDefaults  [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]]

/*-- param mark 沙盒路径 --*/
//获取沙盒 temp
#define KPathTemp NSTemporaryDirectory()
//获取沙盒 Document
#define KPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define KPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
//Library/Caches 文件路径
#define KFilePath ([[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil])

/*-- param mark 判空 --*/
//字符串是否为空
#define KISNullString(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define KISNullArray(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0 ||[array isEqual:[NSNull null]])
//字典是否为空
#define KISNullDict(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0 || [dic isEqual:[NSNull null]])
//是否是空对象
#define KISNullObject(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))
//判断对象是否为空,为空则返回默认值
#define KGetNullDefaultObj(_value,_default) ([_value isKindOfClass:[NSNull class]] || !_value || _value == nil || [_value isEqualToString:@"(null)"] || [_value isEqualToString:@"<null>"] || [_value isEqualToString:@""] || [_value length] == 0)?_default:_value

/*-- param mark 自定义Log --*/
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(FORMAT, ...) nil
#endif


#endif /* MacroDefinition_h */
