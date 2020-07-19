//
//  ShowMainViewController.m
//  qiqiaoban
//
//  Created by mac on 2019/3/20.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ShowMainViewController.h"

#import "UIView+Frame.h"

#import "JSEDefine.h"

#import "SetInfoAlertViewController.h"

#import "JSStudentInfoManager.h"

#import "ViewController.h"

#import "loginViewController.h"

#import "INetworking.h"

#import "JSStudentInfoManager.h"

#import "NSString+Bounding.h"

#import "SDViewController.h"

#import "QueBankCell.h"

#import "SymbolNumberChooseVC.h"

#import "MemoryGameViewController.h"
#import "QuickMemoryViewController.h"

#import "ImageSelectViewController.h"

//显示学生数据的页面.

@interface ShowMainViewController ()<SetInfoAlertViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)UIView *cellContentView;
@property (nonatomic,assign)NSInteger indexPath_row;

@property (nonatomic,strong)UILabel *levelLabel;
@property (nonatomic,strong)UILabel *scoreLabel;

//头像图片
@property (nonatomic,retain) UIImageView *headImageView;

//显示名称的label
@property (nonatomic,retain) UILabel *loginNameLabel;

//切换学生账号的按钮.
@property (nonatomic,retain) UIButton *changeStuButton;

//设置个人信息的 弹出窗口.
@property (nonatomic,retain) UIViewController *alertController;

//提示去设置年龄的 弹出窗口.
@property (nonatomic,retain) UIView *alertViewToSet;


//下面都是放置于 tapshow里面

@property (nonatomic,retain) UIView *tapShowView;
@property (nonatomic,retain) UILabel *showFenshuLabel;
@property (nonatomic,retain) UILabel *showLevelLabel;
@property (nonatomic,retain) UIButton *beganGameButton;


@property (nonatomic,copy) NSString *qqbFenshu;
@property (nonatomic,copy) NSString *qqbLevel;
@property (nonatomic,copy) NSString *sdFenshu;
@property (nonatomic,copy) NSString *sdLevel;

@end

@implementation ShowMainViewController



static NSString *const cellId = @"cellId";
static NSTimeInterval kAnimationDuration = 0.3;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    [self setUpView];
    [self checkAge];
    [self setUpTapView];
    [self loadCollectionView];
}
//创建单元格
- (void)loadCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
    //该方法也可以设置itemSize
    layout.itemSize =CGSizeMake(200, 150);
    
    
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxX(self.headImageView.frame) + 60, KScreenWidth, KScreenHeight-60) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[QueBankCell class] forCellWithReuseIdentifier:cellId];
    
    _cellContentView =[UIView new];
    _cellContentView.layer.borderWidth = 2.0f;
    _cellContentView.layer.borderColor  = CommonlyUsedColor.CGColor;
    _cellContentView.layer.cornerRadius =10;
    
    _levelLabel =[UILabel new];
    self.levelLabel.textAlignment =NSTextAlignmentCenter;
    _scoreLabel =[UILabel new];
    self.scoreLabel.textAlignment =NSTextAlignmentCenter;
    [_cellContentView addSubview:self.levelLabel];
    [_cellContentView addSubview:self.scoreLabel];
    
    _cellContentView.hidden =YES;
    [self.collectionView addSubview:_cellContentView];
    
}


#pragma mark --UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    QueBankCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.backgroundColor =[UIColor clearColor];
    cell.layer.borderWidth = 2.0f;
    cell.layer.borderColor  = [UIColor lightGrayColor].CGColor;
    cell.layer.cornerRadius =10;
    NSArray *ary =@[@"beijingtu1",@"beijingtu2",@"beijingnew",@"beijingnew",@"beijingnew",@"beijingnew",@"beijingnew",@"beijingnew",@"beijingnew",@"beijingnew"];
    cell.backgroundView.image =[UIImage imageNamed:ary[indexPath.row]];
    
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((KScreenWidth-90)/2, 200);
}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(30, 30, 0, 30);
}

