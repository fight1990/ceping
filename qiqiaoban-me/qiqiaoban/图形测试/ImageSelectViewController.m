//
//  ImageSelectViewController.m
//  qiqiaoban
//
//  Created by mac on 2019/8/5.
//  Copyright © 2019年 mac. All rights reserved.
//

#import "ImageSelectViewController.h"
#import "JSEDefine.h"
#import "LevelButton.h"
#import "ImageTestViewController.h"
#import "INetworking.h"
#import "JSStudentInfoManager.h"
#import "ImageTrainLevelModel.h"
#import <SVProgressHUD.h>

@interface ImageSelectViewController ()

//存放所有按钮的数组.
@property (nonatomic,retain) NSMutableArray *buttonContainArray;

@property (nonatomic,retain) NSMutableArray *dataArray;

@end

@implementation ImageSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    self.buttonContainArray = [NSMutableArray array];

    [self setUpView];
    
     [self getInfo];
}

//获取过往的训练记录.
-(void)getInfo{
    
    [SVProgressHUD showWithStatus:@"加载中"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    dic[@"login_name"] = [JSStudentInfoManager manager].basicInfo.loginName;
    dic[@"stu_name"] = [JSStudentInfoManager manager].basicInfo.stuName;
    dic[@"password"] = [JSStudentInfoManager manager].basicInfo.passWord;
    
    if (self.dataArray.count) {
        [self.dataArray removeAllObjects];
    }
    
    self.dataArray = [NSMutableArray array];
    
    [[INetworking shareNet] GET:@"http://114.55.90.93:8081/web/app/graphicmemorylevelrecordList.json" withParmers:dic do:^(id returnObject, BOOL isSuccess) {
       
        if (isSuccess) {
            NSError *error;
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingMutableLeaves error:&error];
            
            for (int i = 0; i < 21; i ++) {
                
                NSString *title = [NSString stringWithFormat:@"list%d",i+1];
                NSArray *ary = weatherDic[title];
                if (ary.count) {
                    
                    NSDictionary *dataDic = [ary firstObject];
                    
                    ImageTrainLevelModel *model = [[ImageTrainLevelModel alloc] init];
                    model.level = i + 1;
                    NSString *scoreStr = dataDic[@"stu_score"];
                    model.score = scoreStr.floatValue / 100.0;
                    NSString *timeStr = dataDic[@"used_times"];
                    model.time = timeStr.floatValue;
                    
                    [self.dataArray addObject:model];
                    
                }
                
            }
            
            [SVProgressHUD dismiss];
            [self reloadButton];
        
        }else{
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
            [SVProgressHUD dismissWithDelay:.7];
        }
        
    }];
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    [self getInfo];
    
}

