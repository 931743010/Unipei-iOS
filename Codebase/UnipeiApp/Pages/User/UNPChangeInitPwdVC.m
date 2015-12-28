//
//  UNPChangeInitPwdVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/12/28.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UNPChangeInitPwdVC.h"
#import "JPSubmitButton.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <UnipeiApp-Swift.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "NSString+GGAddOn.h"

@interface UNPChangeInitPwdVC ()
@property (weak, nonatomic) IBOutlet UITextField *tfPwdOld;
@property (weak, nonatomic) IBOutlet UITextField *tfPwdNew;
@property (weak, nonatomic) IBOutlet UITextField *tfPwdNewComf;
@property (weak, nonatomic) IBOutlet JPSubmitButton *btnNext;

@end

@implementation UNPChangeInitPwdVC

+(instancetype)newFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Unipei_User" bundle:nil] instantiateViewControllerWithIdentifier:@"UNPChangeInitPwdVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改初始密码";
    
    _btnNext.style = kJPButtonOrange;
    
    self.tableView.estimatedRowHeight = 44;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    RAC(_btnNext, enabled) = [RACSignal combineLatest:@[
                                                        [[_tfPwdOld rac_textSignal] map:^id(NSString *text) {
                                                            return @(text.length > 5);
                                                        }]
                                                        
                                                        , [[_tfPwdNew rac_textSignal] map:^id(NSString *text) {
                                                            return @(text.length > 5);
                                                        }]
                                                        
                                                        , [[_tfPwdNewComf rac_textSignal] map:^id(NSString *text) {
                                                            return @(text.length > 5);
                                                        }]
                                                        ] reduce:^id(NSNumber *b1, NSNumber *b2, NSNumber *b3) {
                                                            
                                                            return @([b1 boolValue] && [b2 boolValue] && [b3 boolValue]);
    }];
    
    @weakify(self)
    [[_btnNext rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self actionChangeInitPwd];
    }];
}

-(void)actionChangeInitPwd {
    
    [self.view endEditing:YES];
    
    if ([_tfPwdOld.text isEqualToString:_tfPwdNew.text]) {
        [[JLToast makeTextQuick:@"新密码不可与原密码相同"] show];
    } else if (![_tfPwdNew.text isEqualToString:_tfPwdNewComf.text]) {
        [[JLToast makeTextQuick:@"两次输入的新密码不一致"] show];
    } else if (self.loginInfo.userID && self.loginInfo.token){
        DymCommonApi *api = [DymCommonApi new];
        api.relativePath = @"userApi/updateInitPassword.do";
        api.params = @{@"userID": self.loginInfo.userID, @"token": self.loginInfo.token, @"oldPassword": _tfPwdOld.text.md5Str, @"password": _tfPwdNew.text.md5Str};
        api.apiVersion = @"V2.2";
        
        @weakify(self)
        [SVProgressHUD showWithStatus:@"修改中"];
        _btnNext.enabled = NO;
        [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
            @strongify(self)
            
            self.btnNext.enabled = YES;
            
            if (result.success) {
                
                [[JLToast makeText:@"🌟🌟🌟跳到资料完善页面🌟🌟🌟"] show];
                
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                
            } else if (result.msg) {
                
                [[JLToast makeTextQuick:result.msg] show];
                
                [SVProgressHUD dismiss];
            }
        }];
    }
}

@end