#pragma mark --UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //cell在当前collection的位置
    CGRect cellRect = [_collectionView convertRect:cell.frame toView:_collectionView];
    //    NSLog(@"点击--%ld",(long)indexPath.row);
    
    _indexPath_row =indexPath.row;
    _cellContentView.frame =CGRectMake(cellRect.origin.x,cellRect.origin.y,cellRect.size.width,200);
    _cellContentView.backgroundColor =[UIColor whiteColor];
    
    UIButton *backgroundBtn =[UIButton buttonWithType:0];
    backgroundBtn.backgroundColor =[UIColor clearColor];
    backgroundBtn.frame =CGRectMake(0,0,cellRect.size.width,200);
    [backgroundBtn addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchDown];
    [_cellContentView addSubview:backgroundBtn];

    self.levelLabel.frame=CGRectMake(40, 60, cellRect.size.width-80, 40);
    self.scoreLabel.frame =CGRectMake(40, 15, cellRect.size.width-80, 40);
    if (indexPath.row ==0) {
       self.levelLabel.text =self.qqbLevel;
       self.scoreLabel.text =self.qqbFenshu;
    }else if (indexPath.row ==1){
        self.levelLabel.text =self.sdLevel;
        self.scoreLabel.text =self.sdFenshu;
    }else{
        self.levelLabel.text =@"";
        self.scoreLabel.text =@"";
    }
    
    UIButton *btn2 =[UIButton buttonWithType:0];
    btn2.frame =CGRectMake(40,115,cellRect.size.width-80,50);
    btn2.layer.cornerRadius =25;
    if ([JSStudentInfoManager manager].isOverShudu) {
        [btn2 setTitle:@"答题结束" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn2.backgroundColor =[UIColor grayColor];
    }else{
        [btn2 setTitle:@"开 始" forState:UIControlStateNormal];
        [btn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn2.backgroundColor =CommonlyUsedColor;
    }
    
    
    [btn2 addTarget:self action:@selector(questionBank) forControlEvents:UIControlEventTouchDown];
    [_cellContentView addSubview:btn2];
    
    _cellContentView.hidden = YES;
    [UIView transitionWithView:_cellContentView duration:kAnimationDuration
                       options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                           self.cellContentView.hidden =NO;
                       } completion:^(BOOL finished) {
                           
                       }];
    
    
    //******* 临时游戏跳转 **********//
    
    switch (indexPath.row) {
        case 4:
            [self tapJiaoTongDeng];
            break;
        case 5:
            [self tapKuaiShanDeng];
            break;
        case 6:
            [self tapSiTeLuPu];
            break;
        case 7:
            [self tapKuaiSuJiYi];
            break;
        default:
            break;
    }
    
}

-(void)hiddenView{
    [UIView animateWithDuration:0.3 animations:^{
        
        self.cellContentView.hidden =YES;
        
    }];
    
}

