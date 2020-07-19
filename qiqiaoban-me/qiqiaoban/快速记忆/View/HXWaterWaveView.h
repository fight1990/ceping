//
//  HXWaterWaveView.h
//  qiqiaoban
//
//  Created by Wei on 2019/8/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HXWaterWaveView : UIView

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL hiddenTitle;

- (void)setPeakType:(NSInteger)peakType byType:(NSInteger)byType peakCount:(NSInteger)peakCount colors:(NSArray<UIColor*>*)colors;
- (void)startAnimationPlay;
- (void)initInfo;
- (void)removeDisplayLinkAction;
@end

NS_ASSUME_NONNULL_END
