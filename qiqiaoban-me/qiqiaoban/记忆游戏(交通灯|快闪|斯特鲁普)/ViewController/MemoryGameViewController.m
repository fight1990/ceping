//
//  MemoryGameViewController.m
//  qiqiaoban
//
//  Created by Wei on 2019/8/11.
//  Copyright © 2019 mac. All rights reserved.
//

#import "MemoryGameViewController.h"
#import "MemoryGameCollectionViewCell.h"
#import "MemoryGameDetailViewController.h"
#import "LevelLockAlertViewController.h"

#import <Masonry/Masonry.h>
#import "INetworking.h"
#import "JSStudentInfoManager.h"
#import "JSEDefine.h"
#import "MemoryGameModel.h"
#import "TrafficLightPresenter.h"
#import "QuickFlashingPresenter.h"
#import "StroopEffectPresenter.h"

@interface MemoryGameViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray<MemoryGameModel*> *dataList;

@end

@implementation MemoryGameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.collectionView];
    
    if (self.memoryGameType == XTMemoryGameTypeWithTrafficLight) {
        self.backgroundImageView.image = [UIImage imageNamed:@"trafficLight_background"];
    } else if (self.memoryGameType == XTMemoryGameTypeWithQuickFlashing) {
        self.backgroundImageView.image = [UIImage imageNamed:@"quickFlashing_background"];
    } else if (self.memoryGameType == XTMemoryGameTypeWithStroopEffect) {
        self.backgroundImageView.image = [UIImage imageNamed:@"stroopEffect_background"];
    }    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self requestAllData];
}

#pragma mark Networking
- (void)requestAllData {
    if (self.memoryGameType == XTMemoryGameTypeWithTrafficLight) {
        [self requestTrifficLightData];
        
    } else if (self.memoryGameType == XTMemoryGameTypeWithQuickFlashing) {
        [self requestQuickFlashingData];
    } else if (self.memoryGameType == XTMemoryGameTypeWithStroopEffect) {
        [self requestStroopEffectData];
    }
}
- (void)requestTrifficLightData {
    KWeakSelf(self);
    [TrafficLightPresenter getLevelDatas:^(NSArray<MemoryGameModel *> * _Nonnull datas, BOOL isSuccess) {
        KStrongSelf(self);
        if (isSuccess && datas) {
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:datas];
            
            if ([datas count] < 21) {
                for (NSInteger i = [datas count]; i<21; i++) {
                    if (i==0) {
                        MemoryGameModel *itemModel = [[MemoryGameModel alloc] init];
                        itemModel.unLock = YES;
                        itemModel.level = @"1";
                        [self.dataList addObject:itemModel];
                    } else if (i == [datas count]) {
                        MemoryGameModel *itemModel = [[MemoryGameModel alloc] init];
                        itemModel.unLock = ([[datas lastObject].stu_score floatValue]/[[datas lastObject].totlenumber floatValue] >= 0.8);
                        itemModel.level = [NSString stringWithFormat:@"%ld",i+1];
                        [self.dataList addObject:itemModel];
                    } else {
                        MemoryGameModel *itemModel = [[MemoryGameModel alloc] init];
                        itemModel.level = [NSString stringWithFormat:@"%ld",i+1];
                        [self.dataList addObject:itemModel];
                    }
                }
            }
            [self.collectionView reloadData];
        }
    }];
}

