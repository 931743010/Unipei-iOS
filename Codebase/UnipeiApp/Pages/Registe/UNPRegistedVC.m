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
#import "JPUtils.h"
#import "CommonApi_UploadImage.h"
#import <UnipeiApp-Swift.h>
#import <Masonry/Masonry.h>

@interface UNPRegistedVC ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    UNPRegistedConfirmCell               *_confirmCell;
    UNPRegistedReferrerCell              *_referrerCell;
    UNPRegistedUpLoadPicCell             *_upLoadPicCell;
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
    NSString                             *_roughAdress;
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
    self.registedPhototype = kJPRegistedPhotoTypeStore;
    
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
            _roughAdress = [self->_addressViewModel fullAddress];
            [self.tableView reloadData];
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
    
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    @weakify(self)
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
        cell.tfContent.text = _organname;
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
        if (_servicetype == nil) {
            cell.lblChoose.text = @"请选择修理厂类别";
        }else{
            cell.lblChoose.text = _servicetype;
        }
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
        cell.tfContent.text = _name;
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
        cell.tfContent.text = _phone;
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
        if (_roughAdress == nil) {
            cell.lblChoose.text = @"请选择省市区";
        }else{
            cell.lblChoose.text = _roughAdress;
        }
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
        cell.tfContent.text = _address;
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
        _referrerCell.tfName.text = _recommend;
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

        _upLoadPicCell.addPhotoView.btnClickBlock = ^{
        
            [self hideServerPicker];
            
        };
        _upLoadPicCell.lblLisenceNum.textColor = [JPDesignSpec colorMajor];
        _upLoadPicCell.tfLisence.delegate = self;
        _upLoadPicCell.tfLisence.tag = kJPRegistedTextFieldTypeRegistration;
        _upLoadPicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _upLoadPicCell.tfLisence.text = _registration;
        
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
        
        static NSString *cellID = @"UNPRegistedConfirmCell";
        UINib *nib = [UINib nibWithNibName:@"UNPRegistedConfirmCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellID];
        _confirmCell = [tableView dequeueReusableCellWithIdentifier:cellID ];
        _confirmCell.btnConfirm.style = kJPButtonOrange;
        _confirmCell.backgroundColor = [JPDesignSpec colorSilver];
        //通过参数判断按钮是否可点击
        _confirmCell.btnConfirm.enabled = [self btnConfirmIsEnabled];
        [_confirmCell.btnConfirm addTarget:self action:@selector(confirmToRegisted:) forControlEvents:UIControlEventTouchUpInside];
        _confirmCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return _confirmCell;
        
    }
    return nil;
}
#pragma mark - table代理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _currentIndexPath = indexPath;
//    NSLog(@"%ld",indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1) {
        
        [self showServerPicker];
        
    }else{
        [self hideServerPicker];
        if (indexPath.row == 4){
        
            NSLog(@"choose province");
            UNPChooseProvinceVC *vc = [UNPChooseProvinceVC new];
            vc.viewModel = [_addressViewModel copy];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
            
            [[JPSidePopVC new] showVC:nc];
            [self.view endEditing:YES];
        
    }
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
//btnConfirm是否可点击
-(BOOL)btnConfirmIsEnabled{
    
    UIImage *image = _upLoadPicCell.addPhotoView.pickedPhotos.firstObject;
    BOOL enabled = (_organname.length > 0 && _name.length > 0 && _phone.length > 0 && _province.length > 0 && _registration.length > 0 && image);
    return enabled;
    
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
        case 100:{
            self.registedPhototype = kJPRegistedPhotoTypeStore;
            _upLoadPath = kServerUploadPathShopLicence;
            _upLoadPicCell.lisenceNumView.hidden = YES;
        }
            break;
        case 101:{
            self.registedPhototype = kJPRegistedPhotoTypeCard;
            _upLoadPath = kServerUploadPathShopOffice;
            _upLoadPicCell.lisenceNumView.hidden = YES;
        }
            break;
        case 102:{
            self.registedPhototype = kJPRegistedPhotoTypeLisence;
            _upLoadPath = kServerUploadPathShopNamecard;
            _upLoadPicCell.lisenceNumView.hidden = NO;
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - 提交注册
-(void)confirmToRegisted:(UIButton *)btn{
    
    NSLog(@"fuck fuck fuck");

    UIImage *image = _upLoadPicCell.addPhotoView.pickedPhotos.firstObject;
    if (!image) {
        return;
    }
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
            api.params = [NSDictionary dictionaryWithObjectsAndKeys:_organname,@"organname",
                                                                    _name,@"name",
                                                                    _phone,@"phone",
                                                                    _province,@"province",
                                                                    _city,@"city",
                                                                    _area,@"area",
                                                                    _address,@"address",
                                                                    _recommend,@"recommend",
                                                                    _phototype,@"phototype",
                                                                    result.picPath,@"photo",
                                                                    _recomType,@"recomType",
                                                                    _registration,@"registration",
                                                                    _servicetype,@"servicetype",
                                                                    nil];
            
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
    [self hideServerPicker];
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
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:_confirmCell];
    NSArray *indexArr = [NSArray arrayWithObject:indexPath];
    //每次输入完刷新提交注册的cell，刷新btnConfirm的状态
    [self.tableView reloadRowsAtIndexPaths:indexArr withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (_textFieldType == kJPRegistedTextFieldTypeOrganName && range.location > 19) {
        return NO;
    }else if (_textFieldType == kJPRegistedTextFieldTypeName && range.location > 9){
        return NO;
    }else if (_textFieldType == kJPRegistedTextFieldTypePhone && range.location > 10){
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