-(void)setUpView{
    //创建背景图片. 
    UIImageView *backGro = [[UIImageView alloc] init];
    backGro.frame = CGRectMake(0, 0, JSFrame.size.width, JSFrame.size.height);
    backGro.image = [UIImage imageNamed:@"beijingphoto"];
    [self.view addSubview:backGro];
    //创建返回上级页面部分
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    topView.frame = CGRectMake(0, 0, self.view.width, 80);
    [self.view addSubview:topView];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor grayColor];
    lineView.frame = CGRectMake(0, 80, self.view.width, 1);
    [self.view addSubview:lineView];
    
    UIButton *butReturn = [[UIButton alloc] init];
    [butReturn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [butReturn sizeToFit];
    butReturn.width = butReturn.width * .7;
    butReturn.height = butReturn.height * .7;
    butReturn.centerY = 50;
    butReturn.x = 15;
    [butReturn addTarget:self action:@selector(fanhui:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:butReturn];
    
    //创建关卡按钮.
    
    CGFloat xTotalOffset = self.view.width * .10;
    CGFloat buttonWidth = 100;
    CGFloat xBeOffset = (self.view.width - xTotalOffset * 2 - buttonWidth * 5) / 4.0;
    for (int i = 0; i < 5; i ++) {
        for (int j = 0 ; j < 4; j ++) {
            
            LevelButton *but = [[LevelButton alloc] init];
            
            [but creatSubviewsWithButtonWidth:buttonWidth];
            
            but.tag = j * 5 + i;  // 0 - 14;
            
            but.x = xTotalOffset + i * (buttonWidth + xBeOffset);
            
            but.y = self.view.height * .28 + (buttonWidth + xBeOffset + 12) * j;
            
            [self.view addSubview:but];
            
            [self.buttonContainArray addObject:but];
            
            but.levelButtonType = LevelButtonTypeLock;
            
            [but addTarget:self action:@selector(touchToSelectLevel:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
    
    
    UIButton *wuxian = [[UIButton alloc] init];
    
    [wuxian setBackgroundImage:[UIImage imageNamed:@"灰"] forState:UIControlStateNormal];
    
    wuxian.width = wuxian.height = buttonWidth;
    
    UIImageView *lockImageView = [[UIImageView alloc] init];
    lockImageView.frame = CGRectMake(0, 0, 64, 64);
    lockImageView.image = [UIImage imageNamed:@"wenan"];
    lockImageView.centerX = buttonWidth * .5;
    lockImageView.centerY = buttonWidth * .5;
    lockImageView.contentMode = UIViewContentModeScaleAspectFill;
    [wuxian addSubview:lockImageView];
    
    
    wuxian.x = xTotalOffset;
    wuxian.y = self.view.height * .28 + (buttonWidth + xBeOffset + 12) *4;
    [self.view addSubview:wuxian];
    
}


-(void)fanhui:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)reloadButton{
    
    //没有任何数据的时候 单独拿出来.
    if (self.dataArray.count == 0) {
        for (LevelButton *but in self.buttonContainArray) {
            but.levelButtonType = LevelButtonTypeLock;
            if (but.tag == 0) {
                but.levelButtonType = LevelButtonTypeUnlock;
            }
        }
        //此时后面都是多余的计算.直接跳过.
        return;
    }

    
    //当前最大关卡.  关卡的范围是 1 - 20;
    static int max = 0;
    
    //是否通关了目前的所有关卡.
    BOOL isPass = NO;
    
    
    for (ImageTrainLevelModel *model in self.dataArray) {

        if (model.level > max) {
            max = model.level;
        }
    }
    
    //现在最好关卡为max关

    for (ImageTrainLevelModel *model in self.dataArray) {
        //最好关卡不为20 且 得分过80
        if (model.level == max&&model.score > 80&&max != 20) {
            isPass = YES;
            //当前 多一个可进行的关卡.
        }
    }
    
    
    for (LevelButton *but in self.buttonContainArray) {
        for (ImageTrainLevelModel *model in self.dataArray) {
            //tag 0 - 15   level 1 - 16
            if (but.tag == (model.level - 1)) {
                if (model.score > 80 && model.score != 100 ) {
                    but.levelButtonType = LevelButtonTypeRecordGood;
                }
                else if(model.score <= 80){
                    but.levelButtonType = LevelButtonTypeRecordBad;
                }
                but.miaoLabel.text = [NSString stringWithFormat:@"%d",model.miao];
                but.scondLabel.text = [NSString stringWithFormat:@"%d'",model.fen];
            }
            
        }
    }
    if (isPass) {
        for (LevelButton *but in self.buttonContainArray) {
            if (but.tag == (max)) {
                but.levelButtonType = LevelButtonTypeUnlock;
            }
        }
    }
}


-(void)touchToSelectLevel:(UIButton *)sender{
    ImageTestViewController *imageTest = [[ImageTestViewController alloc] init];
    
    imageTest.level = [NSString stringWithFormat:@"%d",(int)sender.tag + 1];
    
    [self presentViewController:imageTest animated:YES completion:nil];

}

@end