-(void)questionBank{
    if (![JSStudentInfoManager manager].isSetAge) {
        //没有设置年龄
        [self.view addSubview:self.alertViewToSet];
        return;
    }
    
    if (([JSStudentInfoManager manager].isOverToday&&self.beganGameButton.tag == 1) || (self.beganGameButton.tag == 2 && [JSStudentInfoManager manager].isOverShudu)) {
        return;
    }
    
    if (_indexPath_row ==0) {

        ViewController *vc = [[ViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];

    }else if (_indexPath_row==1){
        
        SDViewController *vc = [[SDViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
        
    }else if (_indexPath_row==2){
        
        SymbolNumberChooseVC *vc =[[SymbolNumberChooseVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (_indexPath_row==3){
        
        ImageSelectViewController *vc = [[ImageSelectViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    //多次吧
    
    JSLog(@"读取当前的得分和等级");
    
    [self ShowCurrentLevel];
    
    [self GetCurrentScore];
    
}

//在此处对学生的进行进行整理
-(void)checkAge{
    
    JSStudentInfoManager *manager = [JSStudentInfoManager manager];
    //如果当前没有年龄.
    if (!manager.isSetAge) {
        
        
        UIView *view = [[UIView alloc] init];
        
        view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        
        view.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.7];
        
        UIImageView *planImageView = [[UIImageView alloc] init];
        //        planImageView
        planImageView.image = [UIImage imageNamed:@"plan"];
        
        [planImageView sizeToFit];
        
        CGFloat scale = 240.0 / planImageView.height;
        
        planImageView.height = 240;
        planImageView.width = planImageView.width * scale;
        
        planImageView.centerX = view.width * .5;
        
        planImageView.y = view.height * .3;
        
        [view addSubview:planImageView];
        
        UIView *containView = [[UIView alloc] init];
        
        containView.width = 420;
        
        containView.height = 220;
        
        containView.backgroundColor = JSColor(51, 51, 51, 1);
        
        containView.layer.cornerRadius = 10;
        
        containView.layer.masksToBounds = YES;
        
        
        containView.centerX = self.view.width * .5;
        
        containView.y = CGRectGetMaxY(planImageView.frame) - 23;
        
        UIImageView *back = [[UIImageView alloc] init];
        
        back.frame = CGRectMake(0, 0, containView.width, containView.height - 40);
        
        back.image = [UIImage imageNamed:@"tu1"];
        
        [containView addSubview:back];
        
        UIButton *button1 = [[UIButton alloc] init];
        
        button1.width = containView.width * .5;
        
        button1.height = 50;
        
        button1.x = 0;
        
        button1.y = containView.height - 50;
        
        [button1 setBackgroundColor:[UIColor whiteColor]];
        
        [button1 setTitleColor:JSMainPuer forState:UIControlStateNormal];
        
        [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        [button1 setTitle:@"取消" forState:UIControlStateNormal];
        
        [button1 addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *button2 = [[UIButton alloc] init];
        
        button2.width = containView.width * .5;
        
        button2.height = 50;
        
        button2.x = containView.width * .5;
        
        button2.y = containView.height - 50;
        
        [button2 setBackgroundColor:JSMainDarkPuer];
        
        [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        [button2 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        [button2 setTitle:@"去设置" forState:UIControlStateNormal];
        
        [button2 addTarget:self action:@selector(goToSetAge:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        UILabel *label = [[UILabel alloc] init];
        
        label.font = JSBold(40);
        
        label.text = @"年龄未设置";
        
        label.textColor = JSMainDarkPuer;
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.width = containView.width;
        
        label.height = containView.height - 50;
        
        label.numberOfLines = 1;
        
        
        [containView addSubview:label];
        
        [containView addSubview:button1];
        
        [containView addSubview:button2];
        
        [view addSubview:containView];
        
        [self.view addSubview:view];
        
        self.alertViewToSet = view;
        
    }
    
}


//当点击某一个模块之后显示的view
-(void)setUpTapView{
    
    UIView *view = [[UIView alloc] init];
    view.width = (JSFrame.size.width - 100) / 2;
    view.height = view.width * .58;
    view.backgroundColor = [UIColor whiteColor];
    
    view.layer.cornerRadius = 5;
    view.layer.borderColor = JSMainDarkPuer.CGColor;
    view.layer.borderWidth = 1;
    view.layer.masksToBounds = YES;
    
    self.tapShowView = view;
    
    
    //显示当前分数的label
    UILabel *showFenLabel = [[UILabel alloc] init];
    showFenLabel.font = JSFont(17);
    showFenLabel.textColor = JSLikeBlackColor;
    showFenLabel.backgroundColor = [UIColor whiteColor];
    showFenLabel.textAlignment = NSTextAlignmentCenter;
    showFenLabel.numberOfLines = 1;
    showFenLabel.text = @"前十题得分:0";
    showFenLabel.width = view.width;
    showFenLabel.height = 30;
    showFenLabel.y = 25;
    showFenLabel.centerX = view.width * .5;
    [view addSubview:showFenLabel];
    self.showFenshuLabel = showFenLabel;
    
    
    //    //显示当前难度的按钮.
    //    @property (nonatomic,retain) UILabel *showLevelTitleLabel;
    UILabel *showLevelTitleLabel = [[UILabel alloc] init];
    showLevelTitleLabel.font = JSFont(20);
    showLevelTitleLabel.textColor = JSLikeBlackColor;
    showLevelTitleLabel.backgroundColor = [UIColor whiteColor];
    showLevelTitleLabel.textAlignment = NSTextAlignmentCenter;
    showLevelTitleLabel.numberOfLines = 1;
    showLevelTitleLabel.width = view.width;
    showLevelTitleLabel.height = 30;
    showLevelTitleLabel.x = 0;
    showLevelTitleLabel.y = CGRectGetMaxY(self.showFenshuLabel.frame) + 8;
    showLevelTitleLabel.text = @"level 3";
        //这里没有年龄就直接显示 年龄未设置.
    if (![[JSStudentInfoManager manager].basicInfo.birthday isKindOfClass:[NSString  class]] || [JSStudentInfoManager manager].basicInfo.birthday.length) {
        NSString *str = @"年龄未设置";
        showLevelTitleLabel.attributedText = [str attributedStringWithLineSpace:0 andWordSpace:3 andFont:JSFont(33)];
    }
    [self.tapShowView addSubview:showLevelTitleLabel];
    self.showLevelLabel = showLevelTitleLabel;
    
    //开始游戏的按钮.
    UIButton *beganGameButton = [[UIButton alloc] init];
    [beganGameButton setTitle:@"开 始" forState:UIControlStateNormal];
    [beganGameButton setBackgroundColor:JSMainDarkPuer];
    beganGameButton.titleLabel.font = JSBold(25);
    [beganGameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [beganGameButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    beganGameButton.width = view.width - 100;
    beganGameButton.height = 50;
    beganGameButton.centerX = view.width * .5;
    beganGameButton.y = CGRectGetMaxY(self.showLevelLabel.frame) + 10;
    beganGameButton.layer.cornerRadius = 25;
    beganGameButton.layer.masksToBounds = YES;
    self.beganGameButton = beganGameButton;
    [self.tapShowView addSubview:beganGameButton];
    [beganGameButton addTarget:self action:@selector(touchToBeganGame:) forControlEvents:UIControlEventTouchUpInside];

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)];
    [self.tapShowView addGestureRecognizer:tap];
}

-(void)removeSelf{
    
    [self.tapShowView removeFromSuperview];
    
}


//取消设置年龄的 按钮方法.
-(void)cancel:(UIButton *)sender{
    
    [self.alertViewToSet removeFromSuperview];
    
}

//去设置年龄的 按钮方法.
-(void)goToSetAge:(UIButton *)sender{
    
    //移除当前窗口.
    [self.alertViewToSet removeFromSuperview];
    
    //显示信息页面.
    [self showStuInfo];
    
}


//对所有的view进行创建和初始化.
-(void)setUpView{
    //显示背景的view
    
    UIImageView *image = [[UIImageView alloc] init];
    image.frame = self.view.bounds;
    image.image = [UIImage imageNamed:@"beijing"];
    [self.view addSubview:image];
    
    
    //    //显示名称的label
    //    @property (nonatomic,retain) UILabel *loginNameLabel;
    
    UILabel *nameLabel = [[UILabel alloc] init];
    
    nameLabel.font = JSFont(20);
    
    nameLabel.textColor = JSLikeBlackColor;
    
    nameLabel.backgroundColor = JSMainPuer;
    
    nameLabel.frame = CGRectMake(0, 0, 190, 40);
    
    nameLabel.layer.cornerRadius = 20;
    
    nameLabel.layer.masksToBounds = YES;
    
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    nameLabel.text = [JSStudentInfoManager manager].basicInfo.stuName;
    
    nameLabel.centerY = 100;
    
    nameLabel.x = 90;
    
    [self.view addSubview:nameLabel];
    
    self.loginNameLabel = nameLabel;
    
    //    //头像图片
    //    @property (nonatomic,retain) UIImageView *headImageView;
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    
    headImageView.frame = CGRectMake(0, 0, 64, 64);
    
    headImageView.layer.cornerRadius = 32;
    
    headImageView.layer.masksToBounds = YES;
    
    headImageView.layer.borderWidth = 1;
    
    headImageView.layer.borderColor = JSMainDarkPuer.CGColor;
    
    headImageView.centerY = 100;
    
    headImageView.x = 48;
    
    headImageView.image = [UIImage imageNamed:@"touxiang"];
    
    [self.view addSubview:headImageView];
    
    self.headImageView = headImageView;
    
    
    
    
    
    
    
    
    
    
    // 添加 个人信息的手势.
    
    
    UITapGestureRecognizer *tapToShowInfoForLabel =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToAge:)];
    
    UITapGestureRecognizer *tapToShowInfoForImage =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToAge:)];
    
    self.headImageView.userInteractionEnabled = YES;
    
    self.loginNameLabel.userInteractionEnabled = YES;
    
    [self.headImageView addGestureRecognizer:tapToShowInfoForLabel];
    
    [self.loginNameLabel addGestureRecognizer:tapToShowInfoForImage];
    
    
    
    //
    //    //切换学生账号的按钮.
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:[UIImage imageNamed:@"tuichu"] forState:UIControlStateNormal];
    
    button.frame = CGRectMake(JSFrame.size.width - 80 - 30, 50, 50, 50);
    
    button.centerY = self.loginNameLabel.centerY;
    
    self.changeStuButton = button;
    
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(touchToChangeStu:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //    //分数图片
    //    @property (nonatomic,retain) UIImageView *showFenImageView;
    
    //    UIImageView *showFenImageView = [[UIImageView alloc] init];
    //
    //    showFenImageView.frame = CGRectMake(0, 0, 75, 100);
    //
    //    showFenImageView.centerY = 220;
    //
    //    showFenImageView.centerX = self.headImageView.centerX;
    //
    //
    //    showFenImageView.contentMode = UIViewContentModeScaleAspectFit;
    //
    //    showFenImageView.image = [UIImage imageNamed:@"defen"];
    //
    //    [self.view addSubview:showFenImageView];
    //
    //    self.showFenImageView = showFenImageView;
    //
    
    
//    [self setUpQQBMokuai];
//
//    [self setUpShuduMokuai];
}


//七巧板的 方块
-(void)setUpQQBMokuai{
    
    UIView *containQQBView = [[UIView alloc] init];
    [self.view addSubview:containQQBView];
    
    //左右 80  中间40
    containQQBView.x = 40;
    containQQBView.width = (JSFrame.size.width - 100) / 2;
    containQQBView.height = containQQBView.width * .58;
    containQQBView.y = CGRectGetMaxX(self.headImageView.frame) + 80;
    containQQBView.layer.cornerRadius = 5;
    containQQBView.layer.masksToBounds = YES;
    containQQBView.backgroundColor = [UIColor blackColor];
    
    UIImageView *image = [[UIImageView alloc] init];
    image.backgroundColor = JSColor(226, 205, 165, 1);
//    image.contentMode = UIViewContentModeScaleAspectFill;
    image.frame = containQQBView.bounds;
    image.image = [UIImage imageNamed:@"beijingnew"];
    image.layer.cornerRadius = 5;
    image.layer.masksToBounds = YES;
    image.layer.borderWidth = 1;
    image.layer.borderColor = [UIColor blackColor].CGColor;
    image.userInteractionEnabled = YES;
    [containQQBView addSubview:image];
    
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = JSColor(249, 235, 41, 1);
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"七巧板";
    titleLabel.width = containQQBView.width * .5;
    titleLabel.height = 40;
    titleLabel.layer.cornerRadius = 20;
    titleLabel.layer.masksToBounds = YES;
    titleLabel.centerX = containQQBView.width * .5;
    titleLabel.y = 25;
    
    titleLabel.layer.borderWidth = 1;
    titleLabel.layer.borderColor = [UIColor blackColor].CGColor;
    [containQQBView addSubview:titleLabel];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapQqb)];
    
    [image addGestureRecognizer:tap];
    
}

//数独的方块.
-(void)setUpShuduMokuai{
    
    UIView *containQQBView = [[UIView alloc] init];
    [self.view addSubview:containQQBView];
    
    //左右 80  中间40
    containQQBView.width = (JSFrame.size.width - 100) / 2;
    containQQBView.x = JSFrame.size.width * .5 + 20;
    containQQBView.height = containQQBView.width * .58;
    containQQBView.y = CGRectGetMaxX(self.headImageView.frame) + 80;
    containQQBView.layer.cornerRadius = 5;
    containQQBView.layer.masksToBounds = YES;
    containQQBView.backgroundColor = [UIColor blackColor];
    
    UIImageView *image = [[UIImageView alloc] init];
    image.backgroundColor = JSColor(226, 205, 165, 1);
    image.image = [UIImage imageNamed:@"yuansu"];
    image.contentMode = UIViewContentModeScaleToFill;
    image.frame = containQQBView.bounds;
    image.layer.cornerRadius = 5;
    image.layer.masksToBounds = YES;
    image.layer.borderWidth = 1;
    image.layer.borderColor = [UIColor blackColor].CGColor;
    image.userInteractionEnabled = YES;
    [containQQBView addSubview:image];
    
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = JSColor(249, 235, 41, 1);
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"数独";
    titleLabel.width = containQQBView.width * .5;
    titleLabel.height = 40;
    titleLabel.layer.cornerRadius = 20;
    titleLabel.layer.masksToBounds = YES;
    titleLabel.centerX = containQQBView.width * .5;
    titleLabel.y = 25;
    
    
    titleLabel.layer.borderWidth = 1;
    titleLabel.layer.borderColor = [UIColor blackColor].CGColor;
    
    [containQQBView addSubview:titleLabel];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShudu)];
    
    [image addGestureRecognizer:tap];
}

//交通灯.
-(void)setUpJiaoTongDengMokuai{
    
    UIView *containJTDView = [[UIView alloc] init];
    [self.view addSubview:containJTDView];
    
    //左右 80  中间40
    containJTDView.width = (JSFrame.size.width - 100) / 2;
    containJTDView.x = 40;
    containJTDView.height = containJTDView.width * .58;
    containJTDView.y = CGRectGetMaxX(self.headImageView.frame) + 100 + containJTDView.width * .58;
    containJTDView.layer.cornerRadius = 5;
    containJTDView.layer.masksToBounds = YES;
    containJTDView.backgroundColor = [UIColor blackColor];
    
    UIImageView *image = [[UIImageView alloc] init];
    image.backgroundColor = JSColor(226, 205, 165, 1);
    image.image = [UIImage imageNamed:@"yuansu"];
    image.contentMode = UIViewContentModeScaleToFill;
    image.frame = containJTDView.bounds;
    image.layer.cornerRadius = 5;
    image.layer.masksToBounds = YES;
    image.layer.borderWidth = 1;
    image.layer.borderColor = [UIColor blackColor].CGColor;
    image.userInteractionEnabled = YES;
    [containJTDView addSubview:image];
    
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = JSColor(249, 235, 41, 1);
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"交通灯";
    titleLabel.width = containJTDView.width * .5;
    titleLabel.height = 40;
    titleLabel.layer.cornerRadius = 20;
    titleLabel.layer.masksToBounds = YES;
    titleLabel.centerX = containJTDView.width * .5;
    titleLabel.y = 25;
    
    
    titleLabel.layer.borderWidth = 1;
    titleLabel.layer.borderColor = [UIColor blackColor].CGColor;
    
    [containJTDView addSubview:titleLabel];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapJiaoTongDeng)];
    
    [image addGestureRecognizer:tap];
}

//快闪图标.
-(void)setUpKuaiShanMokuai{
    
    UIView *containJTDView = [[UIView alloc] init];
    [self.view addSubview:containJTDView];
    
    //左右 80  中间40
    containJTDView.width = (JSFrame.size.width - 100) / 2;
    containJTDView.x = JSFrame.size.width * .5 + 20;;
    containJTDView.height = containJTDView.width * .58;
    containJTDView.y = CGRectGetMaxX(self.headImageView.frame) + 100 + containJTDView.width * .58;
    
    containJTDView.layer.cornerRadius = 5;
    containJTDView.layer.masksToBounds = YES;
    containJTDView.backgroundColor = [UIColor blackColor];
    
    UIImageView *image = [[UIImageView alloc] init];
    image.backgroundColor = JSColor(226, 205, 165, 1);
    image.image = [UIImage imageNamed:@"yuansu"];
    image.contentMode = UIViewContentModeScaleToFill;
    image.frame = containJTDView.bounds;
    image.layer.cornerRadius = 5;
    image.layer.masksToBounds = YES;
    image.layer.borderWidth = 1;
    image.layer.borderColor = [UIColor blackColor].CGColor;
    image.userInteractionEnabled = YES;
    [containJTDView addSubview:image];
    
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = JSColor(249, 235, 41, 1);
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"快闪图标";
    titleLabel.width = containJTDView.width * .5;
    titleLabel.height = 40;
    titleLabel.layer.cornerRadius = 20;
    titleLabel.layer.masksToBounds = YES;
    titleLabel.centerX = containJTDView.width * .5;
    titleLabel.y = 25;
    
    
    titleLabel.layer.borderWidth = 1;
    titleLabel.layer.borderColor = [UIColor blackColor].CGColor;
    
    [containJTDView addSubview:titleLabel];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapKuaiShanDeng)];
    
    [image addGestureRecognizer:tap];
}

//斯特鲁普测验.
-(void)setUpSiTeLuPuMokuai{
    
    UIView *containJTDView = [[UIView alloc] init];
    [self.view addSubview:containJTDView];
    
    //左右 80  中间40
    containJTDView.width = (JSFrame.size.width - 100) / 2;
    containJTDView.x = 40;
    containJTDView.height = containJTDView.width * .58;
    containJTDView.y = CGRectGetMaxX(self.headImageView.frame) + 120 + containJTDView.width * .58 * 2;
    containJTDView.layer.cornerRadius = 5;
    containJTDView.layer.masksToBounds = YES;
    containJTDView.backgroundColor = [UIColor blackColor];
    
    UIImageView *image = [[UIImageView alloc] init];
    image.backgroundColor = JSColor(226, 205, 165, 1);
    image.image = [UIImage imageNamed:@"yuansu"];
    image.contentMode = UIViewContentModeScaleToFill;
    image.frame = containJTDView.bounds;
    image.layer.cornerRadius = 5;
    image.layer.masksToBounds = YES;
    image.layer.borderWidth = 1;
    image.layer.borderColor = [UIColor blackColor].CGColor;
    image.userInteractionEnabled = YES;
    [containJTDView addSubview:image];
    
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = JSColor(249, 235, 41, 1);
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"斯特鲁普测验";
    titleLabel.width = containJTDView.width * .5;
    titleLabel.height = 40;
    titleLabel.layer.cornerRadius = 20;
    titleLabel.layer.masksToBounds = YES;
    titleLabel.centerX = containJTDView.width * .5;
    titleLabel.y = 25;
    
    
    titleLabel.layer.borderWidth = 1;
    titleLabel.layer.borderColor = [UIColor blackColor].CGColor;
    
    [containJTDView addSubview:titleLabel];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSiTeLuPu)];
    
    [image addGestureRecognizer:tap];
}

