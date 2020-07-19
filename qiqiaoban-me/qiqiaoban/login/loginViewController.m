
//
//  loginViewController.m
//  qiqiaoban
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019年 mac. All rights reserved.
//特修斯之船

#import "loginViewController.h"
#import "JSEDefine.h"
#import "UIImage+Render.h"
#import "NSString+Bounding.h"
#import "INetworking.h"
#import "StudentsInfo.h"
#import "SelectStuTableViewCell.h"
#import "JSStudentInfoManager.h"

#import "ShowMainViewController.h"

#import <SVProgressHUD.h>


static NSString *const rightsString = @"杭州太优全脑优能中心，竞思教育科技有限公司版权所有©";


@interface loginViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) UITableView *tableView;

@property (nonatomic,retain) NSMutableArray *stuInfoModelArray;

@end

@implementation loginViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stuInfoModelArray = [NSMutableArray array];
//    [self saveInfoFor];
    [self loadInfo];
    [self setUpView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpView{
//    self.view.backgroundColor = JSMainBlueColor;
    UIImageView *beijing = [[UIImageView alloc] init];
    beijing.image = [UIImage imageNamed:@"beijing"];
    beijing.frame = self.view.bounds;
    [self.view addSubview:beijing];
    
    
    UIImageView *nameImageView = [[UIImageView alloc] init];
    nameImageView.image = [UIImage imageNamed:@"logo"];
    [nameImageView sizeToFit];
    nameImageView.height = nameImageView.height * 0.75;
    nameImageView.width = nameImageView.width * 0.75;
    nameImageView.centerX = self.view.centerX;
    nameImageView.y = JSFrame.size.height * .05;
    
    [self.view addSubview:nameImageView];
    self.nameImageView = nameImageView;
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.image = [UIImage imageNamed:@"yuansu"];
    [logoImageView sizeToFit];
    
    CGFloat scale = JSFrame.size.width * .85 * 1.0 / logoImageView.width;
    
    logoImageView.height = logoImageView.height * scale;
    logoImageView.width = logoImageView.width * scale;
    logoImageView.centerX = self.view.centerX;
//    logoImageView.y = CGRectGetMaxY(nameImageView.frame) + JSFrame.size.height * .04;
    logoImageView.y = JSFrame.size.height * .05;
    [self.view addSubview:logoImageView];
    self.logoImageView = logoImageView;
    
    UILabel *titleLable = [[UILabel alloc] init];
    titleLable.textColor = [UIColor whiteColor];
    titleLable.font = JSBold(30);
//    titleLable.text = @"七巧板占位";
    [titleLable sizeToFit];
    titleLable.centerX = self.view.centerX;
    //    titleLable.centerY = CGRectGetMaxY(logoImageView.frame) + JSFrame.size.height * .06;
    titleLable.centerY = JSFrame.size.height * .15;
    [self.view addSubview:titleLable];
    self.titleLabelView = titleLable;
    
    self.loginNameTextField = [self textFieldWithPlaceholder:@"  账号/姓名" andLeftViewName:@"zhanghao"];
    self.loginNameTextField.centerX = self.view.centerX;
    self.loginNameTextField.centerY = CGRectGetMaxY(self.logoImageView.frame) + JSFrame.size.height * .1;
    [self.view addSubview:self.loginNameTextField];
    self.loginNameTextField.layer.borderWidth = 1;
    self.loginNameTextField.layer.borderColor = JSMainDarkPuer.CGColor;
    self.loginNameTextField.layer.cornerRadius = 29;
    self.loginNameTextField.layer.masksToBounds = YES;
    
    
    self.passWordTextField = [self textFieldWithPlaceholder:@"  密码" andLeftViewName:@"mima"];
    self.passWordTextField.secureTextEntry = YES;
    self.passWordTextField.centerX = self.view.centerX;
    self.passWordTextField.y = CGRectGetMaxY(self.loginNameTextField.frame)  + 40;
    [self.view addSubview:self.passWordTextField];
    self.passWordTextField.layer.borderWidth = 1;
    self.passWordTextField.layer.borderColor = JSMainDarkPuer.CGColor;
    self.passWordTextField.layer.cornerRadius = 29;
    self.passWordTextField.layer.masksToBounds = YES;
    
    
    self.loginNameTextField.delegate = self;
    self.passWordTextField.delegate = self;
    
    //    self.remmberPassWord = ({
    //        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //        NSString *containStr =@"记住密码";
    //        [button setTitle:containStr forState:UIControlStateNormal];
    //        [button setImage:[UIImage imageNamed:@"gou-2"] forState: UIControlStateNormal];
    //        [button setImage:[UIImage imageNamed:@"gou"] forState:UIControlStateSelected];
    //        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        button.titleLabel.font = JSFont(15);
    //        CGRect strRect = [containStr boundingRectWithSize:CGSizeZero strFont:JSFont(15)];
    //        button.frame = strRect;
    //        CGFloat viewSpace = 5;
    //        button.width = button.width + button.imageView.width + viewSpace;
    //        button.x = CGRectGetMinX(self.passWordTextField.frame);
    //        button.y = CGRectGetMaxY(self.passWordTextField.frame) + JSFrame.size.height * .04;
    //        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, viewSpace * .5)];
    //        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, viewSpace * .5, 0, 0)];
    //        [button addTarget:self action:@selector(clickBoxButton:) forControlEvents:UIControlEventTouchUpInside];
    //        button;
    //    });
    //    [self.view addSubview:self.remmberPassWord];
    //
    //
    //    self.forgetPassWord = ({
    //        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    //        [button setTitle:@"忘记密码" forState: UIControlStateNormal];
    //        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    //        button.titleLabel.font = JSFont(15);
    //        CGRect strRect = [@"忘记密码" boundingRectWithSize:CGSizeZero strFont:JSFont(15)];
    //        button.frame = strRect;
    //        button.x = CGRectGetMaxX(self.passWordTextField.frame) - button.width;
    //        button.y = self.remmberPassWord.y;
    //        [button addTarget:self action:@selector(touchForget:) forControlEvents:UIControlEventTouchUpInside];
    //        button;
    //    });
    //    [self.view addSubview:self.forgetPassWord];
    
    self.loginSureButton = ({
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.frame = self.loginNameTextField.frame;
        [sureButton setBackgroundColor:JSMainDarkPuer];
        [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [sureButton setTitle:@"登  入" forState:UIControlStateNormal];
        sureButton.titleLabel.font = JSFont(27);
        sureButton.y = CGRectGetMaxY(self.passWordTextField.frame) + 70;
        [sureButton addTarget:self action:@selector(touchSureLogin:) forControlEvents:UIControlEventTouchUpInside];
        sureButton;
    });
    [self.view addSubview:self.loginSureButton];
    
    
    self.loginSureButton.layer.cornerRadius = 29;
    self.loginSureButton.layer.masksToBounds = YES;
    
    //    self.helpButton = ({
    //        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    //        [button setTitle:@"登录帮助" forState: UIControlStateNormal];
    //        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    //        button.titleLabel.font = JSFont(15);
    //        CGRect strRect = [@"登录帮助" boundingRectWithSize:CGSizeZero strFont:JSFont(15)];
    //        button.frame = strRect;
    //        button.centerX = self.view.centerX;
    //        button.y = CGRectGetMaxY(self.loginSureButton.frame) + JSFrame.size.height * .04;
    //        [button addTarget:self action:@selector(touchHelp:) forControlEvents:UIControlEventTouchUpInside];
    //        button;
    //    });
    //    [self.view addSubview:self.helpButton];
    //
    
    //    self.rightsLabel = ({
    //        UILabel * label = [[UILabel alloc] init];
    //        label.textColor = [UIColor whiteColor];
    //        label.font = JSFont(10);
    //        label.text = rightsString;
    //        [label sizeToFit];
    //        label.centerX = self.view.centerX;
    //        label.centerY = JSFrame.size.height * .95;
    //        label;
    //    });
    //    [self.view addSubview:self.rightsLabel];
    
    
    if (self.stuInfoModelArray.count < 5) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 51, self.loginNameTextField.width, self.loginNameTextField.height * self.stuInfoModelArray.count) style:UITableViewStylePlain];
    }else{
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 51, self.loginNameTextField.width, self.loginNameTextField.height * 5) style:UITableViewStylePlain];
    }
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.layer.cornerRadius = 30;
    _tableView.layer.masksToBounds = YES;
    _tableView.layer.borderColor = JSMainDarkPuer.CGColor;
    _tableView.layer.borderWidth = 1;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.hidden = YES;
    
}

