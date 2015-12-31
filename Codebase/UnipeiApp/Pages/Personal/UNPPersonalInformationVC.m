//
//  UNPPersonalInformationVC.m
//  DymIOSApp
//
//  Created by xujun on 15/11/13.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UNPPersonalInformationVC.h"
#import "UNPPersonalInformationCell.h"
#import "UNPTextModifyVC.h"
#import "UNPAccountSecurityVC.h"
#import "JPUtils.h"
#import "JPDesignSpec.h"
#import "JPAppStatus.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CommonApi_UploadImage.h"
#import "JPDesignSpec.h"
#import "UIImagePickerController+Helper.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>



@interface UNPPersonalInformationVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSArray                     *_titleArray;
    UIImagePickerController     *_picker;
    ShopApi_Login_Result        *_loginInfo;
    NSDictionary                *_data;
    NSArray                     *_infoArr;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UNPPersonalInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"账户信息";
    
    _tableView.backgroundColor = [JPDesignSpec colorSilver];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSString *isMain = [JPAppStatus loginInfo].isMain;
    if ([isMain integerValue] == 1) {
        _tableView.userInteractionEnabled = YES;
    }else{
        _tableView.userInteractionEnabled = NO;
    }
    
    _titleArray = @[@[@"头像",@"用户名",@"机构名称",@"邮箱地址",@"QQ",@"手机",@"传真"],@[@"账户安全"]];
    
    [self getPersonalInformation];

}
//获取数据
-(void)getPersonalInformation{
    
    DymCommonApi *api = [DymCommonApi new];
    api.relativePath = PATH_userApi_findOrganAndUserInfo;
    api.params = @{@"username": [JPAppStatus loginInfo].loginUsername};
//    api.organIdKey = @"organID";
    
    __weak typeof (self) weakSelf = self;
    [self showLoadingView:YES];
    [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
        __strong typeof (self) strongSelf = weakSelf;
        [strongSelf showLoadingView:NO];
        
        if (result.success) {
            _data = result.body[@"organAndUserVo"];

            _loginInfo = [JPAppStatus loginInfo];
            
            _loginInfo.email = _data[@"email"];
            _loginInfo.logo = _data[@"logo"];
            _loginInfo.organName = _data[@"organname"];
            _loginInfo.phone = _data[@"phone"];
            _loginInfo.qq = _data[@"qq"];
            _loginInfo.fax = _data[@"fax"];
            _loginInfo.code = result.code;
            
            [JPAppStatus archiveShopLoginResult:_loginInfo];
            [strongSelf.tableView reloadData];
            
        }
    }];

    
}
#pragma mark - UITableViewDatasource and delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        return 7;
    }return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 0;
    }return 8;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 48;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellid = @"UNPPersonalInformationCell";
    
    BOOL nibsRegisterd = NO;
    
    if (!nibsRegisterd) {
        
        UINib *nib = [UINib nibWithNibName:@"UNPPersonalInformationCell" bundle:nil];
        
        [tableView registerNib:nib forCellReuseIdentifier:cellid];
        
        nibsRegisterd = YES;
    }

    UNPPersonalInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            cell.lblContent.hidden = YES;
            cell.ivHead.hidden = NO;
            cell.ivHead.layer.masksToBounds = YES;
            cell.ivHead.layer.cornerRadius = 15;
            NSString *imageURL = [JPUtils fullMediaPath:[JPAppStatus loginInfo].logo];
            [cell.ivHead sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"icon_logo_white"]];
            
        }else if (indexPath.row == 1){
            
            cell.ivSide.hidden = YES;
            cell.lblContent.text = [JPAppStatus loginInfo].loginUsername;
            
        }else if (indexPath.row == 2){
            cell.ivSide.hidden = YES;
            cell.lblContent.text = _loginInfo.organName;
        }else if (indexPath.row == 3){
            cell.lblContent.text = _loginInfo.email;
        }else if (indexPath.row == 4){
            cell.lblContent.text = _loginInfo.qq;
        }else if (indexPath.row == 5){
            cell.lblContent.text = _loginInfo.phone;
        }else if (indexPath.row == 6){
            cell.lblContent.text = _loginInfo.fax;
        }
    }else if (indexPath.section == 1){
        
        cell.lblContent.text = @"修改密码";
        
    }
    cell.lblContent.textColor = [JPDesignSpec colorGrayDark];
    cell.lblTitle.text = _titleArray[indexPath.section][indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            [UIImagePickerController pickImageWithDelegate:self presentingVC:self];
            
        }else if (indexPath.row == 3||indexPath.row == 4||indexPath.row == 5||indexPath.row == 6) {
            
            UNPTextModifyVC *vc = [[UNPTextModifyVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            
            __weak typeof (self) weakSelf = self;

            if (indexPath.row == 2) {
                
                vc.modifyType = kJPTextModifyTypeOrganizationname;
                vc.textModifiedBlock = ^(NSString *modifiedText, EJPTextModifyType modifyType) {
                    //机构名
                    _loginInfo.organName = modifiedText;
                    
                    [JPAppStatus archiveShopLoginResult:_loginInfo];
                    [weakSelf.tableView reloadData];
                };
            }else if (indexPath.row == 3){
                
                vc.modifyType = kJPTextModifyTypeEmailadress;
                vc.textModifiedBlock = ^(NSString *modifiedText, EJPTextModifyType modifyType) {
                    //邮箱
                    _loginInfo.email = modifiedText;
                    
                    [JPAppStatus archiveShopLoginResult:_loginInfo];
                    [weakSelf.tableView reloadData];

                };
            }else if (indexPath.row == 4){
                
                vc.modifyType = kJPTextModifyTypeQQnumber;
                vc.textModifiedBlock = ^(NSString *modifiedText, EJPTextModifyType modifyType) {
                    //qq号
                    _loginInfo.qq = modifiedText;
                    
                    [JPAppStatus archiveShopLoginResult:_loginInfo];
                    [weakSelf.tableView reloadData];

                };
            }else if (indexPath.row == 5){
                
                vc.modifyType = kJPTextModifyTypePhone;
                vc.textModifiedBlock = ^(NSString *modifiedText, EJPTextModifyType modifyType) {
                    //电话号码
                    _loginInfo.phone = modifiedText;
                    
                    [JPAppStatus archiveShopLoginResult:_loginInfo];
                    [weakSelf.tableView reloadData];

                };
            }else if (indexPath.row == 6){
                
                vc.modifyType = kJPTextModifyTypeFax;
                vc.textModifiedBlock = ^(NSString *modifiedText, EJPTextModifyType modifyType) {
                    //传真
                    _loginInfo.fax = modifiedText;
                    
                    [JPAppStatus archiveShopLoginResult:_loginInfo];
                    [weakSelf.tableView reloadData];

                };
            }
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        }
    }else if (indexPath.section == 1){
        
        UNPAccountSecurityVC *vc = [[UNPAccountSecurityVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}
-(BOOL) checkAlbumAuthorization{
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    switch (status) {
        case ALAuthorizationStatusNotDetermined: {
            return NO;
            break;
        }
        case ALAuthorizationStatusRestricted: {
            return NO;
            break;
        }
        case ALAuthorizationStatusDenied: {
            return NO;
            break;
        }
        case ALAuthorizationStatusAuthorized: {
            return YES;
            break;
        }
        default: {
            return NO;
            break;
        }
    }
}

#pragma Delegate method UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
//    if([self checkAlbumAuthorization]){
        UIImage *img = [UIImagePickerController savePickingMediaWithInfo:info];
        
//        if(img){
            [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
//        }
    
//    }
    
 
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

//Cancel取消选择图片
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Pravite
-(void)saveImage:(UIImage *)image{

    CommonApi_UploadImage *uploadImage = [[CommonApi_UploadImage alloc] initWithParams:
                                            @{@"pathType": @(kServerUploadPathAvatar)
                                            , @"fileType": @(kJPUploadFileTypeJPEG)
                                            , @"name": [JPUtils randomDigitString]
                                            , @"image": image}];
    [self.apiQueue addObject:uploadImage];

    [[DymRequest commonApiSignal:uploadImage queue:self.apiQueue waitingMessage:@"头像修改中"] subscribeNext:^(CommonApi_UploadImage_Result *result){
        if (result.success) {
            
            NSLog(@"文件上传成功");
            DymCommonApi *api = [DymCommonApi new];
            api.relativePath = PATH_userApi_updateOrganInfo;
            api.params = @{@"logo":result.picPath};
            api.custom_organIdKey = @"id";
            
            __weak typeof (self) weakSelf = self;
            [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
                __strong typeof (self) strongSelf = weakSelf;
                if (result.success) {
                    
                    [strongSelf getPersonalInformation];

                }
            }];
        }
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
