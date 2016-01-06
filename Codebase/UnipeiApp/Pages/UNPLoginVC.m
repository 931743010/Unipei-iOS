//
//  UNPLoginVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPLoginVC.h"
#import "JPSubmitButton.h"
#import "JPAppStatus.h"
#import "GGPredicate.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "ShopApi_Login.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "DymStoryboard.h"
#import <UnipeiApp-Swift.h>
#import <Masonry/Masonry.h>
#import "JPSensibleButton.h"
#import "UNPRegistedVC.h"
#import "UNPAgreementVC.h"
#import "SupplementVC.h"


@interface UNPLoginVC () <UIPickerViewDataSource, UIPickerViewDelegate> {
    UIPickerView    *_pickerView;
    UIButton         *_btnServerInfo;
}

@property (weak, nonatomic) IBOutlet JPSubmitButton *btnLogin;
@property (weak, nonatomic) IBOutlet UIButton *btnPeek;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfUsername;
@property (weak, nonatomic) IBOutlet UIButton *btnRegiste;

@end

@implementation UNPLoginVC

-(void)setTestUserAndPwd {
    EJPServerEnv serverEnv = [JPServerApiURL serverEnv];
    if (serverEnv == kJPServerEnvTestDepartment) {
        _tfUsername.text = @"xlc100"; _tfPassword.text = @"123456";
    } else if (serverEnv == kJPServerEnvProduction) {
        _tfUsername.text = @"xlcjing"; _tfPassword.text = @"111111";
    } else {
        _tfUsername.text = @"weipp"; _tfPassword.text = @"123456";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btnLogin.style = kJPButtonOrange;
    
    
#if DEBUG
    [self setTestUserAndPwd];
#else
    _tfUsername.text = _tfPassword.text = nil;
#endif
    
    @weakify(self)
    [[self.btnPeek rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        self.btnPeek.selected = !self.btnPeek.selected;
        self.tfPassword.secureTextEntry = !self.btnPeek.selected;
    }];
    
    RACSignal *usernameValidSignal = [[self.tfUsername rac_textSignal] map:^id(NSString *value) {
        return @(value.length > 0); //@([GGPredicate checkPhoneNumber:value]);
    }];
    
    RACSignal *passwordValidSignal = [[self.tfPassword rac_textSignal] map:^id(NSString *value) {
        return @([GGPredicate checkPassword:value]);
    }];
    
    
    ///
    RAC(self.tfUsername, textColor) = [usernameValidSignal map:^id(NSNumber *usernameValid) {
        return [usernameValid boolValue] ? [UIColor blackColor] : [UIColor redColor];
    }];
    
    RAC(self.tfPassword, textColor) = [passwordValidSignal map:^id(NSNumber *passwordValid) {
        return [passwordValid boolValue] ? [UIColor blackColor] : [UIColor redColor];
    }];
    
    RACSignal *signInValidSignal = [RACSignal combineLatest:@[usernameValidSignal, passwordValidSignal] reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid){
        return @([usernameValid boolValue] && [passwordValid boolValue]);
    }];
    
    RAC(self.btnLogin, enabled) = signInValidSignal;
//    RAC(self.btnRegiste, enabled) = signInValidSignal;
    
//    [signInValidSignal subscribeNext:^(NSNumber *signInValid) {
//        @strongify(self)
//        self.btnLogin.enabled = [signInValid boolValue];
//    }];
    
    
    ///self.btn.rac_signal.do
    
    [[[[self.btnLogin
        
        rac_signalForControlEvents:UIControlEventTouchUpInside]
       
       doNext:^(id x) {
           @strongify(self)
           self.btnLogin.enabled = NO;
           [self.tableView endEditing:YES];
       }]
      
      flattenMap:^RACStream *(id value) {
          @strongify(self)
          return [self signInSignal];
      }]
     
     subscribeNext:^(ShopApi_Login_Result *result) {
         @strongify(self)
         self.btnLogin.enabled = YES;
         
         if ([result isKindOfClass:[ShopApi_Login_Result class]]) {
             
             if (result.success) { // 登录成功
                 
                 //
                 if ([result.status integerValue] == kJPLoginStatusNotActivated) {
                     // 未激活
                     UNPAgreementVC *vc = [UNPAgreementVC newFromStoryboard];
                     vc.loginInfo = result;
                     [self.navigationController pushViewController:vc animated:YES];
                     
                 } else if ([result.status integerValue] == kJPLoginStatusProfileNotCompleted) {
                     // 需要完善资料
                     SupplementVC *supplementVC = [SupplementVC newFromStoryboard];
                     supplementVC.loginInfo = result;
                     [self.navigationController pushViewController:supplementVC animated:YES];
                     
                 } else {
                     // 正常登录
                     
                     result.loginUsername = self.tfUsername.text;
                     result.loginPassword = self.tfPassword.text;
                     
                     [JPAppStatus archiveShopLoginResult:result];
                     NSLog(@">>>>>>>%@<<<<<<<<",[JPAppStatus loginInfo]);
                     
                     [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:JP_NOTIFICATION_USER_LOGGED_IN object:nil];
                 }
                 
                 
             } else if (result.msg) {//需要完善信息
                 
                [[JLToast makeText:result.msg] show];
                 
             }
             
         }
         
     }];
    
    //注册 跳注册页面
    [[self.btnRegiste rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        UNPRegistedVC *vc = [[UNPRegistedVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    ///
    [self updateServerPicker];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideServerPicker];
}


-(RACSignal *)signInSignal {
    
    id params = @{@"phone": self.tfUsername.text, @"password": self.tfPassword.text};
    return [DymRequest commonApiSignalWithClass:[ShopApi_Login class] queue:self.apiQueue params:params waitingMessage:@"登录中"];
}




#pragma mark - @protocol UIPickerViewDataSource<NSObject>

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [JPServerApiURL serverURLs].count;
}

#pragma mark -@protocol UIPickerViewDelegate<NSObject>

// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [JPServerApiURL descriptionForEnv:row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textColor = [UIColor colorWithWhite:0.9 alpha:1];
        pickerLabel.minimumScaleFactor = 0.5;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:13]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [JPServerApiURL setServerEnvironment:row];
    [self hideServerPicker];
    
#if DEBUG
    [self setTestUserAndPwd];
#endif
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

#pragma mark - server picker for debug
-(void)updateServerPicker {
    
    if (![JPAppStatus showServerList]) {
        return;
    }
    
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.alpha = 0;
    
    _btnServerInfo = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 25)];
    _btnServerInfo.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    [_btnServerInfo setTitleColor:[UIColor colorWithWhite:0.9 alpha:1] forState:UIControlStateNormal];
    _btnServerInfo.titleLabel.font = [UIFont systemFontOfSize:12];
    self.tableView.tableFooterView = _btnServerInfo;
    [_btnServerInfo setTitle:[JPServerApiURL descriptionForEnv:[JPServerApiURL serverEnv]] forState:UIControlStateNormal];
    [_btnServerInfo addTarget:self action:@selector(showServerPicker) forControlEvents:UIControlEventTouchUpInside];
}

-(void)showServerPicker {
    
    if (![JPAppStatus showServerList]) {
        return;
    }
    
    [_pickerView removeFromSuperview];
    [self.view.window addSubview:_pickerView];
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.and.bottom.equalTo(self.view.window);
        make.height.equalTo(@150);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        _pickerView.alpha = 1;
    }];
    
    [_pickerView selectRow:[JPServerApiURL serverEnv] inComponent:0 animated:NO];
}

-(void)hideServerPicker {
    _pickerView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        _pickerView.alpha = 0;
    } completion:^(BOOL finished) {
        [_pickerView removeFromSuperview];
        _pickerView.userInteractionEnabled = YES;
        
        [_btnServerInfo setTitle:[JPServerApiURL descriptionForEnv:[JPServerApiURL serverEnv]] forState:UIControlStateNormal];
    }];
}

@end
