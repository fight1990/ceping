//
//  SymbolNumberChooseVC.m
//  QiQiaoBan
//
//  Created by mac on 2019/8/15.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "SymbolNumberChooseVC.h"
#import "SymbolNumberVC.h"

#import "UnlockViewController.h"
#import "UIViewController+CBPopup.h"
#import "INetworking.h"
#import <SVProgressHUD.h>
#import "JSStudentInfoManager.h"

#import "SymbolNumberChooseView.h"

#define ViewWidth (KScreenWidth-70)/5

@interface SymbolNumberChooseVC ()
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSDictionary *listDic;
@property (nonatomic,strong)NSMutableArray *listAry;

@end

@implementation SymbolNumberChooseVC

static NSString *const cellId = @"cellId";

-(NSMutableArray *)listAry{
    if (!_listAry) {
        _listAry =[NSMutableArray array];
    }
    return _listAry;
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    [self getList];
}

-(void)getList{
    INetworking *net =[INetworking shareNet];
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [SVProgressHUD showWithStatus:@"获取数据中……"];
//    dic[@"login_name"] =[JSStudentInfoManager manager].basicInfo.loginName;
    dic[@"password"] =[JSStudentInfoManager manager].basicInfo.passWord;
    dic[@"stu_name"] = [JSStudentInfoManager manager].basicInfo.stuName;
    
    NSString *url =[NSString stringWithFormat:@"%@%@.json",SERVISEURL,@"symbolicdigitalcodingrecordList"];
    
    [net GET:url withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        
        if (isSuccess ==YES) {
           self.listDic = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingAllowFragments error:nil];
            [SVProgressHUD showSuccessWithStatus:@"获取成功"];
            [SVProgressHUD dismissWithDelay:.7];
            self.listAry =[NSMutableArray array];
            for (int i=0; i<20; i++) {
                NSString *str =[NSString stringWithFormat:@"list%d",i+1];
                if ([self.listDic[str] count] >0) {
                    [self.listAry addObject:self.listDic[str]];
                }
            }
//            NSLog(@"listAry--%@",self.listAry);
            [self creatViewAndButton];
//            [hud hideAnimated:YES];
        }else{
            NSError *error =returnObject;
            if (error.code ==-1009) {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                    [self doSomeWork];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD showErrorWithStatus:@"无网络，请检查网络"];
                        [SVProgressHUD dismissWithDelay:.7];
                    });
                });
                
            }else if (error.code ==-1001){
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                    [self doSomeWork];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [SVProgressHUD showErrorWithStatus:@"网络超时"];
                        [SVProgressHUD dismissWithDelay:.7];
                    });
                });
            }
        }
        
    }];
}

