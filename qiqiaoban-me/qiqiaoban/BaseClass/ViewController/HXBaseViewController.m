//
//  HXBaseViewController.m
//  qiqiaoban
//
//  Created by Wei on 2019/8/11.
//  Copyright © 2019 mac. All rights reserved.
//

#import "HXBaseViewController.h"
#import "INetworking.h"
#import "JSEDefine.h"
#import "JSAlertView.h"

@interface HXBaseViewController ()
@property (strong, nonatomic) UIButton *backBtn;

@end

@implementation HXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.navigationBarView];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.titleLabel];
    
}

#pragma mark Getting && Setting
- (UIView *)navigationBarView {
    if (!_navigationBarView) {
       _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JSFrame.size.width, KNavigationBar_Height)];
        [_navigationBarView setBackgroundColor:[UIColor whiteColor]];
        
        UIView *lineView = [[UIView alloc] init];
        lineView.frame = CGRectMake(0, KNavigationBar_Height-1, JSFrame.size.width, 1);
        lineView.backgroundColor = JSLikeBlackColor;
        [_navigationBarView addSubview:lineView];
    }
    return _navigationBarView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
        [_backBtn sizeToFit];
        _backBtn.width = _backBtn.width * .7;
        _backBtn.height = _backBtn.height * .7;
        _backBtn.centerY = 50;
        _backBtn.x = 15;
        [_backBtn addTarget:self action:@selector(backBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = JSBold(25);
        _titleLabel.textColor = JSLikeBlackColor;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.width = JSFrame.size.width * .6;
        _titleLabel.height = 50;
        _titleLabel.centerX = self.view.width * .5;
        _titleLabel.centerY = 50;
    }
    return _titleLabel;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    }
    return _backgroundImageView;
}

#pragma mark PrivateMethod
- (void)backBtnAction:(UIButton*)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
