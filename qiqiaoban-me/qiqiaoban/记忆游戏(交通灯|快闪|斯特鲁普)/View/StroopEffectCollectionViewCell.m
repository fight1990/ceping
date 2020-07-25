//
//  StroopEffectCollectionViewCell.m
//  qiqiaoban
//
//  Created by Wei on 2019/8/21.
//  Copyright © 2019 mac. All rights reserved.
//

#import "StroopEffectCollectionViewCell.h"

NSString * const KStroopEffectCollectionViewCellIdentifier = @"KStroopEffectCollectionViewCellIdentifier";

@interface StroopEffectCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;

@end

@implementation StroopEffectCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMemoryGameLevelModel:(MemoryGameLevelModel *)memoryGameLevelModel {
    _memoryGameLevelModel = memoryGameLevelModel;
    
    self.wordLabel.textColor = [_memoryGameLevelModel.colors firstObject];
    self.wordLabel.text = [_memoryGameLevelModel.colorWords firstObject];
    
}
@end
