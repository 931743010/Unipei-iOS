//
//  SupplementInfo.m
//  DymIOSApp
//
//  Created by 沈梦月 on 15/12/27.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "SupplementInfo.h"
#import "JPSensibleButton.h"
#import "SupplementInfo.h"
#import <Masonry.h>
#import "SupplementInfoCell.h"
#import "SupplementInfoModel.h"
#import "SupplementInfoImage.h"
#import "JPAddPhotoView.h"
#import "UIView+Layout.h"
#import "JPAppStatus.h"
#import "JPAddPhotoView.h"
#import "InquiryApi_InquiryListUpdate.h"
#import "CommonApi_UploadImage.h"
#import <YTKNetwork/YTKBatchRequest.h>
#import <UNipeiApp-Swift.h>
#import "GGPredicate.h"

#define screen_Width [UIScreen mainScreen].bounds.size.width
#define screen_Height [UIScreen mainScreen].bounds.size.height
@interface SupplementInfo ()<UITableViewDataSource,UITableViewDelegate,supplementCellDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView        *_pickerView;
    NSArray             *_pickerArray;
    NSString            *_btnValue;
    NSInteger           _numTag;
    NSArray             *_userInfoArray;
    NSMutableDictionary *_uesrSelectDic;
    NSArray             *_succeededUploadAPIs;
    JPSensibleButton    *_submitBtn;
    JPAddPhotoView      *_addPhotosView;
    
}
@property(nonatomic,retain)UITableView *infoTab;
@end

@implementation SupplementInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.title = @"资料完善";
    [self initVC];
    _uesrSelectDic = [[NSMutableDictionary alloc]init];
}
-(UITableView *)infoTab{
    if (_infoTab == nil) {
        self.infoTab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_Width, screen_Height-64-60) style:UITableViewStylePlain];
        self.infoTab.dataSource = self;
        self.infoTab.delegate = self;
        self.infoTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _infoTab;
}
-(void)initVC{
    
    [self.view addSubview:self.infoTab];
    UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    alertLabel.text = @"*为必填项";
    alertLabel.textColor = [UIColor grayColor];
    alertLabel.font = [UIFont systemFontOfSize:12];
    alertLabel.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.4];
    self.infoTab.tableHeaderView = alertLabel;
    
    [self.infoTab registerNib:[UINib nibWithNibName:@"SupplementInfoCell" bundle:nil] forCellReuseIdentifier:@"cellName"];
    [self.infoTab registerNib:[UINib nibWithNibName:@"SupplementInfoImage" bundle:nil] forCellReuseIdentifier:@"cellImage"];
   
    //提交
    _submitBtn = [[JPSensibleButton alloc] initWithFrame:CGRectMake(10, screen_Height - 50- 65, screen_Width - 20, 40)];
    _submitBtn.backgroundColor = [UIColor orangeColor];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    _submitBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    _submitBtn.layer.cornerRadius = 3;
    [self.view addSubview:_submitBtn];
    [[_submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self commitInfo];
    }];
    [self loadPickerView];
 
}
-(BOOL)canCommit {
    
    UITextField *tfPhone = (UITextField *)[self.infoTab viewWithTag:303];
    UITextField *tfEmail = (UITextField *)[self.infoTab viewWithTag:304];
    if (![GGPredicate checkNumeric:tfPhone.text]) {
        [[JLToast makeTextQuick:@"座机号码格式不正确！"] show];
        [tfPhone becomeFirstResponder];
        return NO;
    } else if (![GGPredicate checkEmail:tfEmail.text]) {
        [[JLToast makeTextQuick:@"邮箱格式不正确！"] show];
        [tfEmail becomeFirstResponder];
        return NO;
    } else if ([_uesrSelectDic[@"5"] length] <= 0) {
        [[JLToast makeTextQuick:@"请选择成立年份！"] show];
        return NO;
    } else if ([_uesrSelectDic[@"6"] length] <= 0) {
        [[JLToast makeTextQuick:@"请选择店铺面积！"] show];
        return NO;
    } else if ([_uesrSelectDic[@"7"] length] <= 0) {
        [[JLToast makeTextQuick:@"请选择工位数!"] show];
        return NO;
    } else if ([_uesrSelectDic[@"8"] length] <= 0) {
        [[JLToast makeTextQuick:@"请选择技师人数!"] show];
        return NO;
    } else if ([_uesrSelectDic[@"9"] length] <= 0) {
        [[JLToast makeTextQuick:@"请选择停车位数!"] show];
        return NO;
    } else if (_addPhotosView.pickedPhotos.count <= 0) {
        [[JLToast makeTextQuick:@"请选择门店照片!"] show];
        return NO;
    }
    
    return YES;
}