//快速记忆.
-(void)setUpKuaiSuJiYiMokuai{
    
    UIView *containJTDView = [[UIView alloc] init];
    [self.view addSubview:containJTDView];
    
    //左右 80  中间40
    containJTDView.width = (JSFrame.size.width - 100) / 2;
    containJTDView.x = JSFrame.size.width * .5 + 20;;
    containJTDView.height = containJTDView.width * .58;
    containJTDView.y = CGRectGetMaxX(self.headImageView.frame) + 120 + containJTDView.width * .58 * 2;
    containJTDView.layer.cornerRadius = 5;
    containJTDView.layer.masksToBounds = YES;
    containJTDView.backgroundColor = [UIColor blackColor];
    
    UIImageView *image = [[UIImageView alloc] init];
    image.backgroundColor = JSColor(226, 205, 165, 1);
    image.image = [UIImage imageNamed:@"yuansu"];
    image.contentMode = UIViewContentModeScaleToFill;
    image.frame = containJTDView.bounds;
    image.layer.cornerRadius = 5;
    image.layer.masksToBounds = YES;
    image.layer.borderWidth = 1;
    image.layer.borderColor = [UIColor blackColor].CGColor;
    image.userInteractionEnabled = YES;
    [containJTDView addSubview:image];
    
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = JSColor(249, 235, 41, 1);
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"快速记忆";
    titleLabel.width = containJTDView.width * .5;
    titleLabel.height = 40;
    titleLabel.layer.cornerRadius = 20;
    titleLabel.layer.masksToBounds = YES;
    titleLabel.centerX = containJTDView.width * .5;
    titleLabel.y = 25;
    
    
    titleLabel.layer.borderWidth = 1;
    titleLabel.layer.borderColor = [UIColor blackColor].CGColor;
    
    [containJTDView addSubview:titleLabel];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapKuaiSuJiYi)];
    
    [image addGestureRecognizer:tap];
}