-(UITextField *)textFieldWithPlaceholder:(NSString *)placeholder andLeftViewName:(NSString *)name{
    
    UITextField *textFile = [[UITextField alloc] init];
    textFile.delegate = self;
    textFile.backgroundColor = [UIColor whiteColor];
    textFile.textColor = [UIColor grayColor];
    
    textFile.font = [UIFont systemFontOfSize:27];
    textFile.borderStyle = UITextBorderStyleNone;
    textFile.textAlignment = NSTextAlignmentLeft;
    
    textFile.width = 470;
    textFile.height = 58;
    textFile.placeholder = placeholder;
    
//    [textFile setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
//    
//    [textFile setValue:JSFont(27) forKeyPath:@"_placeholderLabel.font"];
    
    //这里不需要图.
    UIImageView *leftView = [[UIImageView alloc] init];
    leftView.image = [[UIImage imageNamed:name] scaleSize:CGSizeMake(37, 37)];
    leftView.backgroundColor = [UIColor clearColor];
    leftView.contentMode = UIViewContentModeCenter;
    leftView.width = leftView.height = 58;
    textFile.leftView = leftView;
    textFile.leftViewMode = UITextFieldViewModeAlways;
    return textFile;
}

//-(void)clickBoxButton:(UIButton *)sender{
//
//    sender.selected = !sender.isSelected;q//    //    }else{
//    //        [sender setBackgroundColor:JSColor(172, 172, 172, 1)];
//    //    }
//}

