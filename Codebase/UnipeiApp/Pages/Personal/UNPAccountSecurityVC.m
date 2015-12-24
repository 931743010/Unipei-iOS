//
//  UNPAccountSecurityVC.m
//  DymIOSApp
//
//  Created by xujun on 15/11/13.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UNPAccountSecurityVC.h"
#import "JPAppStatus.h"
#import <UnipeiApp-Swift.h>
#import "NSString+GGAddOn.h"
#import "GGPredicate.h"
#import "JPDesignSpec.h"
#import "UNPChangePasswordCell.h"

@interface UNPAccountSecurityVC ()
{
    UIButton              *_btnConfirm;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UNPChangePasswordCell *cell;

@end

@implementation UNPAccountSecurityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改密码";
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [JPDesignSpec colorSilver];
    
    _btnConfirm = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnConfirm.frame = CGRectMake(0, 0, 40, 30);
    [_btnConfirm setTitle:@"保存" forState:UIControlStateNormal];
    [_btnConfirm.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btnConfirm addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *confirm = [[UIBarButtonItem alloc] initWithCustomView:_btnConfirm];
    self.navigationItem.rightBarButtonItem = confirm;
    
}
#pragma mark - table数据源和代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 185;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellid = @"UNPChangePasswordCell";
    
    BOOL nibsRegisterd = NO;
    
    if (!nibsRegisterd) {
        
        UINib *nib = [UINib nibWithNibName:@"UNPChangePasswordCell" bundle:nil];
        
        [tableView registerNib:nib forCellReuseIdentifier:cellid];
        
        nibsRegisterd = YES;
    }
    _cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    _cell.backgroundColor = [JPDesignSpec colorSilver];
    _cell.tfOldPassword.delegate = self;
    _cell.tfNewPassword.delegate = self;
    _cell.tfNewPasswordAgain.delegate = self;
    _cell.tfOldPassword.placeholder = @"请输入原密码";
    _cell.tfNewPassword.placeholder = @"请输入新密码";
    _cell.tfNewPasswordAgain.placeholder = @"请重复新密码";
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return _cell;
    
}
#pragma mark - Pravite
-(void)confirm{
    
    BOOL isNewPwdAviliable = [GGPredicate stringIsAllSpace:_cell.tfNewPassword.text];

    if (_cell.tfOldPassword.text.length == 0 && _cell.tfNewPassword.text.length == 0 && _cell.tfNewPasswordAgain.text.length == 0) {
        [[JLToast makeTextQuick:@"未做任何修改，无需保存"] show];
    }else if (_cell.tfNewPassword.text.length == 0){
        [[JLToast makeTextQuick:@"请输入新密码"] show];
    }else if ( _cell.tfNewPassword.text.length < 6){
        [[JLToast makeTextQuick:@"新密码长度不正确，请重新设置"] show];
    }else if (isNewPwdAviliable){
        [[JLToast makeTextQuick:@"新密码格式不正确，请重新设置"] show];
    }else if (_cell.tfNewPasswordAgain.text.length == 0){
        [[JLToast makeTextQuick:@"请再次输入新密码"] show];
    }else if ( ![_cell.tfNewPasswordAgain.text isEqualToString:_cell.tfNewPassword.text]){
        [[JLToast makeTextQuick:@"两次输入的密码不一致"] show];
    }else if (_cell.tfNewPassword.text.length > 5 && [_cell.tfNewPassword.text isEqualToString:_cell.tfNewPasswordAgain.text]&& !isNewPwdAviliable) {
        
        DymCommonApi *api = [DymCommonApi new];
        api.relativePath = PATH_userApi_updatepassword;
        api.params = [NSDictionary dictionaryWithObjectsAndKeys:
                      [JPAppStatus loginInfo].userID,@"id",
                      _cell.tfOldPassword.text.md5Str,@"oldpassword",
                      _cell.tfNewPassword.text.md5Str,@"password",
                      nil];
        __weak typeof (self) weakSelf = self;
        
        _btnConfirm.enabled = NO;
        [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
            _btnConfirm.enabled = YES;
            if (result.success) {
                
                ShopApi_Login_Result *loginInfo = [JPAppStatus loginInfo];
                loginInfo.loginPassword = weakSelf.cell.tfNewPassword.text;
                [JPAppStatus archiveShopLoginResult:loginInfo];
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else if (result.msg) {
                [[JLToast makeTextQuick:result.msg] show];
            }
        }];
        
    }

    [_cell.tfOldPassword resignFirstResponder];
    [_cell.tfNewPassword resignFirstResponder];
    [_cell.tfNewPasswordAgain resignFirstResponder];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
