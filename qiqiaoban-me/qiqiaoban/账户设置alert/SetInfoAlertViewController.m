//
//  SetInfoAlertViewController.m
//  qiqiaoban
//
//  Created by mac on 2019/3/21.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "SetInfoAlertViewController.h"

#import <Masonry.h>

#import "loginViewController.h"

#import "StuInfoShowTableViewCell.h"

#import "JSEDefine.h"

#import "CGXPickerView.h"

#import "NSDate+Extention.h"

#import "JSStudentInfoManager.h"

#define cellHeight 60

#define containHeight self.view.frame.size.height * .6

@interface SetInfoAlertViewController ()<UITableViewDelegate,UITableViewDataSource>


//存放的view
@property (nonatomic,retain) UIView *containView;

@property (nonatomic,retain) UILabel *titleLabel;

@property (nonatomic,retain) UIImageView *headImageView;

@property (nonatomic,retain) UITableView *mainTableView;
//大一点的退出按钮.
@property (nonatomic,retain) UIButton *bigButton;

@property (nonatomic,retain) UIButton *smallButton;

@property (nonatomic,retain) UIView *containDateView;

@end

@implementation SetInfoAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentStuInfo = [JSStudentInfoManager manager].basicInfo;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.7];
    
    
    [self setUpContainView];
    
    [self setUpAll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpContainView{
    
    UIView *view = [[UIView alloc] init];
    
    [self.view addSubview:view];
    
    view.backgroundColor = [UIColor whiteColor];
    
    view.layer.cornerRadius = 10;
    
    view.layer.masksToBounds = YES;
    
    self.containView = view;

    view.width = self.view.width / 1.4;
    
    view.height = containHeight;
    
    
    view.centerX = self.view.width * .5;
    
    view.centerY = self.view.height * .5;
}

-(void)setUpAll{
    
    UILabel *label = [[UILabel alloc] init];
    
    label.backgroundColor = JSMainDarkPuer;
    
    label.textColor = [UIColor whiteColor];
    
    label.text = @"账户设置";
    
    label.font = JSBold(20);
    
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.containView addSubview:label];
    
    self.titleLabel = label;
    
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerX.mas_equalTo(self.view);
//        
//        make.top.left.right.mas_equalTo(self.containView);
//        
//        make.bottom.mas_equalTo(self.containView.mas_top).offset(50);
//    }];

    self.titleLabel.width = self.containView.width;
    self.titleLabel.height = 50;
    self.titleLabel.x = self.titleLabel.y = 0;
    
    
    //创建小得退出按钮.
    
    UIButton *sbutton = [[UIButton alloc] init];
    
    self.smallButton = sbutton;
    
    sbutton.width = 27;
    
    sbutton.height = 27;
    
    sbutton.x = self.containView.width - 50;
    
    sbutton.centerY = self.titleLabel.height * .5;;
    
    [sbutton setBackgroundColor:[UIColor clearColor]];
    
//    [sbutton setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    
    [sbutton setBackgroundImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
    
    sbutton.imageView.contentMode = UIViewContentModeCenter;
    
    [self.containView addSubview:sbutton];
    
    [sbutton addTarget:self action:@selector(touchToClose:) forControlEvents:UIControlEventTouchUpInside];

    
    //创建头像.
    
    UIImageView *imageView = [[UIImageView alloc] init];
    
    imageView.layer.cornerRadius = 50;
    
    imageView.layer.masksToBounds = YES;
    
    imageView.image = [UIImage imageNamed:@"u159"];
    
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    imageView.layer.borderColor = JSColor(51, 51, 51, 1).CGColor;
    
    imageView.layer.borderWidth = 1;
    
    [self.containView addSubview:imageView];
    
    self.headImageView = imageView;
    
    self.headImageView.width = self.headImageView.height = 100;
    
    self.headImageView.centerX = self.containView.width * .5;
    
    self.headImageView.y = CGRectGetMaxY(self.titleLabel.frame) + 20;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 190, self.view.width/1.4, 300) style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    self.mainTableView = tableView;
    tableView.scrollEnabled = NO;
    [self.containView addSubview:self.mainTableView];
    
    
    
    //退出的button
    
    UIButton *button = [[UIButton alloc] init];
    self.bigButton = button;
    
    button.width = self.containView.width * .8;
    
    button.height = 55;
    
    button.centerX = self.mainTableView.centerX;
    
    button.y = self.containView.height - 75;
    
    [button setBackgroundColor:JSMainBlueColor];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [button setTitle:@"退出" forState:UIControlStateNormal];
    
    [self.containView addSubview:button];
    
    [button addTarget:self action:@selector(touchToQuiteStu:) forControlEvents:UIControlEventTouchUpInside];
    
    button.hidden = YES;
    
}


