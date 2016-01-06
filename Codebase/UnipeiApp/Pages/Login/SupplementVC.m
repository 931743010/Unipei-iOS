//
//  SupplementVC.m
//  DymIOSApp
//
//  Created by 沈梦月 on 15/12/29.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "SupplementVC.h"
#import "JPSensibleButton.h"
#import "InquiryApi_InquiryListUpdate.h"
#import "CommonApi_UploadImage.h"
#import <YTKNetwork/YTKBatchRequest.h>
#import <UNipeiApp-Swift.h>
#import "GGPredicate.h"
#import "JPAppStatus.h"
#import "JPAddPhotoView.h"
#import "UIView+Layout.h"
#import "SupplementInfoModel.h"
@interface SupplementVC ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
   NSArray             *_succeededUploadAPIs;
   UITableViewCell     *_choosePhotosCell;
   NSArray             *_pickerArray;
   UIPickerView        *_pickerView;
   UITextField        *_evenTf;
  
}
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *telphoneTf;
@property (weak, nonatomic) IBOutlet UITextField *emailTf;
@property (weak, nonatomic) IBOutlet UITextField *yearTf;
@property (weak, nonatomic) IBOutlet UITextField *areaTf;
@property (weak, nonatomic) IBOutlet UITextField *positionCountTf;
@property (weak, nonatomic) IBOutlet UITextField *technicianCountTf;
@property (weak, nonatomic) IBOutlet UITextField *parkingDigitsTf;
@property (weak, nonatomic) IBOutlet JPAddPhotoView *addPhotosView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@end

@implementation SupplementVC
+(instancetype)newFromStoryboard{
    return [[UIStoryboard storyboardWithName:@"Unipei_User" bundle:nil]instantiateViewControllerWithIdentifier:@"SupplementVC"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.navigationItem.title = @"资料完善";
    self.tableView.bounces = NO;
    self.submitBtn.layer.cornerRadius = 3;
    [self initCells];
    [[_submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self submitInfo];
    }];
    //
    _pickerView = [[UIPickerView alloc]init];
    _pickerView.delegate = self;
    self.yearTf.inputView = self.areaTf.inputView = self.positionCountTf.inputView = self.technicianCountTf.inputView = self.parkingDigitsTf.inputView = _pickerView;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectWithPicker:) name:UITextFieldTextDidBeginEditingNotification object:nil];
}
-(void)initCells{
    @weakify(self)
        _addPhotosView.presentingVC = self;
        _addPhotosView.maxPhotoCount = 5;
        _addPhotosView.buttonSize = 56;
        _addPhotosView.imagePickedBlock = ^(void) {
            @strongify(self)
            [self.tableView reloadData];
        };
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
-(void)selectWithPicker:(NSNotification *)notification{
     _evenTf = notification.object;
    if ([notification.object isEqual:self.yearTf]){
        _pickerArray = [SupplementInfoModel arrayWithYear];
    }else if ([notification.object isEqual:self.areaTf]){
       _pickerArray = [SupplementInfoModel arrayWithArea];
    }else {
        _pickerArray = [SupplementInfoModel arrayWithFactoryType];

    }
    [_pickerView reloadAllComponents];
   
    
}
-(void)submitInfo{
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
                DymCommonApi *api = [DymCommonApi new];
                api.apiVersion = @"V2.2";
                api.relativePath = PATH_userApi_putPerfectOrgan;
                
                NSArray *photos = [self uploadedImageInfos];
                
                NSString *foundDate = self.yearTf.text;
                foundDate = [foundDate stringByReplacingOccurrencesOfString:@"年" withString:@""];
                
                api.params = @{
                               @"token": self.loginInfo.token
                               ,@"organID":self.loginInfo.organID
                               
                               ,@"serviceInfo":@{
                                       @"shopArea":self.yearTf.text
                                       ,@"positionCount":self.positionCountTf.text
                                       ,@"technicianCount":self.technicianCountTf.text
                                       ,@"parkingDigits":self.parkingDigitsTf.text
                                       
                                       }
                               
                               ,@"organInfo":@{
                                       @"email":self.emailTf.text
                                       ,@"foundDate":foundDate
                                       ,@"telphone":self.telphoneTf.text
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
-(BOOL)canCommit {

    if (![GGPredicate checkNumeric:self.telphoneTf.text]) {
        [[JLToast makeTextQuick:@"座机号码格式不正确！"] show];
        [self.telphoneTf becomeFirstResponder];
        return NO;
    } else if (![GGPredicate checkEmail:self.emailTf.text]) {
        [[JLToast makeTextQuick:@"邮箱格式不正确！"] show];
        [self.emailTf becomeFirstResponder];
        return NO;
    } else if ([self.yearTf.text length] <= 0) {
        [[JLToast makeTextQuick:@"请选择成立年份！"] show];
        return NO;
    } else if ([self.areaTf.text length] <= 0) {
        [[JLToast makeTextQuick:@"请选择店铺面积！"] show];
        return NO;
    } else if ([self.positionCountTf.text length] <= 0) {
        [[JLToast makeTextQuick:@"请选择工位数!"] show];
        return NO;
    } else if ([self.technicianCountTf.text length] <= 0) {
        [[JLToast makeTextQuick:@"请选择技师人数!"] show];
        return NO;
    } else if ([self.parkingDigitsTf.text length] <= 0) {
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
                self.nameLabel.text = result.body[@"organName"];
                self.addressLabel.text = result.body[@"address"];
                self.phoneLabel.text = result.body[@"phone"];
                [self.tableView reloadData];
            }
            
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGSize textMaxSize = CGSizeMake(self.view.frame.size.width-120, MAXFLOAT);
    if (indexPath.row == 1) {
        return [self sizeWithText:self.addressLabel.text font:[UIFont systemFontOfSize:17] maxSize:textMaxSize].height + 10;
    }else if(indexPath.row == 11){
        return 60;
    }else if(indexPath.row == 10){
        return 80;

    }else{
        return 44;
    }
}
//计算文字的尺寸
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
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
    _evenTf.text = _pickerArray[row];
    [self.tableView reloadData];

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
