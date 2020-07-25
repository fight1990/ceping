//
//  QMLevelLockAlertViewController.m
//  qiqiaoban
//
//  Created by Wei on 2019/8/26.
//  Copyright © 2019 mac. All rights reserved.
//

#import "QMLevelLockAlertViewController.h"
#import <Masonry/Masonry.h>
#import "MacroDefinition.h"

@interface QMLevelLockAlertViewController ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIButton *titleView;

@property (nonatomic, strong) NSString *alertTitle;
@property (nonatomic, strong) UIImage *alertHeaderImage;

@end

@implementation QMLevelLockAlertViewController

+(instancetype)alertWithTitle:(NSString *)title headerImage:(UIImage*)headerImage {
    return [[QMLevelLockAlertViewController alloc] initWithTitle:title headerImage:headerImage];
}

- (instancetype)initWithTitle:(NSString *)title headerImage:(UIImage*)headerImage {
    self = [super init];
    if (self) {
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        _alertTitle = title;
        _alertHeaderImage = headerImage;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.contentView];
    
    [self.contentView addSubview:self.headerImageView];
    [self.contentView addSubview:self.closeButton];

    [self.contentView addSubview:self.titleView];
    
    [self makeConstraints];
}


- (void)makeConstraints {
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.5f);
        make.height.equalTo(self.view.mas_width).multipliedBy(0.5f);
    }];
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.equalTo(self.contentView.mas_width).multipliedBy(0.44f);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView.mas_bottom).offset(50);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.backgroundColor = [UIColor blackColor];
        _backgroundView.alpha = 0.5;
    }
    return _backgroundView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 15.0f;
    }
    return _contentView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"trafficLight_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

- (UIImageView *)headerImageView {
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.image = _alertHeaderImage;
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerImageView;
}

- (UIButton *)titleView {
    if (!_titleView) {
        _titleView = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleView.userInteractionEnabled = NO;
        _titleView.titleLabel.font = [UIFont boldSystemFontOfSize:38.0f];
        [_titleView setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [_titleView setTitle:self.alertTitle forState:UIControlStateNormal];
    }
    return _titleView;
}

- (void)closeView {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.closeHandle) {
            self.closeHandle();
        }
    }];
}

-(void)clickItem{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