////数字符号
//-(void)setUpSymbolNumberMokuai{
//
//    UIView *containQQBView = [[UIView alloc] init];
//    [self.view addSubview:containQQBView];
//
//    //左右 80  中间40
//    containQQBView.x = 40;
//    containQQBView.width = (JSFrame.size.width - 100) / 2;
//    containQQBView.height = containQQBView.width * .58;
//    containQQBView.y = CGRectGetMaxX(self.headImageView.frame) + 80 +containQQBView.width * .58;
//    containQQBView.layer.cornerRadius = 5;
//    containQQBView.layer.masksToBounds = YES;
//    containQQBView.backgroundColor = [UIColor blackColor];
//
//    UIImageView *image = [[UIImageView alloc] init];
//    image.backgroundColor = JSColor(226, 205, 165, 1);
//    //    image.contentMode = UIViewContentModeScaleAspectFill;
//    image.frame = containQQBView.bounds;
//    image.image = [UIImage imageNamed:@"beijingnew"];
//    image.layer.cornerRadius = 5;
//    image.layer.masksToBounds = YES;
//    image.layer.borderWidth = 1;
//    image.layer.borderColor = [UIColor blackColor].CGColor;
//    image.userInteractionEnabled = YES;
//    [containQQBView addSubview:image];
//
//
//    UILabel * titleLabel = [[UILabel alloc] init];
//    titleLabel.backgroundColor = JSColor(249, 235, 41, 1);
//    titleLabel.textColor = [UIColor blackColor];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.text = @"七巧板";
//    titleLabel.width = containQQBView.width * .5;
//    titleLabel.height = 40;
//    titleLabel.layer.cornerRadius = 20;
//    titleLabel.layer.masksToBounds = YES;
//    titleLabel.centerX = containQQBView.width * .5;
//    titleLabel.y = 25;
//
//    titleLabel.layer.borderWidth = 1;
//    titleLabel.layer.borderColor = [UIColor blackColor].CGColor;
//    [containQQBView addSubview:titleLabel];
//
//
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSymbolNumber)];
//
//    [image addGestureRecognizer:tap];
//
//}

