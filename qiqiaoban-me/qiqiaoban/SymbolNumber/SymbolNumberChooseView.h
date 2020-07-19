//
//  SymbolNumberChooseView.h
//  qiqiaoban
//
//  Created by mac on 2019/8/23.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SymbolNumberChooseView : UIView
@property (strong, nonatomic) UIImageView *clockImage;
@property (strong, nonatomic) UIImageView *passImage;

@property (strong, nonatomic) UIImageView *unpassImage;

@property (strong, nonatomic) UIImageView *starImage;
@property (strong, nonatomic) UIImageView *labelImage;

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *rightLabel;
@property (strong, nonatomic) UILabel *passLabel;
@end

NS_ASSUME_NONNULL_END