//-(void)touchForget:(UIButton *)sender{
//    [self.view endEditing:YES];
//    [self touchUpForget];
//}
//-(void)touchHelp:(UIButton *)sender{
//    [self.view endEditing:YES];
//    [self touchUpHelp];
//}

//点击登录之后的操作.
-(void)touchSureLogin:(UIButton *)sender{
    [self.view endEditing:YES];
    [self touchUpSureLogin];
}

//点击空白处 收起键盘.
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
    self.tableView.hidden = YES;
}



#pragma mark - textViewDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == self.loginNameTextField) {
        
        //点击到的时候 .此时应该弹出快捷选择页面.
        
        _tableView.hidden = NO;
        
        _tableView.centerX = self.loginNameTextField.centerX;
        
        _tableView.y = CGRectGetMaxY(self.loginNameTextField.frame) + 15;
        
    }
    
}

//保存登录记录.
-(void)saveInfoFor{
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    dic1[@"loginName"] = @"0000929fp1";
    dic1[@"stuName"] = @"董一泽";
//    dic1[@"centerName"] = @"武汉中心";
    dic1[@"passWord"] = @"798245";
//    dic1[@"birthday"] = @"20101108";
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    dic2[@"loginName"] = @"0000726fp1";
    dic2[@"stuName"] = @"牛浩哲";
//    dic2[@"centerName"] = @"北京首师大中心";
    dic2[@"passWord"] = @"152707";
//    dic2[@"birthday"] = @"20101108";
    
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
    dic3[@"loginName"] = @"0000722fp1";
    dic3[@"stuName"] = @"郑博轩";
//    dic3[@"centerName"] = @"北京崇文门中心";
    dic3[@"passWord"] = @"284778";
//    dic3[@"birthday"] = @"20101108";
    
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
    dic4[@"loginName"] = @"0000900fp1";
    dic4[@"stuName"] = @"柴浩轩";
//    dic4[@"centerName"] = @"北京崇文门中心";
    dic4[@"passWord"] = @"401197";
//    dic4[@"birthday"] = @"20101108";
    
    NSMutableDictionary *dic5 = [NSMutableDictionary dictionary];
    dic5[@"loginName"] = @"260061fp1";
    dic5[@"stuName"] = @"张翰涛";
//    dic5[@"centerName"] = @"武汉中心";
    dic5[@"passWord"] = @"6160";
//    dic5[@"birthday"] = @"20101108";
    NSMutableArray * stuArray = [NSMutableArray arrayWithObjects:dic1,dic2,dic3,dic4,dic5, nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:stuArray forKey:@"stuArray"];
}

//读取 登录记录  将所有学生全部保存到数组中进行保存.



/*
 
 ary stuArray
 
 */
-(void)loadInfo{
    
    NSMutableArray *stuArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"stuArray"];
    
    for (NSDictionary *dic in stuArray) {
        StudentsInfo *stu = [[StudentsInfo alloc] init];
        stu.loginName = dic[@"loginName"];
        stu.stuName = dic[@"stuName"];
//        stu.centerName = dic[@"centerName"];
        stu.passWord = dic[@"passWord"];
//        stu.birthday = dic[@"birthday"];
        [self.stuInfoModelArray addObject:stu];
    }
    
}


#pragma mark -  son class
//-(void)touchUpForget{
//
//}
//
//-(void)touchUpRember{
//
//}