//点击七巧板;
-(void)tapQqb{
    
    [self.view addSubview:self.tapShowView];
    self.tapShowView.x = 40;
    self.tapShowView.y = CGRectGetMaxX(self.headImageView.frame) + 80;
    
    self.beganGameButton.tag = 1;
    
    if (![JSStudentInfoManager manager].basicInfo.birthday.length) {
        NSString *str = @"年龄未设置";
        self.showLevelLabel.attributedText = [str attributedStringWithLineSpace:0 andWordSpace:3 andFont:self.showLevelLabel.font];
    }else{
        self.showLevelLabel.attributedText = [self.qqbLevel attributedStringWithLineSpace:0 andWordSpace:3 andFont:self.showLevelLabel.font];
    }
    self.showFenshuLabel.text = self.qqbFenshu;
    
    
    //如果现实今天的训练已经结束.  判断题目已经完成的情况.
    if ([JSStudentInfoManager manager].isOverToday) {
        [self.beganGameButton setBackgroundColor:[UIColor grayColor]];
        [self.beganGameButton setTitle:@"答题结束" forState:UIControlStateNormal];
    }else{
        [self.beganGameButton setTitle:@"开 始" forState:UIControlStateNormal];
        [self.beganGameButton setBackgroundColor:JSMainDarkPuer];
    }
}