- (void)requestQuickFlashingData {
    KWeakSelf(self);
    [QuickFlashingPresenter getLevelDatas:^(NSArray<MemoryGameModel *> * _Nonnull datas, BOOL isSuccess) {
        KStrongSelf(self);
        if (isSuccess && datas) {
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:datas];
            
            if ([datas count] < 21) {
                for (NSInteger i = [datas count]; i<21; i++) {
                    if (i==0) {
                        MemoryGameModel *itemModel = [[MemoryGameModel alloc] init];
                        itemModel.unLock = YES;
                        itemModel.level = @"1";
                        [self.dataList addObject:itemModel];
                    } else if (i == [datas count]) {
                        MemoryGameModel *itemModel = [[MemoryGameModel alloc] init];
                         itemModel.unLock = ([[datas lastObject].stu_score floatValue]/[[datas lastObject].totlenumber floatValue] >= 0.8);                        itemModel.level = [NSString stringWithFormat:@"%ld",i+1];
                        [self.dataList addObject:itemModel];
                    } else {
                        MemoryGameModel *itemModel = [[MemoryGameModel alloc] init];
                        itemModel.level = [NSString stringWithFormat:@"%ld",i+1];
                        [self.dataList addObject:itemModel];
                    }
                }
            }
            [self.collectionView reloadData];
        }
    }];
}

- (void)requestStroopEffectData {
    KWeakSelf(self);
    [StroopEffectPresenter getLevelDatas:^(NSArray<MemoryGameModel *> * _Nonnull datas, BOOL isSuccess) {
        KStrongSelf(self);
        if (isSuccess && datas) {
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:datas];
            
            if ([datas count] < 21) {
                for (NSInteger i = [datas count]; i<21; i++) {
                    if (i==0) {
                        MemoryGameModel *itemModel = [[MemoryGameModel alloc] init];
                        itemModel.unLock = YES;
                        itemModel.level = @"1";
                        [self.dataList addObject:itemModel];
                    } else if (i == [datas count]) {
                        MemoryGameModel *itemModel = [[MemoryGameModel alloc] init];
                         itemModel.unLock = ([[datas lastObject].stu_score floatValue]/[[datas lastObject].totlenumber floatValue] >= 0.8);
                        itemModel.level = [NSString stringWithFormat:@"%ld",i+1];
                        [self.dataList addObject:itemModel];
                    } else {
                        MemoryGameModel *itemModel = [[MemoryGameModel alloc] init];
                        itemModel.level = [NSString stringWithFormat:@"%ld",i+1];
                        [self.dataList addObject:itemModel];
                    }
                }
            }
            [self.collectionView reloadData];
        }
    }];
}

#pragma mark Getting && Setting
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, KNavigationBar_Height*3.5, KScreenWidth, KScreenHeight-KNavigationBar_Height*3.5) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        
        //注册cell
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([MemoryGameCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:KMemoryGameCollectionViewCellIdentifier];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
    }
    return _collectionView;
}

- (NSMutableArray<MemoryGameModel*> *)dataList {
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
//分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//每个分区item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 21;
}
//创建cell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MemoryGameCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KMemoryGameCollectionViewCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row < [self.dataList count]) {
        cell.memoryGameModel = self.dataList[indexPath.row];
    } else {
        MemoryGameModel *model = [[MemoryGameModel alloc] init];
        model.level = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        cell.memoryGameModel = model;
    }
    
    return cell;
}
/**
//创建区头视图和区尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}
 */
//点击某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < [self.dataList count] && self.dataList[indexPath.row].unLock == YES) {
        MemoryGameModel *itemModel = self.dataList[indexPath.row];
        MemoryGameDetailViewController *detail = [[MemoryGameDetailViewController alloc] init];
        detail.level = [itemModel.level integerValue];
        detail.gameModel = self.dataList[indexPath.row];
        detail.memoryGameType = self.memoryGameType;
        KWeakSelf(self);
        detail.gameResultBlock = ^(BOOL isSuccess) {
            KStrongSelf(self);
            [self requestAllData];
        };
        [self presentViewController:detail animated:YES completion:nil];
    } else {
        LevelLockAlertViewController *alert = [LevelLockAlertViewController alertWithTitleImage:@"trafficLight_lock_title" andImage:[UIImage imageNamed:@"trafficLight_lock"]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}
//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
  
    CGFloat itemW = (KScreenWidth-(KLineNum+1.0)*KLineSpacing)/KLineNum;
    return CGSizeMake(itemW, itemW);
//    return CGSizeMake(140, 140);
}
//每个分区的内边距（上左下右）
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(KLineSpacing, KLineSpacing, KLineSpacing, KLineSpacing);
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
