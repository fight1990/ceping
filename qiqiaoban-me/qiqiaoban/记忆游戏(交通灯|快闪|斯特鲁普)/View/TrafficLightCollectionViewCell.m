//
//  TrafficLightCollectionViewCell.m
//  qiqiaoban
//
//  Created by Wei on 2019/8/21.
//  Copyright © 2019 mac. All rights reserved.
//

#import "TrafficLightCollectionViewCell.h"

NSString * const KTrafficLightCollectionViewCellIdentifier = @"KTrafficLightCollectionViewCellIdentifier";

@interface TrafficLightCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation TrafficLightCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setLightColor:(UIColor *)lightColor {
    _lightColor = lightColor;
    self.imageView.backgroundColor = _lightColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.imageView.layer.cornerRadius = _cornerRadius;
    self.imageView.layer.masksToBounds = YES;
}

@end
