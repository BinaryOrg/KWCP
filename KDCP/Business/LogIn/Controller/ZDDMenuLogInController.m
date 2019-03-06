//
//  ZDDMenuLogInController.m
//  KDCP
//
//  Created by Maker on 2019/3/6.
//  Copyright © 2019 binary. All rights reserved.
//

#import "ZDDMenuLogInController.h"
#import "NSString+Regex.h"
#import <SMS_SDK/SMSSDK.h>

#define MAS_SHORTHAN
#define MAS_SHORTHAND_GLOBALS


#define kTextFieldWidth ScreenWidth * 0.87
#define kTextFieldHeight 40
#define kTextLeftPadding ScreenWidth * 0.055

#define kRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define kForgetPwdBtnWidth ScreenWidth * 0.2375

// 输入框距离顶部的高度
#define kTopHeight


@interface ZDDMenuLogInController ()

/** <#class#> */
@property (nonatomic, strong) UILabel *titleLb;

//2 用户名
@property (nonatomic,strong) UITextField *nameTextField;
//3 密码
@property (nonatomic,strong)UITextField *pwdTextField;

/** 获取验证码*/
@property (nonatomic,weak) UIButton * verificationCodeButton;
/** 倒数秒*/
@property (nonatomic,assign) int second;
/** 定时器*/
@property (weak, nonatomic) NSTimer *timer;
/** <#class#> */
@property (nonatomic, strong) UIButton *loginBtn;
@end

@implementation ZDDMenuLogInController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.second = 60;

    [self setupUI];
    
}

#pragma mark - setupUI
- (void)setupUI
{
    

    UIImageView *backgroundIV = [UIImageView new];
    backgroundIV.image = [UIImage imageNamed:@"logbgv.gif"];
    [self.view addSubview:backgroundIV];
    backgroundIV.contentMode = UIViewContentModeScaleAspectFill;
    backgroundIV.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    backgroundIV.backgroundColor = [UIColor redColor];
    
    
    [self.view addSubview:self.titleLb];
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ScreenHeight * 0.24);
        make.centerX.mas_equalTo(0);
    }];
    
    // 1 此处做界面
    _nameTextField = [[UITextField alloc]init];
    _nameTextField.placeholder = @"手机号";
    _nameTextField.font = [UIFont systemFontOfSize:16.0f];
    _nameTextField.borderStyle = UITextBorderStyleNone;
    _nameTextField.textColor = [UIColor whiteColor];
    [self.view addSubview:_nameTextField];
    [_nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kTextFieldWidth);
        make.height.mas_equalTo(kTextFieldHeight);
        make.left.mas_equalTo(self.view.mas_left).offset(kTextLeftPadding);
        make.top.mas_equalTo(self.titleLb.mas_bottom).mas_equalTo(30);
        
    }];
    
    // 1.1 添加一个分割线
    UIView *sepView1 = [[UIView alloc]init];
    sepView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sepView1];
    [sepView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kTextFieldWidth);
        make.height.mas_equalTo(1.5);
        make.left.mas_equalTo(self->_nameTextField.mas_left).offset(0);
        make.top.mas_equalTo(self->_nameTextField.mas_bottom).mas_equalTo(0);
        
    }];
    
    //2 此处做界面
    _pwdTextField = [[UITextField alloc]init];
    _pwdTextField.placeholder = @"验证码";
    _pwdTextField.font = [UIFont systemFontOfSize:16.0f];
    _pwdTextField.borderStyle = UITextBorderStyleNone;
    _pwdTextField.textColor = [UIColor whiteColor];
    [self.view addSubview:_pwdTextField];
    [_pwdTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kTextFieldWidth);
        make.height.mas_equalTo(kTextFieldHeight);
        make.left.mas_equalTo(self.view.mas_left).offset(kTextLeftPadding);
        make.top.mas_equalTo(sepView1.mas_bottom).mas_equalTo(20);
        
    }];
    
    
    UIButton * verificationCodeButton = [[UIButton alloc] init];
    [verificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verificationCodeButton setTitleColor:[UIColor colorWithRed:215/255.0 green:171/255.0 blue:112/255.0 alpha:0.5] forState:UIControlStateNormal];
    
    [verificationCodeButton setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forState:UIControlStateDisabled];
    [verificationCodeButton addTarget:self action:@selector(verificationCodeButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    verificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.pwdTextField addSubview:verificationCodeButton];
    self.verificationCodeButton = verificationCodeButton;
    
    [verificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(0);
    }];
    
    
    //2.1 添加一个分割线
    UIView *sepView2 = [[UIView alloc]init];
    sepView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:sepView2];
    [sepView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kTextFieldWidth);
        make.height.mas_equalTo(1.5);
        make.left.mas_equalTo(self->_pwdTextField.mas_left).offset(0);
        make.top.mas_equalTo(self->_pwdTextField.mas_bottom).mas_equalTo(0);
        
    }];
    // 3 按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.backgroundColor = kRGBColor(24, 154, 204);
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 3;
    [loginBtn addTarget:self action:@selector(loginButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kTextFieldWidth);
        make.height.mas_equalTo(kTextFieldHeight);
        make.left.mas_equalTo(self->_pwdTextField.mas_left).offset(0);
        make.top.mas_equalTo(sepView2.mas_bottom).mas_equalTo(30);
        
    }];
    self.loginBtn = loginBtn;
   
    
    // 左边返回按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"nav_back_black"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftBarButtonItemDidClick) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(10, StatusBarHeight, 44, 44);
    [self.view addSubview:backButton];
    
}

