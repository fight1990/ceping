//
//  QuickMemoryCollectionViewCell.m
//  qiqiaoban
//
//  Created by Wei on 2019/8/11.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QuickMemoryCollectionViewCell.h"
#import "MacroDefinition.h"

NSString * const KQuickMemoryCollectionViewCellIdentifier = @"KQuickMemoryCollectionViewCellIdentifier";

@interface QuickMemoryCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIView *highlightView;
@property (weak, nonatomic) IBOutlet UIButton *titleView;
@property (weak, nonatomic) IBOutlet UILabel *digafixLabel_1;
@property (weak, nonatomic) IBOutlet UILabel *digafixLabel_2;
@property (weak, nonatomic) IBOutlet UIImageView *traffixLight_star;

@property (weak, nonatomic) IBOutlet UIView *darklightView;

@end

@implementation QuickMemoryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    CGFloat itemW = (KScreenWidth-(KLineNum+1.0)*KLineSpacing)/KLineNum - 20.0;
//    CGFloat itemW = 140.0f - 20.0;
    
    self.highlightView.layer.cornerRadius = itemW/2.0;
    self.digafixLabel_1.layer.cornerRadius = itemW/2*0.3;
    self.digafixLabel_2.layer.cornerRadius = itemW/2*0.3;
    self.darklightView.layer.cornerRadius = itemW/2.0;

    self.highlightView.hidden = YES;
    self.darklightView.hidden = NO;
}

- (void)setQuickMemoryModel:(QuickMemoryModel *)quickMemoryModel {
    _quickMemoryModel = quickMemoryModel;
    
    if (_quickMemoryModel.unLock == YES) {
        self.highlightView.hidden = NO;
        self.darklightView.hidden = YES;
    } else {
        self.highlightView.hidden = YES;
        self.darklightView.hidden = NO;
    }
    if (([_quickMemoryModel.stu_score integerValue] !=0) && [_quickMemoryModel.stu_score integerValue] == [_quickMemoryModel.totlenumber integerValue]) {
        self.traffixLight_star.image = [UIImage imageNamed:@"trafficLight_star_success"];
        self.digafixLabel_1.hidden = NO;
        self.digafixLabel_2.hidden = NO;
    } else if([_quickMemoryModel.stu_score floatValue] / [_quickMemoryModel.totlenumber floatValue] >= 0.8) {
        self.traffixLight_star.image = [UIImage imageNamed:@"trafficLight_star_fail"];
        self.digafixLabel_1.hidden = NO;
        self.digafixLabel_2.hidden = NO;
    } else {
        self.traffixLight_star.image = nil;
        self.digafixLabel_1.hidden = YES;
        self.digafixLabel_2.hidden = YES;
    }
    
    if ([_quickMemoryModel.level integerValue] == 21) {
        [self.titleView setTitle:[NSString stringWithFormat:@"无限模式"] forState:UIControlStateNormal];
        [self.titleView setImage:nil forState:UIControlStateNormal];
        
    } else {
        [self.titleView setTitle:nil forState:UIControlStateNormal];
        [self.titleView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"mg_%@",_quickMemoryModel.level]] forState:UIControlStateNormal];
    }
    
    self.digafixLabel_1.text = [NSString stringWithFormat:@"%ld",[_quickMemoryModel.used_times integerValue]];
    self.digafixLabel_2.text = [NSString stringWithFormat:@"%ld",[_quickMemoryModel.stu_score integerValue]];
}

@end