//关闭窗口
-(void)touchToClose:(UIButton *)sender{

    [self.view removeFromSuperview];
    
}

//退出账户
-(void)touchToQuiteStu:(UIButton *)sender{
    
    loginViewController *loginView = [[loginViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = loginView;
    
}

#pragma mark - tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StuInfoShowTableViewCell *cell = [StuInfoShowTableViewCell cellForTableview:tableView];
    return cell;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 60;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    StuInfoShowTableViewCell *TrueCell = (StuInfoShowTableViewCell *)cell;
    
    [TrueCell showForModel:self.currentStuInfo andCount:indexPath.row andCellWidth:self.view.width / 1.4];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakObject(self);
    if (indexPath.row == 2) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [selfWeak setUpDatePiker];
        selfWeak.containDateView.transform = CGAffineTransformMakeTranslation(0, self.containDateView.height);
        [selfWeak.view addSubview:self.containDateView];
        [UIView animateWithDuration:0.4 animations:^{
           
            selfWeak.containDateView.transform = CGAffineTransformIdentity;
            
        }];
        
    }
    
}

-(void)setUpDatePiker{

    UIView *back = [[UIView alloc] init];
    back.backgroundColor = [UIColor whiteColor];
    back.frame = CGRectMake(0, JSFrame.size.height * .78, JSFrame.size.width, JSFrame.size.height * .22);
    
    self.containDateView = back;
    
        
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    //设置地区: zh-中国
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        
    //设置日期模式(Displays month, day, and year depending on the locale setting)
    datePicker.datePickerMode = UIDatePickerModeDate;
    // 设置当前显示时间
    [datePicker setDate:[NSDate date] animated:YES];
    // 设置显示最大时间（此处为当前时间）
    [datePicker setMaximumDate:[NSDate date]];

    //设置时间格式
    
    //监听DataPicker的滚动
    [datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    
    datePicker.frame = CGRectMake(0, 50, JSFrame.size.width, self.containDateView.height - 60);
    
    [self.containDateView addSubview:datePicker];
    
    
    //创建两个按钮.
    UIButton *button = [[UIButton alloc] init];

    button.width = 50;
    
    button.height = 50;
    
    button.x = 50;
    
    button.y = 0;
    
    [button setBackgroundColor:[UIColor clearColor]];
    
    button.contentMode = UIViewContentModeCenter;
    
    [button setTitleColor:JSLikeBlackColor forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
//    [button setTitle:@"关闭" forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageNamed:@"guanbi2"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"guanbi2"] forState:UIControlStateNormal];
    
    button.titleLabel.font = JSFont(20);
    
    [button addTarget:self action:@selector(touchCloseSickDate:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *button1 = [[UIButton alloc] init];
    
    button1.width = 50;
    
    button1.height = 50;
    
    button1.x = self.containDateView.width - 100;
    
    button1.y = 0;
    
    button1.imageView.contentMode = UIViewContentModeCenter;
    
    button1.titleLabel.font = JSFont(20);
    
    [button1 setBackgroundColor:[UIColor clearColor]];
    
    [button1 setTitleColor:JSLikeBlackColor forState:UIControlStateNormal];
    
    [button1 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
//    [button1 setTitle:@"确定" forState:UIControlStateNormal];
    
//    [button1 setBackgroundImage:[UIImage imageNamed:@"queding"] forState:UIControlStateNormal];
    
    
    [button1 setImage:[UIImage imageNamed:@"queding"] forState:UIControlStateNormal];
    
    [button1 addTarget:self action:@selector(touchSureDate:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.containDateView addSubview:button];
    
    [self.containDateView addSubview:button1];
}


//取消了选择年龄
-(void)touchCloseSickDate:(UIButton *)sender{

    [self.containDateView removeFromSuperview];
    
}

-(void)dateChange:(UIDatePicker *)datePiker{

    self.currentStuInfo.birthday = [datePiker.date dateToYearMothDayStr];
    
}

//确认了年龄
-(void)touchSureDate:(UIButton *)sender{
    
    [self.containDateView removeFromSuperview];
    
 
    [self.mainTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:0];
    
    if ([self.delegate respondsToSelector:@selector(SetInfoAlertViewController:didSetBirthday:)]) {
        [self.delegate SetInfoAlertViewController:self didSetBirthday:self.currentStuInfo.birthday];
    }
    
}

-(void)dealloc{
    
    NSLog(@"显示用户信息的页面解放");
    
    
}

@end