//这里进行登录.
-(void)touchUpSureLogin{
    [SVProgressHUD showWithStatus:@"登录中"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"login_name"] = self.loginNameTextField.text;
    dic[@"password"] = self.passWordTextField.text;
    [[INetworking shareNet] GET:loginUrlStr withParmers:dic do:^(id returnObject, BOOL isSuccess) {
        if (isSuccess) {
            
            NSError *error;
            NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:returnObject options:NSJSONReadingMutableLeaves error:&error];
            if ([weatherDic[@"msg"] isEqualToString:@"登录成功"]) {
                NSArray *array = weatherDic[@"member"];
                NSDictionary *infoDic = array[0];
                //雨女无瓜
                //http://114.55.90.93:8081/web/app/qqblogin.json?login_name=caoyue20090507&password=18858171896
                //http://114.55.90.93:8081/web/app/qqblogin.json?Login_name=caoyue20090507&password=18858171896
                JSStudentInfoManager *manager = [JSStudentInfoManager manager];
                StudentsInfo *basic = [[StudentsInfo alloc] init];
                basic.loginName = infoDic[@"""login_name"""];
                basic.passWord = infoDic[@"password"];
                basic.birthday = infoDic[@"birthday"];
                basic.centerName = infoDic[@"center"];
                basic.stuID = [infoDic[@"id"] longValue];
                basic.stuName = infoDic[@"""stu_name"""];
                manager.basicInfo = basic;
                
                if([weatherDic[@"num"] isEqualToString:@"10"]){
                    manager.isOverToday = YES;
                }else{
                    manager.isOverToday = NO;
                }
                
                if([weatherDic[@"sdknum"] isEqualToString:@"10"]){
                    manager.isOverShudu = YES;
                }else{
                    manager.isOverShudu = NO;
                }
                
                [SVProgressHUD showSuccessWithStatus:@"登录成功"];
                [SVProgressHUD dismissWithDelay:.7 completion:^{
                    //暂时在这里进行登录之后的跳转网页操作.
                    [self flashUserDefault];
                    ShowMainViewController *v = [[ShowMainViewController alloc] init];
                    [self.navigationController pushViewController:v animated:YES];
//                    [UIApplication sharedApplication].keyWindow.rootViewController = v;
                }];
                
                
            }else{
                [SVProgressHUD showErrorWithStatus:@"账号密码错误"];
                [SVProgressHUD dismissWithDelay:.7];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
            [SVProgressHUD dismissWithDelay:.7];
        }
        
    }];

    //    //暂时在这里进行登录之后的跳转网页操作.
    //    ShowMainViewController *v = [[ShowMainViewController alloc] init];
    //
    //    [UIApplication sharedApplication].keyWindow.rootViewController = v;
    
    
}

//这里已经更新了学生的一些东西了.

-(void)flashUserDefault{
    
    NSMutableArray *stuArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"stuArray"];
    
    NSMutableArray *copyArray = stuArray.mutableCopy;
    
    for (NSMutableDictionary *dic in stuArray) {
        
        if ([dic[@"loginName"] isEqualToString:[JSStudentInfoManager manager].basicInfo.loginName]) {
            
            //如果有重复的.
            
            [copyArray removeObject:dic];
            
            break;
            
        }
        else{
            
            
        
        }
        
        
        
    }
    
    if (!copyArray) {
        copyArray = [NSMutableArray array];
    }
    
    
    
    JSStudentInfoManager *manager = [JSStudentInfoManager manager];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"loginName"] = manager.basicInfo.loginName;
    dic[@"stuName"] = manager.basicInfo.stuName;
    dic[@"passWord"] = manager.basicInfo.passWord;
    [copyArray addObject:dic];
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"stuArray"];
    
    [[NSUserDefaults standardUserDefaults] setObject:copyArray forKey:@"stuArray"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

#pragma mark - tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.stuInfoModelArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SelectStuTableViewCell *cell = [SelectStuTableViewCell cellForTableview:tableView];
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
    SelectStuTableViewCell *TrueCell = (SelectStuTableViewCell *)cell;
    TrueCell.model = self.stuInfoModelArray[indexPath.row];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.tableView.hidden = YES;
    
    StudentsInfo *stuInfo = self.stuInfoModelArray[indexPath.row];
    
    self.loginNameTextField.text = stuInfo.loginName;
    
    self.passWordTextField.text = stuInfo.passWord;
}

#pragma mark - dealloc;

-(void)dealloc{
    NSLog(@"登录界面dealloc");
}



@end
