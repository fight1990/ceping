//
//  SymbolNumberVC.h
//  QiQiaoBan
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface SymbolNumberVC : UIViewController

@property (nonatomic,assign) NSInteger queAmount;
@property (nonatomic,assign) NSInteger queSeconds;
@property (nonatomic,assign) NSInteger titleNum;

-(void)goToRootview;

@end

NS_ASSUME_NONNULL_END
