//
//  QuickMemoryCollectionViewCell.h
//  qiqiaoban
//
//  Created by Wei on 2019/8/11.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickMemoryModel.h"

NS_ASSUME_NONNULL_BEGIN

#define KLineNum 5
#define KLineSpacing 20

extern NSString* const KQuickMemoryCollectionViewCellIdentifier;

@interface QuickMemoryCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) QuickMemoryModel *quickMemoryModel;

@end

NS_ASSUME_NONNULL_END