-(void)tapShudu{
    [self.view addSubview:self.tapShowView];
    self.tapShowView.x = JSFrame.size.width * .5 + 20;
    self.tapShowView.y = CGRectGetMaxX(self.headImageView.frame) + 80;
    self.beganGameButton.tag = 2;
    
    if (![JSStudentInfoManager manager].basicInfo.birthday.length) {
        NSString *str = @"年龄未设置";
        self.showLevelLabel.attributedText = [str attributedStringWithLineSpace:0 andWordSpace:3 andFont:self.showLevelLabel.font];
    }else{
        self.showLevelLabel.attributedText = [self.sdLevel attributedStringWithLineSpace:0 andWordSpace:3 andFont:self.showLevelLabel.font];
    }
    
    
    self.showFenshuLabel.text = self.sdFenshu;
    
    
    //如果现实今天的训练已经结束.  判断题目已经完成的情况.
    if ([JSStudentInfoManager manager].isOverShudu) {
        [self.beganGameButton setBackgroundColor:[UIColor grayColor]];
        [self.beganGameButton setTitle:@"答题结束" forState:UIControlStateNormal];
    }else{
        [self.beganGameButton setTitle:@"开 始" forState:UIControlStateNormal];
        [self.beganGameButton setBackgroundColor:JSMainDarkPuer];
    }
    
}

//点击七巧板;
-(void)tapSymbolNumber{
    
    [self.view addSubview:self.tapShowView];
    self.tapShowView.x = 40;
    self.tapShowView.y = CGRectGetMaxX(self.headImageView.frame) + 80;
    
    self.beganGameButton.tag = 1;
    
    if (![JSStudentInfoManager manager].basicInfo.birthday.length) {
        NSString *str = @"年龄未设置";
        self.showLevelLabel.attributedText = [str attributedStringWithLineSpace:0 andWordSpace:3 andFont:self.showLevelLabel.font];
    }else{
        self.showLevelLabel.attributedText = [self.qqbLevel attributedStringWithLineSpace:0 andWordSpace:3 andFont:self.showLevelLabel.font];
    }
    self.showFenshuLabel.text = self.qqbFenshu;
    
    
    //如果现实今天的训练已经结束.  判断题目已经完成的情况.
    if ([JSStudentInfoManager manager].isOverToday) {
        [self.beganGameButton setBackgroundColor:[UIColor grayColor]];
        [self.beganGameButton setTitle:@"答题结束" forState:UIControlStateNormal];
    }else{
        [self.beganGameButton setTitle:@"开 始" forState:UIControlStateNormal];
        [self.beganGameButton setBackgroundColor:JSMainDarkPuer];
    }
}

