//
//  QuickMemoryViewController.m
//  qiqiaoban
//
//  Created by Wei on 2019/8/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QuickMemoryViewController.h"
#import "QuickMemoryCollectionViewCell.h"
#import "QuickMemoryDetailViewController.h"
#import "QMLevelLockAlertViewController.h"
#import "QuickMemoryPresenter.h"

#import <Masonry/Masonry.h>
#import "INetworking.h"
#import "JSStudentInfoManager.h"
#import "JSEDefine.h"
#import "QuickMemoryModel.h"

@interface QuickMemoryViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray<QuickMemoryModel*> *dataList;

@end

@implementation QuickMemoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backgroundImageView.image = [UIImage imageNamed:@"quickMemory_background"];

    [self.view addSubview:self.collectionView];
    
    [self requestData];
}

#pragma mark Networking
- (void)requestData {
    
    KWeakSelf(self);
    [QuickMemoryPresenter getLevelDatas:^(NSArray<QuickMemoryModel *> * _Nonnull datas, BOOL isSuccess) {
        KStrongSelf(self);
        if (isSuccess && datas) {
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:datas];
            
            if ([datas count] < 21) {
                for (NSInteger i = [datas count]; i<21; i++) {
                    if (i==0) {
                        QuickMemoryModel *itemModel = [[QuickMemoryModel alloc] init];
                        itemModel.unLock = YES;
                        itemModel.level = @"1";
                        [self.dataList addObject:itemModel];
                    } else if (i == [datas count]) {
                        QuickMemoryModel *itemModel = [[QuickMemoryModel alloc] init];
                        itemModel.unLock = ([[datas lastObject].stu_score floatValue]/[[datas lastObject].totlenumber floatValue] >= 0.8);                        itemModel.level = [NSString stringWithFormat:@"%ld",i+1];
                        itemModel.level = [NSString stringWithFormat:@"%ld",i+1];
                        [self.dataList addObject:itemModel];
                    } else {
                        QuickMemoryModel *itemModel = [[QuickMemoryModel alloc] init];
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
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([QuickMemoryCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:KQuickMemoryCollectionViewCellIdentifier];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
    }
    return _collectionView;
}

- (NSMutableArray<QuickMemoryModel*> *)dataList {
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
    return [self.dataList count];
}
//创建cell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QuickMemoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KQuickMemoryCollectionViewCellIdentifier forIndexPath:indexPath];
    
    cell.quickMemoryModel = self.dataList[indexPath.row];
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
    NSLog(@"点击了第%ld分item",(long)indexPath.item);
    
    QuickMemoryModel *itemModel = self.dataList[indexPath.row];
    if (itemModel.unLock) {
        QuickMemoryDetailViewController *detail = [[QuickMemoryDetailViewController alloc] init];
        detail.level = [itemModel.level integerValue];
        detail.gameModel = self.dataList[indexPath.row];
        KWeakSelf(self);
        detail.gameResultBlock = ^(BOOL isSuccess) {
            KStrongSelf(self);
            [self requestData];
        };
        [self presentViewController:detail animated:YES completion:nil];
    } else {
        QMLevelLockAlertViewController *alert = [QMLevelLockAlertViewController alertWithTitle:@"此题未解锁" headerImage:[UIImage imageNamed:@"quickMemory_lock_header"]];
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
