//
//  ImageModel.h
//  qiqiaoban
//
//  Created by mac on 2019/8/30.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageModel : NSObject

@property (nonatomic,retain) NSString *urlStr;

@property (nonatomic,assign) BOOL isSickRight;

@property (nonatomic,retain) UIImage *image;

@end

NS_ASSUME_NONNULL_END
