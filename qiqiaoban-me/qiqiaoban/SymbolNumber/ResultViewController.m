//
//  ResultViewController.m
//  QiQiaoBan
//
//  Created by mac on 2019/8/20.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ResultViewController.h"
#import "UIViewController+CBPopup.h"
#import "SymbolNumberChooseVC.h"
#import "SymbolNumberVC.h"

@interface ResultViewController ()

@property (nonatomic,strong) UIView *backgroundView;

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth/2+100, 380)];
    self.backgroundView.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:self.backgroundView];
    
//    UIButton *backBtn =[UIButton buttonWithType:0];
//    backBtn.frame =CGRectMake(KScreenWidth/2+50, 10, 40, 40);
//    backBtn.backgroundColor =[UIColor yellowColor];
//    [backBtn setImage:[UIImage imageNamed:@"heiCha"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
//    [self.backgroundView addSubview:backBtn];
//    
    UIImageView *starImageView =[[UIImageView alloc]initWithFrame:CGRectMake(50, 10, KScreenWidth/2, 150)];
    starImageView.image =[UIImage imageNamed:@"1-3"];
    [self.backgroundView addSubview:starImageView];
    
    UILabel *remainingSecondsLab =[[UILabel alloc]initWithFrame:CGRectMake(50, 170, KScreenWidth/2, 50)];
    remainingSecondsLab.text =[NSString stringWithFormat:@"剩余 %ld 秒",self.remainingSeconds];
    remainingSecondsLab.font =[UIFont systemFontOfSize:35];
    remainingSecondsLab.textAlignment =NSTextAlignmentCenter;
    [self.backgroundView addSubview:remainingSecondsLab];
    
    UILabel *resultLab =[[UILabel alloc]initWithFrame:CGRectMake(50, 240, KScreenWidth/2, 50)];
    resultLab.text =[NSString stringWithFormat:@"共答对 %ld 个，共 %ld 个",self.rightAmount,self.queAmount];
    resultLab.font =[UIFont systemFontOfSize:30];
    resultLab.textAlignment =NSTextAlignmentCenter;
    [self.backgroundView addSubview:resultLab];
    
    UIButton *resultBtn =[UIButton buttonWithType:0];
    resultBtn.frame =CGRectMake(70, 310, KScreenWidth/2-40, 50);
    resultBtn.layer.cornerRadius =25;
    resultBtn.backgroundColor =[UIColor blueColor];
    [resultBtn setTitle:@"123" forState:UIControlStateNormal];
    [resultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resultBtn.titleLabel.font =[UIFont systemFontOfSize:30];
    [resultBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchDown];
    [self.backgroundView addSubview:resultBtn];
}

-(void)back:(UIButton *)sender{
    SymbolNumberVC *vc =[[SymbolNumberVC alloc]init];
    [vc.navigationController popViewControllerAnimated:YES];
    [self cb_dismissPopupViewControllerToRootAnimated:YES];
    

}

@end
