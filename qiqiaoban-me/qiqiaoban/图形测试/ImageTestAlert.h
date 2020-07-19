//
//  ImageTestAlert.h
//  qiqiaoban
//
//  Created by mac on 2019/8/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageTestAlert : UIView

@property (nonatomic,copy) void(^butClose)();

+(void)hideAlert;

+(instancetype)showAlertWithStars:(NSInteger)star andTime:(NSTimeInterval)time andTotal:(NSInteger)total andRight:(NSInteger)right andButtonTitle:(NSString *)title endFailus:(void(^)())todo;

-(void)closeButtonDo:(void(^)())todo;

@end

NS_ASSUME_NONNULL_END
