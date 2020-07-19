//
//  loginViewController.h
//  qiqiaoban
//
//  Created by mac on 2019/3/19.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loginViewController : UIViewController

@property (nonatomic,retain) UIImageView *nameImageView;
@property (nonatomic,retain) UIImageView *logoImageView;
@property (nonatomic,retain) UILabel *titleLabelView;
@property (nonatomic,retain) UILabel *rightsLabel;

@property (nonatomic,retain) UITextField * loginNameTextField;
@property (nonatomic,retain) UITextField * passWordTextField;

@property (nonatomic,retain) UIButton *loginSureButton;
@property (nonatomic,retain) UIButton *remmberPassWord;
@property (nonatomic,retain) UIButton *forgetPassWord;
@property (nonatomic,retain) UIButton *helpButton;



-(void)touchUpForget;

-(void)touchUpRember;

-(void)touchUpSureLogin;

-(void)touchUpHelp;


@end
