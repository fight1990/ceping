//
//  GameEnumView.m
//  qiqiaoban
//
//  Created by Wei on 2019/8/20.
//  Copyright © 2019 mac. All rights reserved.
//

#import "GameEnumView.h"
#import <Masonry/Masonry.h>
#import "TrafficLightCollectionViewCell.h"
#import "QuickFlashingCollectionViewCell.h"
#import "StroopEffectCollectionViewCell.h"

#define KLineSpacing 5

@interface GameEnumView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) XTMemoryGameType memoryGameType;

@end

@implementation GameEnumView

- (instancetype)initWithXTMemoryGameType:(XTMemoryGameType)memoryGameType {
    self = [super init];
    if (self) {
        _memoryGameType = memoryGameType;
        [self addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

#pragma mark Getting && Setting
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        
        //注册cell
        if (_memoryGameType == XTMemoryGameTypeWithTrafficLight) {
            [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TrafficLightCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:KTrafficLightCollectionViewCellIdentifier];
        } else if (_memoryGameType == XTMemoryGameTypeWithQuickFlashing) {
             [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([QuickFlashingCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:KQuickFlashingCollectionViewCellIdentifier];
        } else if (_memoryGameType == XTMemoryGameTypeWithStroopEffect) {
             [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([StroopEffectCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:KStroopEffectCollectionViewCellIdentifier];
        }
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
    }
    return _collectionView;
}

- (void)setLevelModel:(MemoryGameLevelModel *)levelModel {
    _levelModel = levelModel;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
//分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (_memoryGameType == XTMemoryGameTypeWithTrafficLight) {
        return 3;
    } else {
        return 1;
    }
}
//每个分区item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
    
}
//创建cell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_memoryGameType == XTMemoryGameTypeWithTrafficLight) {
        TrafficLightCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KTrafficLightCollectionViewCellIdentifier forIndexPath:indexPath];
        
        NSNumber *indexNumber = [NSNumber numberWithInteger:indexPath.row + indexPath.section];
//        CGFloat itmW = (CGRectGetWidth(self.frame)-(_levelModel.maxCount/3+1.0)*KLineSpacing)/(_levelModel.maxCount/3);

        cell.cornerRadius = (CGRectGetHeight(self.frame)- KLineSpacing*8)/6.0;
        if ([_levelModel.colorIndexs containsObject:indexNumber]) {
            cell.lightColor = rand()%2==0?[_levelModel.colors firstObject]:[_levelModel.colors lastObject];
        } else {
            cell.lightColor = [UIColor darkGrayColor];
        }
        
        return cell;
    } else if (_memoryGameType == XTMemoryGameTypeWithQuickFlashing) {
        QuickFlashingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KQuickFlashingCollectionViewCellIdentifier forIndexPath:indexPath];
        
        cell.memoryGameLevelModel = _levelModel;
        
        return cell;
    } else if (_memoryGameType == XTMemoryGameTypeWithStroopEffect) {
        StroopEffectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KStroopEffectCollectionViewCellIdentifier forIndexPath:indexPath];
        
        cell.memoryGameLevelModel = _levelModel;

        return cell;
    }
    
    return nil;
}
/**
 //创建区头视图和区尾视图
 - (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
 
 return nil;
 }
 */

//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    CGFloat itemW = (CGRectGetWidth(self.frame)-(_levelModel.maxCount/3+1.0)*KLineSpacing)/(_levelModel.maxCount/3);
    if (_memoryGameType == XTMemoryGameTypeWithTrafficLight) {
        CGFloat itemW = (CGRectGetHeight(self.frame)-KLineSpacing*8)/3.0;
        return CGSizeMake(CGRectGetWidth(collectionView.frame), itemW);
    } else {
        return CGSizeMake(CGRectGetWidth(collectionView.frame), CGRectGetHeight(collectionView.frame));
    }
    
    
}
//每个分区的内边距（上左下右）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
//    CGFloat itemW = (CGRectGetWidth(self.frame)-(_levelModel.maxCount/3+1.0)*KLineSpacing)/(_levelModel.maxCount/3);
//    CGFloat padding = (CGRectGetHeight(self.frame)-itemW*3)/8.0;
    
    if (section == 0) {
        return UIEdgeInsetsMake(KLineSpacing*2, KLineSpacing, KLineSpacing, KLineSpacing);
    } else if (section == 3) {
        return UIEdgeInsetsMake(KLineSpacing, KLineSpacing, KLineSpacing*2, KLineSpacing);
    } else {
        return UIEdgeInsetsMake(KLineSpacing, KLineSpacing, KLineSpacing, KLineSpacing);
    }


}
//分区内cell之间的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return KLineSpacing;
}
//分区内cell之间的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return KLineSpacing;
}
/**
 //区头大小
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
 return CGSizeMake(KScreenWidth, 40);
 }
 */

@end
