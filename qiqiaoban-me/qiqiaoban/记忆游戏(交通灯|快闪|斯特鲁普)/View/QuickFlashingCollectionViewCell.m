//
//  QuickFlashingCollectionViewCell.m
//  qiqiaoban
//
//  Created by Wei on 2019/8/21.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QuickFlashingCollectionViewCell.h"

NSString * const KQuickFlashingCollectionViewCellIdentifier = @"KQuickFlashingCollectionViewCellIdentifier";

@interface QuickFlashingCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) CALayer *maskLayer;
@end

@implementation QuickFlashingCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMemoryGameLevelModel:(MemoryGameLevelModel *)memoryGameLevelModel {
    _memoryGameLevelModel = memoryGameLevelModel;
    

    [self setMaskLayerContents:[[_memoryGameLevelModel.graphShapes firstObject] integerValue]];
}

- (void)setMaskLayerContents:(NSInteger)index {
    NSString *imageName = nil;
    switch (index) {
        case 0:
            imageName = @"quickFlashShape_1";
            break;
        case 1:
            imageName = @"quickFlashShape_2";
            break;
        case 2:
            imageName = @"quickFlashShape_3";
            break;
        case 3:
            imageName = @"quickFlashShape_4";
            break;
        case 4:
            imageName = @"quickFlashShape_5";
            break;
        case 5:
            imageName = @"quickFlashShape_6";
            break;
        default:
            break;
    }
    
    self.imageView.image = [UIImage imageNamed:imageName];
    self.imageView.image = [self.imageView.image imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    self.imageView.tintColor = [_memoryGameLevelModel.colors firstObject];
}

- (CALayer *)maskLayer {
    _maskLayer = [CALayer layer];
    _maskLayer.frame = CGRectMake(0, 0, _imageView.bounds.size.width, _imageView.bounds.size.height);
    _maskLayer.contentsGravity = kCAGravityResizeAspect;
    _maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
    return _maskLayer;
}

@end
