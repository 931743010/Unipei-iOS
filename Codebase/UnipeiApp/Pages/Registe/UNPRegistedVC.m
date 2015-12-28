//
//  UNPRegistedVC.m
//  DymIOSApp
//
//  Created by xujun on 15/12/24.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UNPRegistedVC.h"
#import "JPDesignSpec.h"
#import "UNPRegistedNormalCell.h"
#import "UNPRegistedReferrerCell.h"
#import "UNPRegistedUpLoadPicCell.h"
#import "UNPRegistedConfirmCell.h"
#import "UNPChooseProvinceVC.h"
#import "UNPAddressChooseVM.h"
#import "JPSidePopVC.h"
#import "UNPRegistedLisenceNumCell.h"
#import "JPUtils.h"
#import "CommonApi_UploadImage.h"
#import <Masonry/Masonry.h>

@interface UNPRegistedVC ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    UNPRegistedConfirmCell               *_confirmCell;
    UNPRegistedReferrerCell              *_referrerCell;
    UNPRegistedUpLoadPicCell             *_upLoadPicCell;
    UNPRegistedLisenceNumCell            *_lisenceNumCell;
    UIPickerView                         *_pickerView;
    NSArray                              *_pickerData;
    UNPAddressChooseVM                   *_addressViewModel;
    //记录当前点击的cell的indexPath
    NSIndexPath                          *_currentIndexPath;
    //需要上传的接口参数
    NSString                             *_organname;
    NSString                             *_name;
    NSString                             *_phone;
    NSString                             *_province;
    NSString                             *_city;
    NSString                             *_area;
    NSString                             *_address;
    NSString                             *_registration;
    NSString                             *_recommend;
    NSString                             *_servicetype;
    NSString                             *_phototype;
    NSString                             *_recomType;
    //上传头像的接口路径
    EJPServerImagePath                   _upLoadPath;
    //标记上一次点击的btn
    UIButton                             *_lastRecommendBtn;
    UIButton                             *_lastUploadBtn;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation UNPRegistedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    self.navigationItem.title = @"修理厂注册";
    
    _upLoadPath = kServerUploadPathShopLicence;
    self.registedRecomType = kJPRegistedRecomTypeDealer;
    self.registedPhototype = kJPRegistedPhotoTypeLisence;
    
    _pickerData = @[@"一类",@"二类",@"三类"];
    
    _addressViewModel = [UNPAddressChooseVM new];
    // notifications
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_String_addressSelected object:nil queue:nil usingBlock:^(NSNotification *note) {
        @strongify(self)
        if ([note.object isKindOfClass:[UNPAddressChooseVM class]]) {
            self->_addressViewModel = note.object;
            
            if (_addressViewModel.provinceVM.selectedItem) {
                self->_province = [JPUtils stringValueSafe:(_addressViewModel.provinceVM.selectedItem)[@"id"]];
            }
            if (_addressViewModel.cityVM.selectedItem) {
                self->_city = [JPUtils stringValueSafe:(_addressViewModel.cityVM.selectedItem)[@"id"]];
            }
            if (_addressViewModel.districtVM.selectedItem) {
                self->_area = [JPUtils stringValueSafe:(_addressViewModel.districtVM.selectedItem)[@"id"]];
            }
            
            UNPRegistedNormalCell *cell = [self.tableView cellForRowAtIndexPath:_currentIndexPath];
            cell.lblChoose.text = [self->_addressViewModel fullAddress];
            
        }
    }];
    
    [self.observerQueue addObject:observer];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
    header.backgroundColor = [JPDesignSpec colorSilver];
    UILabel *lblNotice = [[UILabel alloc] initWithFrame:CGRectMake(16, 10, 120, 20)];
    lblNotice.textColor = [UIColor blackColor];
    lblNotice.font = [UIFont systemFontOfSize:12];
    lblNotice.text = @"橙色项为必填项";
    [header addSubview:lblNotice];
    
    self.tableView.tableHeaderView = header;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 70;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self updateServerPicker];
    
}
#pragma mark -
#pragma mark - table数据源

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    if (indexPath.row == 6) {
//        return 75;
//    }else if (indexPath.row == 7){
//        return 100;
//    }else if (indexPath.row == 9){
//        return 60;
//    }
//    return 48;
//    
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @weakify(self)
    if (indexPath.row == 0) {
        
        static NSString *organName = @"organName";
        UNPRegistedNormalCell *cell = (UNPRegistedNormalCell *)[tableView dequeueReusableCellWithIdentifier:organName];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UNPRegistedNormalCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.tfContent.delegate = self;
        cell.lblTitle.text = @"修理厂名称";
        cell.tfContent.tag = kJPRegistedTextFieldTypeOrganName;
        cell.lblTitle.textColor = [JPDesignSpec colorMajor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if (indexPath.row == 1) {
        
        static NSString *serviceType = @"serviceType";
        UNPRegistedNormalCell *cell = (UNPRegistedNormalCell *)[tableView dequeueReusableCellWithIdentifier:serviceType ];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UNPRegistedNormalCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.tfContent.delegate = self;
        cell.lblTitle.text = @"修理厂类别";
        cell.tfContent.hidden = YES;
        cell.lblChoose.hidden = NO;
        cell.ivChoose.hidden = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
        
    }else if (indexPath.row == 2){
        
        static NSString *name = @"name";
        UNPRegistedNormalCell *cell = (UNPRegistedNormalCell *)[tableView dequeueReusableCellWithIdentifier:name ];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UNPRegistedNormalCell" owner:self options:nil] objectAtIndex:0];
        }

        cell.tfContent.delegate = self;
        cell.lblTitle.text = @"老板姓名";
        cell.tfContent.tag = kJPRegistedTextFieldTypeName;
        cell.lblTitle.textColor = [JPDesignSpec colorMajor];
        cell.tfContent.placeholder = @"点击输入";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;

    }else if (indexPath.row == 3){
        
        static NSString *phone = @"phone";
        UNPRegistedNormalCell *cell = (UNPRegistedNormalCell *)[tableView dequeueReusableCellWithIdentifier:phone ];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UNPRegistedNormalCell" owner:self options:nil] objectAtIndex:0];
        }

        cell.tfContent.delegate = self;
        cell.lblTitle.text = @"老板手机号";
        cell.tfContent.tag = kJPRegistedTextFieldTypePhone;
        cell.lblTitle.textColor = [JPDesignSpec colorMajor];
        cell.tfContent.keyboardType = UIKeyboardTypeNumberPad;
        cell.tfContent.placeholder = @"点击输入";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;

    }else if (indexPath.row == 4){
        
        static NSString *adress = @"adress";
        UNPRegistedNormalCell *cell = (UNPRegistedNormalCell *)[tableView dequeueReusableCellWithIdentifier:adress];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UNPRegistedNormalCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.tfContent.delegate = self;
        cell.lblTitle.text = @"地址";
        cell.lblTitle.textColor = [JPDesignSpec colorMajor];
        cell.tfContent.hidden = YES;
        cell.lblChoose.hidden = NO;
        cell.ivChoose.hidden = NO;
        cell.lblChoose.text = @"请选择省市区";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;

    }else if (indexPath.row == 5){
        
        static NSString *detailAdress = @"detailAdress";
        UNPRegistedNormalCell *cell = (UNPRegistedNormalCell *)[tableView dequeueReusableCellWithIdentifier:detailAdress ];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UNPRegistedNormalCell" owner:self options:nil] objectAtIndex:0];
        }

        cell.tfContent.delegate = self;
        cell.lblTitle.hidden = YES;
        cell.tfContent.placeholder = @"请输入详细地址";
        cell.tfContent.tag = kJPRegistedTextFieldTypeAdress;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;

    }else if (indexPath.row == 6) {
        
        static NSString *cellID = @"UNPRegistedReferrerCell";
        UINib *nib = [UINib nibWithNibName:@"UNPRegistedReferrerCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellID];
        _referrerCell = [tableView dequeueReusableCellWithIdentifier:cellID ];
        _referrerCell.tfName.delegate = self;
        _referrerCell.tfName.tag = kJPRegistedTextFieldTypeRecommend;
        NSArray *btnArr = @[_referrerCell.btnDealer,_referrerCell.btnSalesman];
        for (UIButton *btn in btnArr) {
            [btn addTarget:self action:@selector(recommendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            if (btn.tag == 100) {
                _lastRecommendBtn = btn;
            }
        }
        _referrerCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return _referrerCell;
        
    }else if (indexPath.row == 7){
        
        static NSString *cellID = @"UNPRegistedUpLoadPicCell";
        UINib *nib = [UINib nibWithNibName:@"UNPRegistedUpLoadPicCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellID];
        _upLoadPicCell = [tableView dequeueReusableCellWithIdentifier:cellID ];
        _upLoadPicCell.lblTitle.textColor = [JPDesignSpec colorMajor];
        
        _upLoadPicCell.addPhotoView.presentingVC = self;
        _upLoadPicCell.addPhotoView.maxPhotoCount = 1;
        _upLoadPicCell.addPhotoView.buttonSize = 56;
        _upLoadPicCell.addPhotoView.imagePickedBlock = ^(void) {
            @strongify(self)
            [self.tableView reloadData];
        };
        NSArray *btnArr = @[_upLoadPicCell.btnLicense,_upLoadPicCell.btnStore,_upLoadPicCell.btnCard];
        for (UIButton *btn in btnArr) {
            [btn addTarget:self action:@selector(upLoadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            if (btn.tag == 100) {
                _lastUploadBtn = btn;
            }
        }
        _upLoadPicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return _upLoadPicCell;
        
    }else if (indexPath.row == 8){
    
        static NSString *cellID = @"UNPRegistedLisenceNumCell";
        UINib *nib = [UINib nibWithNibName:@"UNPRegistedLisenceNumCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellID];
        _lisenceNumCell = [tableView dequeueReusableCellWithIdentifier:cellID ];
        _lisenceNumCell.lblLisenceNum.textColor = [JPDesignSpec colorMajor];
        _lisenceNumCell.tfLisence.delegate = self;
        _lisenceNumCell.tfLisence.tag = kJPRegistedTextFieldTypeRegistration;
        _lisenceNumCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return _lisenceNumCell;

        
    }else if (indexPath.row == 9){
        
        static NSString *cellID = @"UNPRegistedConfirmCell";
        UINib *nib = [UINib nibWithNibName:@"UNPRegistedConfirmCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellID];
        _confirmCell = [tableView dequeueReusableCellWithIdentifier:cellID ];
        _confirmCell.btnConfirm.style = kJPButtonOrange;
        _confirmCell.backgroundColor = [JPDesignSpec colorSilver];
        [_confirmCell.btnConfirm addTarget:self action:@selector(confirmToRegisted:) forControlEvents:UIControlEventTouchUpInside];
        _confirmCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return _confirmCell;
        
    }
    return nil;
}
#pragma mark - table代理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _currentIndexPath = indexPath;
    NSLog(@"%ld",indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        
        [self showServerPicker];
        
    }else if (indexPath.row == 4){
        
            NSLog(@"choose province");
            UNPChooseProvinceVC *vc = [UNPChooseProvinceVC new];
            vc.viewModel = [_addressViewModel copy];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
            
            [[JPSidePopVC new] showVC:nc];
            [self.view endEditing:YES];
        
    }
    
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideServerPicker];
}
#pragma mark -
#pragma mark - @protocol UIPickerViewDataSource<NSObject>

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _pickerData.count;
}

#pragma mark -@protocol UIPickerViewDelegate<NSObject>

// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _pickerData[row];
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

    //查找当前选择的cell
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UNPRegistedNormalCell *cell = [self.tableView cellForRowAtIndexPath:_currentIndexPath];
    cell.lblChoose.text = _pickerData[row];
    _servicetype = _pickerData[row];
    [self hideServerPicker];
        
}
#pragma mark - 添加选择视图
-(void)updateServerPicker {
    
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.9];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _pickerView.alpha = 0;
    
}

-(void)showServerPicker {
    
    [_pickerView removeFromSuperview];
    [self.view.window addSubview:_pickerView];
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.and.bottom.equalTo(self.view.window);
        make.height.equalTo(@100);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        _pickerView.alpha = 1;
    }];
    
}

