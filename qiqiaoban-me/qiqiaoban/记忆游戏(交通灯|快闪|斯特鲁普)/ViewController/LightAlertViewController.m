//
//  LightAlertViewController.m
//  qiqiaoban
//
//  Created by Wei on 2019/8/18.
//  Copyright © 2019 mac. All rights reserved.
//

#import "LightAlertViewController.h"
#import <Masonry/Masonry.h>
#import "MacroDefinition.h"

@interface LightAlertViewController ()<LightAlertDelegate>

@property (nonatomic ,copy) NSString *alertTitle;
@property (nonatomic ,copy) NSString *alertContent;

@property(nonatomic ,strong) UIView *backgroundView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic ,strong) UIButton *closeButton;

@property(nonatomic ,strong) UIImageView *starImageView_1;
@property(nonatomic ,strong) UIImageView *starImageView_2;
@property(nonatomic ,strong) UIImageView *starImageView_3;

@property(nonatomic ,strong) UILabel *titleLabel;
@property(nonatomic ,strong) UILabel *contentLabel;

@property(nonatomic ,strong) NSMutableArray *actionArray;
@end

@implementation LightAlertViewController
+(instancetype)alertWithTitle:(NSString *)title andContent:(NSString *)content{
    
    return [[LightAlertViewController alloc] initWithTitle:title andContent:content];
}

-(instancetype)initWithTitle:(NSString *)title andContent:(NSString *)content{
    self = [super init];
    if(self){
        self.modalPresentationStyle=UIModalPresentationOverCurrentContext;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        _alertTitle = title;
        _alertContent = content;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.backgroundView];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.closeButton];
    
    [self.contentView addSubview:self.starImageView_1];
    [self.contentView addSubview:self.starImageView_2];
    [self.contentView addSubview:self.starImageView_3];

    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    
    for (LightAlertViewItem * btn in self.actionArray) {
        [self.contentView addSubview:btn];
    }
    
    [self makeConstraints];
}


- (void)makeConstraints {
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.5f);
        make.bottom.equalTo(self.contentLabel.mas_bottom).offset(120);
    }];
    
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.starImageView_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starImageView_2.mas_centerY);
        make.right.equalTo(self.starImageView_2.mas_left).offset(-25);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.starImageView_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(-25);
        make.size.mas_equalTo(CGSizeMake(120, 120));
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.starImageView_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starImageView_2.mas_centerY);
        make.left.equalTo(self.starImageView_2.mas_right).offset(25);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.starImageView_2.mas_bottom).offset(45);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(25);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    if ([self.actionArray count] > 1) {
        [self.actionArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20 leadSpacing:20 tailSpacing:20];
        [self.actionArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).offset(30);
            make.height.equalTo(@60);
        }];
    } else {
        [[self.actionArray firstObject] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.width.equalTo(self.contentView.mas_width).multipliedBy(0.7f);
            make.top.equalTo(self.contentLabel.mas_bottom).offset(30);
            make.height.equalTo(@60);
        }];
    }
}

- (void)setAlertAttributedContent:(NSAttributedString *)alertAttributedContent {
    _alertAttributedContent = alertAttributedContent;
    self.contentLabel.attributedText = _alertAttributedContent;
}

