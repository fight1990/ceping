//
//  TrafficLightCollectionViewCell.h
//  qiqiaoban
//
//  Created by Wei on 2019/8/21.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const KTrafficLightCollectionViewCellIdentifier;

@interface TrafficLightCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIColor *lightColor;
@property (assign, nonatomic) CGFloat cornerRadius;

@end