- (void)tapJiaoTongDeng {
    MemoryGameViewController *trafficLight = [[MemoryGameViewController alloc] init];
    trafficLight.memoryGameType = XTMemoryGameTypeWithTrafficLight;
    [self presentViewController:trafficLight animated:YES completion:nil];
}
- (void)tapKuaiShanDeng {
    MemoryGameViewController *trafficLight = [[MemoryGameViewController alloc] init];
    trafficLight.memoryGameType = XTMemoryGameTypeWithTrafficLight;
    trafficLight.memoryGameType = XTMemoryGameTypeWithQuickFlashing;
    
    [self presentViewController:trafficLight animated:YES completion:nil];
}
- (void)tapSiTeLuPu {
    MemoryGameViewController *trafficLight = [[MemoryGameViewController alloc] init];
    trafficLight.memoryGameType = XTMemoryGameTypeWithTrafficLight;
    trafficLight.memoryGameType = XTMemoryGameTypeWithStroopEffect;
    
    [self presentViewController:trafficLight animated:YES completion:nil];
}
- (void)tapKuaiSuJiYi {
    QuickMemoryViewController *quickMemory = [[QuickMemoryViewController alloc] init];
    [self presentViewController:quickMemory animated:YES completion:nil];
}

//显示个人信息页面.
-(void)showStuInfo{
    
    SetInfoAlertViewController *vc = [[SetInfoAlertViewController alloc] init];
    
    self.alertController = vc;
    
    vc.delegate = self;
    
    [self.view addSubview:vc.view];
    
    
}

-(void)tapToAge:(UITapGestureRecognizer *)tap{
    [self showStuInfo];
}


//点击这里对账号进行切换.
-(void)touchToChangeStu:(UIButton *)sender{
    loginViewController *loginView = [[loginViewController alloc] init];
    [UIApplication sharedApplication].keyWindow.rootViewController = loginView;
}

//点击开始七巧板游戏.
-(void)touchToBeganGame:(UIButton *)sender{
    if (![JSStudentInfoManager manager].isSetAge) {
        //没有设置年龄
        [self.view addSubview:self.alertViewToSet];
        return;
    }
    
    if (([JSStudentInfoManager manager].isOverToday&&self.beganGameButton.tag == 1) || (self.beganGameButton.tag == 2 && [JSStudentInfoManager manager].isOverShudu)) {
        return;
    }
    
    if (self.beganGameButton.tag == 1) {
        ViewController *vc = [[ViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        SDViewController *vc = [[SDViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

//自杀头 大小伤腰带 项链  两个戒指.
//192.0.2.1 1.1.1.1
#pragma mark - netWork
//获取当前等级
-(void)ShowCurrentLevel{
    //
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"login_name"] = [JSStudentInfoManager manager].basicInfo.loginName;

    [[INetworking shareNet]GET:@"http://114.55.90.93:8081/web/app/qqblevelrecordList.json" withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        NSError *error;
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingMutableLeaves error:&error];

        dispatch_async(dispatch_get_main_queue(), ^{

             self.qqbLevel = [NSString stringWithFormat:@"level %ld",[weatherDic[@"level"] longValue]];

        });
        
    }];

    
    
    //http://114.55.90.93:8081/web/app/sdklevelrecordList.json
    
    [[INetworking shareNet]GET:@"http://114.55.90.93:8081/web/app/sdklevelrecordList.json" withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        NSError *error;
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingMutableLeaves error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.sdLevel = [NSString stringWithFormat:@"level %ld",[weatherDic[@"level"] longValue]];
        });
    }];
}

//获取当前的分数.
-(void)GetCurrentScore{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"login_name"] = [JSStudentInfoManager manager].basicInfo.loginName;
    WeakObject(self);
    [[INetworking shareNet] GET:@"http://114.55.90.93:8081/web/app/qqbtentimesrecordList.json" withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        NSError *error;
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingMutableLeaves error:&error];
        long score = [weatherDic[@"stu_score"] longValue];
        dispatch_async(dispatch_get_main_queue(), ^{

            if (score == -1) {
                selfWeak.qqbFenshu = @"暂时没有分数";
            }else{
                selfWeak.qqbFenshu = [NSString stringWithFormat:@"前十题总分:%ld",score];
            }
        });
    }];
    //http://114.55.90.93:8081/web/app/sudokutentimesrecordList.json
    [[INetworking shareNet] GET:@"http://114.55.90.93:8081/web/app/sudokutentimesrecordList.json" withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        NSError *error;
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingMutableLeaves error:&error];
        long score = [weatherDic[@"stu_score"] longValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (score == -1) {
                selfWeak.sdFenshu = @"暂时没有分数";
            }else{
                selfWeak.sdFenshu = [NSString stringWithFormat:@"前十题总分:%ld",score];
            }
        });
    }];
    
}



#pragma mark - setInfoAlertDelegate;

//在这里是已经修改了学生年龄.
-(void)SetInfoAlertViewController:(SetInfoAlertViewController *)controller didSetBirthday:(NSString *)date{
    
#warning 需要对学员的数据进行跟新  进行接口上的修改.
    //先对学生后代最新的年龄进行修改.
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    NSNumber *number = [NSNumber numberWithLong:[JSStudentInfoManager manager].basicInfo.stuID];
    
    dic[@"id"] = number;
    dic[@"birthday"] = [JSStudentInfoManager manager].basicInfo.birthday;
    
    WeakObject(self);
    [[INetworking shareNet]GET:@"http://114.55.90.93:8081/web/app/qqbstudentUpdate.json" withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        NSError *error;
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingMutableLeaves error:&error];
        NSLog(@"%@",weatherDic);
        
        [selfWeak ShowCurrentLevel];
    }];
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"开始测试的页面销毁掉拉.");
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