-(NSMutableArray *)uploadedImageInfos {
    NSMutableArray *uploadedFileInfos = NSMutableArray.new;
    for (CommonApi_UploadImage *api in self->_succeededUploadAPIs) {
        CommonApi_UploadImage_Result *resp = api.responseModel;
        
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info setObjectSafe:resp.picPath forKey:@"path"];
        
        [uploadedFileInfos addObject:info];
    }
    
    return uploadedFileInfos;
}

-(void)uploadImages:(void(^)(BOOL success))completion {
    NSMutableArray *allRequests = [NSMutableArray array];
    for (UIImage *image in [_addPhotosView pickedPhotos]) {
        CommonApi_UploadImage *uploadImage = [[CommonApi_UploadImage alloc] initWithParams:
                                              @{@"pathType": @(kServerUploadPathShopOffice)
                                                , @"fileType": @(kJPUploadFileTypeJPEG)
                                                , @"name": [JPUtils randomDigitString]
                                                , @"image": image}];
        [allRequests addObject:uploadImage];
        [self.apiQueue addObject:uploadImage];
    }
    ///
    YTKBatchRequest *batch = [[YTKBatchRequest alloc] initWithRequestArray:allRequests];
    
    __weak typeof (self) weakSelf = self;
    [batch startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        
        __strong typeof (self) strongSelf = weakSelf;
        NSArray *requests = batchRequest.requestArray;
        
        NSMutableArray  *succeededAPIs = [NSMutableArray array];
        
        
        for (CommonApi_UploadImage *uploadImage in requests) {
            CommonApi_UploadImage_Result *resp = uploadImage.responseModel;
            if (resp.success) {
                [succeededAPIs addObject:uploadImage];
            }
        }
        strongSelf->_succeededUploadAPIs = succeededAPIs;
        
        if (completion) {
            completion(succeededAPIs.count > 0);
        }
        
    } failure:^(YTKBatchRequest *batchRequest) {
        if (completion) {
            completion(NO);
        }
    }];
}

