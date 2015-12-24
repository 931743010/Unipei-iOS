//
//  UNPPersonalPushVC.m
//  DymIOSApp
//
//  Created by xujun on 15/11/13.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UNPTextModifyVC.h"
#import "GGPredicate.h"
#import <UnipeiApp-Swift.h>
#import "JPAppStatus.h"
#import "JPDesignSpec.h"
#import "JPUtils.h"


@interface UNPTextModifyVC ()
{
    NSArray                     *_annotationArr;
    NSArray                     *_paramArray;
    NSArray                     *_titleArray;
    NSArray                     *_contentArray;
    UIButton                    *_btnConfirm;
}
@end

@implementation UNPTextModifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnConfirm.frame = CGRectMake(0, 0, 40, 30);
    [_btnConfirm setTitle:@"保存" forState:UIControlStateNormal];
    [_btnConfirm.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnConfirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *confirm = [[UIBarButtonItem alloc] initWithCustomView:_btnConfirm];
    self.navigationItem.rightBarButtonItem = confirm;
    self.navigationItem.rightBarButtonItem = confirm;
     _annotationArr = @[@"最多20个字符，可由中英文、数字、符号组成"
                        , @"请输入正确邮箱地址，最多30个字符"
                        , @"只能由数字组成"
                        , @"请输入11位手机号码"
                        , @"请输入正确号码，只能由数字、-组成"];
    _titleArray = @[@"修改机构名",@"修改邮箱",@"修改QQ号",@"修改手机号",@"修改传真"];
    _paramArray = @[@"organname",@"email",@"qq",@"phone",@"fax"];
    
    ShopApi_Login_Result *loginInfo = [JPAppStatus loginInfo];
    _contentArray = @[loginInfo.organName,loginInfo.email,loginInfo.qq,loginInfo.phone,loginInfo.fax];
   
    [self setCurrentUI];
}
//判断_modifyType设置textfield的键盘类型
-(void)setCurrentUI{
    
    self.navigationItem.title = _titleArray[_modifyType];
    
    _lblAnnotation.text = _annotationArr[_modifyType];
    _lblAnnotation.textColor = [JPDesignSpec colorGrayDark];
    _textField.text = _contentArray[_modifyType];
    
    if (_modifyType == kJPTextModifyTypeQQnumber){
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.maxLength = 16;
    }else if ( _modifyType == kJPTextModifyTypeFax){
        _textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _textField.maxLength = 15;
    }else if (_modifyType == kJPTextModifyTypeEmailadress){
        _textField.keyboardType = UIKeyboardTypeEmailAddress;
        _textField.maxLength = 30;
    }else if (_modifyType == kJPTextModifyTypePhone){
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.maxLength = 11;
    }else if (_modifyType == kJPTextModifyTypeOrganizationname){
        _textField.maxLength = 20;
    }
    
}
//修改个人信息网络请求
-(void)confirm{
    
    BOOL isRight;
    
    if (_modifyType == kJPTextModifyTypeOrganizationname) {
        isRight = [GGPredicate stringIsAllSpace:_textField.text];
        if (_textField.text.length == 0||isRight) {
            [[JLToast makeTextQuick:@"请输入机构名称"] show];
        }else{
            if ([JPUtils isContainsEmoji:_textField.text]){
                [[JLToast makeTextQuick:@"请输入正确的机构名"] show];
            }else {
                [self doRequest];
            }
        }
    }else if (_modifyType == kJPTextModifyTypePhone) {
        isRight = [GGPredicate checkPhoneNumber:_textField.text];
        if (isRight) {
            [self doRequest];
        }else{
            [[JLToast makeTextQuick:@"请输入正确的手机号"] show];
        }
    }else if(_modifyType == kJPTextModifyTypeEmailadress){
        isRight = [GGPredicate checkEmail:_textField.text];
        if (_textField.text.length == 0) {
            [self doRequest];
        }else{
            if (isRight) {
                [self doRequest];
            }else{
                [[JLToast makeTextQuick:@"请输入正确的邮箱"] show];
            }
        }
    }else if (_modifyType == kJPTextModifyTypeQQnumber){
        isRight = [GGPredicate checkQQ:_textField.text];
        if (_textField.text.length == 0) {
            [self doRequest];
        }else {
            if (isRight) {
                [self doRequest];
            }else{
                [[JLToast makeTextQuick:@"请输入正确的QQ号"] show];
            }
        }
    }else if(_modifyType == kJPTextModifyTypeFax){
        isRight = [GGPredicate checkFAX:_textField.text];
        if (_textField.text.length == 0) {
            [self doRequest];
        }else{
            if (isRight) {
                [self doRequest];
            }else{
                [[JLToast makeTextQuick:@"请输入正确的传真号"] show];
            }
        }
    }
    [_textField resignFirstResponder];
    
}
-(void)doRequest{

    DymCommonApi *api = [DymCommonApi new];
    api.relativePath = PATH_userApi_updateOrganInfo;
    api.params = @{_paramArray[_modifyType]:_textField.text};
    api.custom_organIdKey = @"id";
    
    __weak typeof (self) weakSelf = self;
    [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
        __strong typeof (self) strongSelf = weakSelf;
        if (result.success) {
            
            [strongSelf.navigationController popViewControllerAnimated:YES];
            
            if (strongSelf.textModifiedBlock) {
                strongSelf.textModifiedBlock(strongSelf.textField.text, strongSelf.modifyType);
            }
        }else if (result.msg){
            [[JLToast makeTextQuick:result.msg] show];
        }
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