-(void)hideServerPicker {
    _pickerView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        _pickerView.alpha = 0;
    } completion:^(BOOL finished) {
        [_pickerView removeFromSuperview];
        _pickerView.userInteractionEnabled = YES;
        
    }];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}

#pragma mark - 推荐人、上传附件
-(void)recommendBtnClick:(UIButton *)btn{
    
    NSInteger i = btn.tag;
    
    [_lastRecommendBtn setImage:[UIImage imageNamed:@"icon_radio_unselected"] forState:UIControlStateNormal];
    _lastRecommendBtn = btn;
    [btn setImage:[UIImage imageNamed:@"icon_radio_selected"] forState:UIControlStateNormal];
    
    switch (i) {
        case 100:
            self.registedRecomType = kJPRegistedRecomTypeDealer;
            break;
        case 101:
            self.registedRecomType = kJPRegistedRecomTypeSalesman;
            break;
        default:
            break;
    }
    
}
-(void)upLoadBtnClick:(UIButton *)btn{
    
    NSInteger i = btn.tag;
    
    [_lastUploadBtn setImage:[UIImage imageNamed:@"icon_radio_unselected"] forState:UIControlStateNormal];
    _lastUploadBtn= btn;
    [btn setImage:[UIImage imageNamed:@"icon_radio_selected"] forState:UIControlStateNormal];
    
    switch (i) {
        case 100:
            self.registedPhototype = kJPRegistedPhotoTypeLisence;
            _upLoadPath = kServerUploadPathShopLicence;
            break;
        case 101:
            self.registedPhototype = kJPRegistedPhotoTypeStore;
            _upLoadPath = kServerUploadPathShopOffice;
            break;
        case 102:
            self.registedPhototype = kJPRegistedPhotoTypeCard;
            _upLoadPath = kServerUploadPathShopNamecard;
            break;
        default:
            break;
    }
    
}
#pragma mark - 提交注册
-(void)confirmToRegisted:(UIButton *)btn{
    
    UIImage *image = _upLoadPicCell.addPhotoView.pickedPhotos[0];
    
    CommonApi_UploadImage *uploadImage = [[CommonApi_UploadImage alloc] initWithParams:
                                          @{@"pathType": @(_upLoadPath)
                                            , @"fileType": @(kJPUploadFileTypeJPEG)
                                            , @"name": [JPUtils randomDigitString]
                                            , @"image": image}];
    [self.apiQueue addObject:uploadImage];
    
    [[DymRequest commonApiSignal:uploadImage queue:self.apiQueue] subscribeNext:^(CommonApi_UploadImage_Result *result){
        if (result.success) {
            
            _phototype = [JPUtils stringValueSafe:@(self.registedPhototype)];
            _recomType = [JPUtils stringValueSafe:@(self.registedRecomType)];
            
            DymCommonApi *api = [DymCommonApi new];
            api.relativePath = PATH_userApi_saveApplyService;
            api.params = @{@"organname":_organname,
                           @"name":_name,
                           @"phone":_phone,
                           @"province":_province,
                           @"city":_city,
                           @"area":_area,
                           @"address":_address,
                           @"recommend":_recommend,
                           @"phototype":_phototype,
                           @"photo":result.picPath,
                           @"recomType":_recomType,
                           @"registration":_registration,
                           @"servicetype":_servicetype
                           };
            
            @weakify(self)
            [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
                
                @strongify(self)
                if (result.success) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                
            }];
        }
    }];
    
}
#pragma mark - textfielddelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    self.textFieldType = textField.tag;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (_textFieldType == kJPRegistedTextFieldTypeOrganName) {
        _organname = textField.text;
    }else if (_textFieldType == kJPRegistedTextFieldTypeName){
        _name = textField.text;
    }else if (_textFieldType == kJPRegistedTextFieldTypePhone){
        _phone = textField.text;
    }else if (_textFieldType == kJPRegistedTextFieldTypeAdress){
        _address = textField.text;
    }else if (_textFieldType == kJPRegistedTextFieldTypeRecommend){
        _recommend = textField.text;
    }else if (_textFieldType == kJPRegistedTextFieldTypeRegistration){
        _registration = textField.text;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
