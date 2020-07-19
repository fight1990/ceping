//
//  QuickFlashingCollectionViewCell.h
//  qiqiaoban
//
//  Created by Wei on 2019/8/21.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemoryGameLevelModel.h"

extern NSString* const KQuickFlashingCollectionViewCellIdentifier;

@interface QuickFlashingCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) MemoryGameLevelModel *memoryGameLevelModel;

@end