- (void)setResultScore:(NSInteger)resultScore {
    _resultScore = resultScore;
    if (_resultScore >= 3) {
        self.starImageView_1.image = [UIImage imageNamed:@"trafficLight_star_highlight"];
        self.starImageView_2.image = [UIImage imageNamed:@"trafficLight_star_highlight"];
        self.starImageView_3.image = [UIImage imageNamed:@"trafficLight_star_highlight"];
    } else if (_resultScore == 2) {
        self.starImageView_1.image = [UIImage imageNamed:@"trafficLight_star_highlight"];
        self.starImageView_2.image = [UIImage imageNamed:@"trafficLight_star_highlight"];
        self.starImageView_3.image = [UIImage imageNamed:@"trafficLight_star_normal"];
    } else if (_resultScore == 1) {
        self.starImageView_1.image = [UIImage imageNamed:@"trafficLight_star_highlight"];
        self.starImageView_2.image = [UIImage imageNamed:@"trafficLight_star_normal"];
        self.starImageView_3.image = [UIImage imageNamed:@"trafficLight_star_normal"];
    } else {
        self.starImageView_1.image = [UIImage imageNamed:@"trafficLight_star_normal"];
        self.starImageView_2.image = [UIImage imageNamed:@"trafficLight_star_normal"];
        self.starImageView_3.image = [UIImage imageNamed:@"trafficLight_star_normal"];
    }
}

#pragma mark Getting && Setting
- (UIImageView *)starImageView_1 {
    if (!_starImageView_1) {
        _starImageView_1 = [[UIImageView alloc] init];
        _starImageView_1.image = [UIImage imageNamed:@"trafficLight_star_normal"];
        _starImageView_1.transform = CGAffineTransformMakeRotation(-M_PI_4);
    }
    return _starImageView_1;
}

- (UIImageView *)starImageView_2 {
    if (!_starImageView_2) {
        _starImageView_2 = [[UIImageView alloc] init];
        _starImageView_2.image = [UIImage imageNamed:@"trafficLight_star_normal"];
    }
    return _starImageView_2;
}

- (UIImageView *)starImageView_3 {
    if (!_starImageView_3) {
        _starImageView_3 = [[UIImageView alloc] init];
        _starImageView_3.image = [UIImage imageNamed:@"trafficLight_star_normal"];
        _starImageView_3.transform = CGAffineTransformMakeRotation(M_PI_4);
    }
    return _starImageView_3;
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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = self.alertTitle;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:45];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = self.alertContent;
        _contentLabel.textColor = UIColorFromRGB(0x1DA7E8);
        _contentLabel.font = [UIFont systemFontOfSize:30];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"trafficLight_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

-(NSMutableArray *)actionArray{
    if(_actionArray == nil){
        _actionArray = [[NSMutableArray alloc] init];
    }
    return _actionArray;
}


-(void)addAction:(LightAlertAction *)action{
    LightAlertViewItem * item = [[LightAlertViewItem alloc] init];
    item.text = action.title;
    item.font = [UIFont boldSystemFontOfSize:20.0f];
    item.textColor = action.titleColor;
    item.backgroundColor = action.backgroundColor;
    item.layer.cornerRadius = 30.0f;
    item.layer.borderColor = action.titleColor.CGColor;
    item.layer.borderWidth = 1.0f;
    item.layer.masksToBounds = YES;
    item.handle = action.handle;
    item.delegate = self;
    [self.actionArray addObject:item];
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


-(void)dealloc{
    NSLog(@"shifang");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


#pragma mark ============弹窗Action============
@implementation LightAlertAction
+(instancetype)actionWithTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andBackgroundColor:(UIColor*)backgroundColor action:(LightAlertActionBlock)handel{
    return [[LightAlertAction alloc] initWithTitle:title andTitleColor:titleColor andBackgroundColor:backgroundColor action:handel];
}

-(instancetype)initWithTitle:(NSString *)title andTitleColor:(UIColor *)titleColor andBackgroundColor:(UIColor*)backgroundColor action:(LightAlertActionBlock)handel{
    self = [super init];
    if(self){
        _title = title;
        _titleColor = titleColor;
        _backgroundColor = backgroundColor;
        _handle = handel;
    }
    return self;
}


@end
#pragma mark ============弹窗Item============
@implementation LightAlertViewItem
-(instancetype)init{
    self = [super init];
    if(self){
        self.textAlignment = NSTextAlignmentCenter;
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction)]];
    }
    return self;
}


-(void)clickAction{
    [self.delegate clickItem];
    if(self.handle){
        self.handle();
    }
}
@end