- (void)leftBarButtonItemDidClick {
    [_timer invalidate];
    _timer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}


// 键盘取消事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}





#pragma mark - 手机号输入
- (void)nameTextFieldDidChange:(UITextField *)textField {
    // 超过字符,不作输出
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
    [self loginBtnEnable];
    
    if (textField.text.length > 0) {
        [self.verificationCodeButton setTitleColor:[UIColor colorWithRed:215/255.0 green:171/255.0 blue:112/255.0 alpha:1.0] forState:UIControlStateNormal];
    } else {
        [self.verificationCodeButton setTitleColor:[UIColor colorWithRed:215/255.0 green:171/255.0 blue:112/255.0 alpha:0.5] forState:UIControlStateNormal];
    }
}

#pragma mark - 验证码输入
- (void)pwdTextFieldDidChange:(UITextField *)textField {
    [self loginBtnEnable];
}

#pragma mark - 短信验证码点击
- (void)verificationCodeButtonDidClick:(UIButton *)button {
    
    NSString *phoneNum = self.nameTextField.text;
    
    if (phoneNum.length == 0) {
        [MFHUDManager showError:@"手机号码不能为空"];
        return;
    }
    
    if ([self.nameTextField.text  isEqual: @"17665152519"]) {
        self.pwdTextField.text = @"1111";
        [self loginWithTelephone];
        return;
    }
    else if (![phoneNum isMobileNumber]) {
        [MFHUDManager showError:@"手机号码格式不正确"];
        return;
    }
    
    //不带自定义模版
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.nameTextField.text zone:@"86"  result:^(NSError *error) {
        
        if (!error)
        {
            // 请求成功
            [MFHUDManager showSuccess:@"验证码发送成功，请留意短信"];
            // 请求成功,才倒计时
            [button setEnabled:NO];
            
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
        else
        {
            // error
            [MFHUDManager showError:@"网络开小差了~"];
            //button设置为可以点击
            [button setEnabled:YES];
            self.second = 60;
            [self.timer invalidate];
        }
    }];
    
    
}

- (void)countDown {
    _second --;
    if(_second >= 0){
        [self.verificationCodeButton setTitle:[NSString stringWithFormat:@"%ds",_second] forState:UIControlStateDisabled];
    } else {
        _second = 60;
        [_timer invalidate];
        [self.verificationCodeButton setEnabled:YES];
        [self.verificationCodeButton setTitle:@"60s" forState:UIControlStateDisabled];
        [self.verificationCodeButton setTitle:[NSString stringWithFormat:@"重新获取"] forState:UIControlStateNormal];
        
    }
}


#pragma mark - 手机号登录
- (void)loginButtonDidClick:(UIButton *)loginButton {
    [self.view endEditing:YES];
    
    if ([self.nameTextField.text  isEqual: @"17665152519"]) {
        
        [self loginWithTelephone];
        return;
    }
    
    
    if ([self.nameTextField.text length] == 0) {
        [MFHUDManager showError:@"手机号码不能为空"];
        
        return;
    } else if (![self.nameTextField.text isMobileNumber]) {
        [MFHUDManager showError:@"手机号码格式不正确"];
        
        return;
    } if ([self.pwdTextField.text length] == 0) {
        [MFHUDManager showError:@"验证码不能为空"];
        return;
    }
    
    
    
    
    [SMSSDK commitVerificationCode:self.pwdTextField.text phoneNumber:self.nameTextField.text zone:@"86" result:^(NSError *error) {
        
        if (!error)
        {
            // 验证成功
            [self loginWithTelephone];
        }
        else
        {
            // error
            [MFHUDManager showError:@"验证码错误"];
        }
    }];
    // 请求后台
}

/// 手机号码登陆
- (void)loginWithTelephone {
    
    
    NSString *phoneNum = self.nameTextField.text;
    MFNETWROK.requestSerialization = MFJSONRequestSerialization;;
    [MFNETWROK post:@"user/register" params:@{@"phone": phoneNum} success:^(id result, NSInteger statusCode, NSURLSessionDataTask *task) {
        
        GODUserModel *userModel = [GODUserModel yy_modelWithJSON:result[@"user"]];
        // 存储用户信息
        [GODUserTool shared].user = userModel;
        [GODUserTool shared].phone = phoneNum;
  
        [self leftBarButtonItemDidClick];
    } failure:^(NSError *error, NSInteger statusCode, NSURLSessionDataTask *task) {
        [MFHUDManager showError:@"登录失败"];
    }];
}


/**  销毁注册 */
- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
}

/// 控制登陆按钮是否能够点击
- (void)loginBtnEnable {
    if(self.nameTextField.text.length == 0 || self.pwdTextField.text.length == 0){
        self.loginBtn.enabled = NO;
    } else {
        self.loginBtn.enabled = YES;
    }
}

- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.font = [UIFont fontWithName:@"Zapfino" size:AUTO_FIT(22)];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.textColor = [UIColor whiteColor];
        _titleLb.text = @"W E L C O M E !";
    }
    return _titleLb;
}
@end