-(void)commitInfo{
    
    [self.view endEditing:YES];
    
    @weakify(self)
    
    if (![self canCommit]) {
        return;
    }
    
    _submitBtn.enabled = NO;
    [self uploadImages:^(BOOL success) {
        
        @strongify(self)
        if (success) {
            
            if (self.loginInfo.organID && self.loginInfo.token) {
                UITextField *tfPhone = (UITextField *)[self.infoTab viewWithTag:303];
                UITextField *tfEmail = (UITextField *)[self.infoTab viewWithTag:304];
                DymCommonApi *api = [DymCommonApi new];
                api.apiVersion = @"V2.2";
                api.relativePath = PATH_userApi_putPerfectOrgan;
                
                NSArray *photos = [self uploadedImageInfos];
                
                NSString *foundDate = _uesrSelectDic[@"5"];
                foundDate = [foundDate stringByReplacingOccurrencesOfString:@"年" withString:@""];
                
                 api.params = @{
                                @"token": self.loginInfo.token
                                ,@"organID":self.loginInfo.organID
                                
                                ,@"serviceInfo":@{
                                     @"shopArea":_uesrSelectDic[@"6"]
                                    ,@"positionCount":_uesrSelectDic[@"7"]
                                    ,@"technicianCount":_uesrSelectDic[@"8"]
                                    ,@"parkingDigits":_uesrSelectDic[@"9"]

                                }
                                
                                ,@"organInfo":@{
                                     @"email":tfEmail.text
                                    ,@"foundDate":foundDate
                                    ,@"telphone":tfPhone.text
                                    ,@"parkingDigits":@""
                                    
                                }
                                
                                , @"organPhotos":photos
                             };
                
                @weakify(self)
                [[DymRequest commonApiSignal:api queue:nil] subscribeNext:^(DymBaseRespModel *result) {
                    @strongify(self)
                    self->_submitBtn.enabled = YES;
                    
                    if (result.success) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                }];
                
            } else {
                self->_submitBtn.enabled = YES;
            }
            
        } else {
            [[JLToast makeTextQuick:@"上传图片失败"] show];
            self->_submitBtn.enabled = YES;
        }
    }];

}
-(void)loadPickerView{
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-64, self.view.frame.size.width, 200)];
    _pickerView.delegate = self;
    _pickerView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    [self.view addSubview:_pickerView];

}
#pragma mark - 加载数据
-(void)loadData{
    @weakify(self);
    
    if (self.loginInfo.organID && self.loginInfo.token) {
        DymCommonApi *api = [DymCommonApi new];
        api.apiVersion = @"V2.2";
        api.relativePath = PATH_userApi_getPerfectOrgan;
        api.custom_organIdKey = @"organID";
        api.params = @{@"organID":self.loginInfo.organID, @"token": self.loginInfo.token};
        
        [[DymRequest commonApiSignal:api queue:nil] subscribeNext:^(DymBaseRespModel *result) {
            @strongify(self);
            if (result.success) {
                self->_userInfoArray = [SupplementInfoModel arrayWithUsurInfo:result.body];
                [self.infoTab reloadData];
            }
            
        }];
    }
    
}
#pragma mark -UITableViewDataSource协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 11;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 10) {
        SupplementInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellName"];
        if (indexPath.row <= 2) {
            cell.typeCell = 0;
            [cell configWithStr:[SupplementInfoModel arrayWithInfo][indexPath.row]andValue:_userInfoArray[indexPath.row]];
        }else if(indexPath.row <= 4){
            cell.typeCell = 1;
            cell.numTag = indexPath.row;
            [cell configWithStr:[SupplementInfoModel arrayWithInfo][indexPath.row]andValue:@"点击输入"];
        }else{
            cell.typeCell = 2;
            cell.delegate=self;
            cell.btnContent.tag = indexPath.row+200;
            if (indexPath.row == 5) {
                cell.dataArray = [SupplementInfoModel arrayWithYear];
            }else if (indexPath.row == 6){
                cell.dataArray = [SupplementInfoModel arrayWithArea];
            }else {
                cell.dataArray = [SupplementInfoModel arrayWithFactoryType];
            }
            
            NSString *value = [_uesrSelectDic valueForKey:[NSString stringWithFormat:@"%ld", indexPath.row]];
            [cell configWithStr:[SupplementInfoModel arrayWithInfo][indexPath.row]andValue:value.length ? value : @"点击选择"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        @weakify(self);
            SupplementInfoImage *cell = [tableView dequeueReusableCellWithIdentifier:@"cellImage"];
            [cell configWithStr:[SupplementInfoModel arrayWithInfo][indexPath.row]];
        
        if (_addPhotosView == nil) {
            _addPhotosView = (JPAddPhotoView *)[cell.contentView viewWithTag:100];
            _addPhotosView.presentingVC = self;
            _addPhotosView.maxPhotoCount = 5;
            _addPhotosView.buttonSize = 56;
            _addPhotosView.imagePickedBlock = ^(void) {
                @strongify(self)
                [self.infoTab reloadData];
            };
        }
        

        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 10) {
        return 140;
    }else{
        return 44;
    }
}
#pragma mark -supplementCellDelegate代理方法
-(void)showPickerViewWithDate:(NSArray *)array withTag:(NSInteger)num{
    _numTag = num;
    _pickerArray = array;
    [_pickerView reloadAllComponents];
    [UIView animateWithDuration:0.5 animations:^{
        self->_pickerView.y  = self.view.frame.size.height-200;

    }];

}
#pragma mark -pickerView代理方法
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _pickerArray.count;
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _pickerArray[row];
}
-(void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _btnValue = _pickerArray[row];
    [self.infoTab reloadData];
    [_uesrSelectDic setValue:_btnValue forKey:[NSString stringWithFormat:@"%ld",_numTag-200]];
    [UIView animateWithDuration:0.5 animations:^{
        self->_pickerView.y  = self.view.frame.size.height;
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
