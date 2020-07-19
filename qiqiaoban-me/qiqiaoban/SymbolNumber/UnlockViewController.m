//
//  UnlockViewController.m
//  QiQiaoBan
//
//  Created by mac on 2019/8/20.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "UnlockViewController.h"
#import "UIViewController+CBPopup.h"

@interface UnlockViewController ()
@property (nonatomic,strong) UIView *backgroundView;
@end

@implementation UnlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth/2+100, 400)];
    self.backgroundView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.backgroundView];
    
    UIImageView *starImageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth/2+100, 400)];
    starImageView.image =[UIImage imageNamed:@"tankuang"];
    [self.backgroundView addSubview:starImageView];
    
    UIButton *backBtn =[UIButton buttonWithType:0];
    backBtn.frame =CGRectMake(KScreenWidth/2+50, 10, 40, 40);
//    backBtn.backgroundColor =[UIColor yellowColor];
    [backBtn setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
    [self.backgroundView addSubview:backBtn];
    
    UILabel *remainingSecondsLab =[[UILabel alloc]initWithFrame:CGRectMake(50, 310, KScreenWidth/2, 50)];
    remainingSecondsLab.text =@"此题未解锁";
    remainingSecondsLab.font =[UIFont systemFontOfSize:40];
    remainingSecondsLab.textAlignment =NSTextAlignmentCenter;
    [self.backgroundView addSubview:remainingSecondsLab];

}

-(void)back:(UIButton *)sender{

    [self cb_dismissPopupViewControllerToRootAnimated:YES];

}

@end
