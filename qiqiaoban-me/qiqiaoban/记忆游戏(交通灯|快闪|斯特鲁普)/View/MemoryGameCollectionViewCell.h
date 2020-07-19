//
//  MemoryGameCollectionViewCell.h
//  qiqiaoban
//
//  Created by Wei on 2019/8/11.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemoryGameModel.h"

NS_ASSUME_NONNULL_BEGIN

#define KLineNum 5
#define KLineSpacing 20

extern NSString* const KMemoryGameCollectionViewCellIdentifier;

@interface MemoryGameCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) MemoryGameModel *memoryGameModel;

@end

NS_ASSUME_NONNULL_END