- (void)doSomeWork {
    // Simulate by just waiting.
    sleep(3.);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"数字符号";
    self.view.backgroundColor =[UIColor whiteColor];
    
    UIImageView *backgroundView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    backgroundView.image =[UIImage imageNamed:@"beijing2"];
    [self.view addSubview:backgroundView];
    
    UIImageView *gameView =[[UIImageView alloc]initWithFrame:CGRectMake(150, 114, KScreenWidth-300, 150)];
    gameView.image =[UIImage imageNamed:@"biaoti"];
    [self.view addSubview:gameView];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.f, 0.f, 40, 30)];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    UIView *backBtnView = [[UIView alloc] initWithFrame:backBtn.bounds];
    backBtnView.bounds = CGRectOffset(backBtnView.bounds, -6, 0);
    [backBtnView addSubview:backBtn];
    UIImageView *backImage =[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 25, 25)];
    backImage.image =[UIImage imageNamed:@"fanhui"];
    [backBtnView addSubview:backImage];
    
    UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:backBtnView];
    self.navigationItem.leftBarButtonItem =backBarBtn;

}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)creatViewAndButton{
//    NSLog(@"%ld",[self.listAry count]);
    NSArray *guankaArray =@[@"guanka1",@"guanka2",@"guanka3",@"guanka4",@"guanka5",@"guanka6",@"guanka7",@"guanka8",@"guanka9",@"guanka10",@"guanka11",@"guanka12",@"guanka13",@"guanka14",@"guanka15",@"guanka16",@"guanka17",@"guanka18",@"guanka19",@"guanka20",@"wenan"];
    
    for (int i=0 ; i<21; i++) {

        SymbolNumberChooseView *view =[[SymbolNumberChooseView alloc]initWithFrame:CGRectMake(10+(ViewWidth+10)*(i%5), 264+(ViewWidth+10)*(i/5), ViewWidth, ViewWidth)];
        if (i<[self.listAry count]) {
            NSDictionary *dic =self.listAry[i][0];
            view.clockImage.image =[UIImage imageNamed:@"yuan"];
            view.passImage.image =[UIImage imageNamed:guankaArray[i]];
            view.unpassImage.hidden =YES;
            float star =[dic[@"number"] floatValue]/[dic[@"totlenumber"] floatValue];
            if (star ==1) {
                view.starImage.image =[UIImage imageNamed:@"xingxing"];
            }else{
                view.starImage.image =[UIImage imageNamed:@"xingxing1"];
            }
            
            view.labelImage.image =[UIImage imageNamed:@"yuansu-1"];
            view.timeLabel.text =[NSString stringWithFormat:@"%@'",dic[@"used_times"]];
            view.rightLabel.text =dic[@"number"];
        }else if (i ==[self.listAry count]){
            view.clockImage.image =[UIImage imageNamed:@"yuan"];
            view.passImage.hidden =YES;
            view.unpassImage.image =[UIImage imageNamed:guankaArray[i]];
            view.starImage.hidden =YES;
            view.labelImage.hidden =YES;
            view.timeLabel.hidden =YES;
            view.rightLabel.hidden =YES;
        }else{
            view.clockImage.image =[UIImage imageNamed:@"yuan1"];
            view.passImage.hidden =YES;
            view.unpassImage.image =[UIImage imageNamed:@"suo"];
            view.starImage.hidden =YES;
            view.labelImage.hidden =YES;
            view.timeLabel.hidden =YES;
            view.rightLabel.hidden =YES;
        }
        
        [self.view addSubview:view];
        
        UIButton *btn =[UIButton buttonWithType:0 ];
        btn.frame =CGRectMake(10+(ViewWidth+10)*(i%5), 264+(ViewWidth+10)*(i/5), ViewWidth, ViewWidth);
        btn.tag =i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:btn];
    }
}

-(void)click:(UIButton *)sender{
    if (sender.tag<[self.listAry count]+1) {
        SymbolNumberVC *vc =[[SymbolNumberVC alloc]init];
        if (sender.tag <6) {
            vc.queAmount =sender.tag *5 +15;
            vc.titleNum =sender.tag+1;
            vc.queSeconds =(sender.tag *5 +15)*10;
        }else if (sender.tag >=6 && sender.tag <13){
            vc.queAmount =sender.tag *5;
            vc.titleNum =sender.tag+1;
            vc.queSeconds =(sender.tag *5)*6;
        }else if (sender.tag >=13 && sender.tag <20){
            vc.queAmount =(sender.tag-5)*5;
            vc.titleNum =sender.tag+1;
            vc.queSeconds =((sender.tag-5)*5)*4;
        }else if (sender.tag ==20){
            vc.queAmount =999;
            vc.titleNum =999;
            vc.queSeconds =999;
        }

        [self.navigationController pushViewController:vc animated:YES];

    }else{
        UnlockViewController *unlockVC =[[UnlockViewController alloc]init];
        unlockVC.view.frame = CGRectMake(0, 0, KScreenWidth/2+100, 400);
        unlockVC.view.layer.cornerRadius = 20.0;
        unlockVC.view.layer.masksToBounds = YES;

        [self cb_presentPopupViewController:unlockVC animationType:1 aligment:CBPopupViewAligmentCenter dismissed:nil];
    }
}


@end
