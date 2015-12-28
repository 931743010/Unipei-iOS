//
//  UNPCreateInquiryVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPCreateInquiryVC.h"
#import "JPAddPhotoView.h"
#import "JPInquiryPartCell.h"
#import "JPSubmitButton.h"
#import <Masonry/Masonry.h>
#import "JPUtils.h"
#import "DymStoryboard.h"
#import "UNPChooseBrandVC.h"
#import "JPSidePopVC.h"
#import "UNPCarModelChooseVM.h"
#import "UNPChooseRootPartVC.h"
//#import "JPAudioRecordPlayView.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <UnipeiApp-Swift.h>
#import "InquiryApi_InquiryAdd.h"
#import "JPAppStatus.h"
#import "UNPCreateInquiryDealersVC.h"
#import "InquiryApi_GetInquiryInfo.h"
#import "JPGrowingTextView.h"
#import "GGPredicate.h"
#import "JPAudiosView.h"
#import "KLAudioManager.h"
#import "CameraViewController.h"
#import "DymNavigationController.h"
#import "JPDesignSpec.h"
#import "JPUtils.h"

@interface UNPCreateInquiryVC () <UITextFieldDelegate, UITextViewDelegate> {
    UITableViewCell     *_inputVinCell;
    UITableViewCell     *_chooseModelCell;
    UITableViewCell     *_descCell;
    UITableViewCell     *_choosePhotosCell;
    UITableViewCell     *_recordAudioCell;
    UITableViewCell     *_addPartsCell;
    
    /// controls in cells
    UITextField             *_tfInputVin;
    NSString                *_vinString;
    
    JPSubmitButton          *_btnChooseModel;
    UILabel *_lblVinTitle;
    JPGrowingTextView       *_tfDescription;
    JPAddPhotoView          *_addPhotosView;
    JPAudiosView            *_audioView;
    
    BOOL                    _isFirstResponderEditDesc;
//    BOOL                    _shouldResignEditDesc;
    
    /// footer view
    UIView              *_viewFooter;
    JPSubmitButton      *_btnNext;
    
    /// 选择车型的View Model
    UNPCarModelChooseVM     *_carModelChooseVM;
    UNPCarPartsChooseVM     *_carPartsChooseVM;
    
    /// If is editing an inquiry, this object hold the inqiry detail
    JPInquiry               *_inquiry;
    
    CameraViewController *_cameraView ;
    
    DymBaseRespModel *_vinScanReturnValue;
    BOOL _chooseFromVin;
    
    
}

@end

@implementation UNPCreateInquiryVC

+(instancetype)newFromStoryboard {
    return [[DymStoryboard unipeiInquiry_Storyboard] instantiateViewControllerWithIdentifier:@"UNPCreateInquiryVC"];
}

-(void)dealloc {
    [_audioView stopRecordAndRefresh];
    
    [[KLAudioManager sharedInstance] stop];
}


-(void)handleCarPartSelectedNotification:(NSNotification *)note {
    if ([note.object isKindOfClass:[UNPCarPartsChooseVM class]]) {
        _carPartsChooseVM = note.object;
        [_carPartsChooseVM addNewPart];
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _carModelChooseVM = [UNPCarModelChooseVM new];
    _carPartsChooseVM = [UNPCarPartsChooseVM new];
    
    self.title = _inquiryID ? @"修改询价单" : @"发布询价单";
    self.tableView.estimatedRowHeight = 70;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:NULL];
    
    @weakify(self)
    cancelBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
        return [RACSignal empty];
    }];
    self.navigationItem.leftBarButtonItem = cancelBtn;
    
    // init cells
    [self initCells];
    _tfInputVin.userInteractionEnabled = _inquiryID ? NO : YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCarPartSelectedNotification:) name:NOTIFY_String_carPartsSelected object:nil];
    
    
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_String_carModelSelected object:nil queue:nil usingBlock:^(NSNotification *note) {
        @strongify(self)
        if ([note.object isKindOfClass:[UNPCarModelChooseVM class]]) {
            self->_carModelChooseVM = note.object;
            [self->_btnChooseModel setTitle:[self->_carModelChooseVM fullName] forState:UIControlStateNormal];
            self->_chooseFromVin = NO;
            self->_lblVinTitle.hidden = YES;
            UIColor *lineColor = [JPDesignSpec colorWhite];
             [JPUtils installTopLine:self->_lblVinTitle color:lineColor insets:UIEdgeInsetsMake(-4, 0, 0, 0)];
            [self.tableView reloadData];
        }
    }];
    
    [self.observerQueue addObject:observer];
    

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleVinCodeRec:) name:JP_NOTIFICATION_VIN_CODE_RECOGNIZED object:nil];
    
    
    /// request Inquiry info if needed
    if (_inquiryID) {
        @weakify(self)
        self.dataSourceIsLoading = YES;
        [[self getInquiryInfoSignal] subscribeNext:^(InquiryApi_GetInquiryInfo_Result *result) {
            @strongify(self)
            self.dataSourceIsLoading = NO;
            
            if ([result isKindOfClass:[InquiryApi_GetInquiryInfo_Result class]]) {
                self->_inquiry = result.inquiryInfo;
                // give some time for controls to be set during reload data....
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self handleInquiryDetailReady];
                });
            }
        }];
    }
    
    //vin 识别
    _cameraView= [[CameraViewController alloc]init];
    _cameraView.nsCompanyName = @"北京嘉配科技有限公司";
    _cameraView.delegate = self;
}


-(void)handleVinCodeRec:(NSNotification *)note {
    
    self.vinCode = note.object[@"vinCode"];
    
    //            cjmc = "奇瑞汽车";
    //            cx = "1.3L 手动舒适型";  //车系
    //            cxi = A1;
    //            isexist = 1;
    //            makeID = 1000000;
    //            modelID = 1001004;
    //            nk = 2008;
    //            pp = "奇瑞";
    //            seriesID = 1001000;
    //            txt = "奇瑞汽车 奇瑞 A1 2008 1.3L 手动舒适型";
    
    
    _vinScanReturnValue = note.object[@"result"];
    
    _lblVinTitle.hidden = NO;  //1001
    UIColor *lineColor = [JPDesignSpec colorGray];
    [JPUtils installTopLine:_lblVinTitle color:lineColor insets:UIEdgeInsetsMake(-4, 0, 0, 0)];
    _lblVinTitle.numberOfLines = 0;
    _lblVinTitle.lineBreakMode = NSLineBreakByWordWrapping;
    
    if (!_vinScanReturnValue.success) {
        _lblVinTitle.text = @"Vin码未匹配到对应车型";
        [self->_btnChooseModel setTitle:@"选择车型" forState:UIControlStateNormal];
    }else if([_vinScanReturnValue.body[@"isexist"] intValue]==0){
        _lblVinTitle.text = [self vinFullNameLine];
        [self->_btnChooseModel setTitle:@"选择车型" forState:UIControlStateNormal];
    }else{
        [self->_btnChooseModel setTitle:[self vinFullNameBreakLine] forState:UIControlStateNormal];
        _lblVinTitle.text = [self vinFullNameLine];
    }
    //        [self updatePreferredWidth];
    _chooseFromVin = YES;
    
    [self.tableView reloadData];
}

-(void)updatePreferredWidth {
    CGFloat preferedWidth = CGRectGetWidth(self.tableView.bounds);
    preferedWidth -=16;
//    if (_ivCheck == nil) {
//        preferedWidth -= 16 + 8 + _lblAmount.intrinsicContentSize.width + 16;
//    } else {
//        preferedWidth -= 16 + 8 + _changeNumberView.intrinsicContentSize.width + 16;
//    }
    _lblVinTitle.preferredMaxLayoutWidth = preferedWidth;
//    _btnChooseModel.preferredMaxLayoutWidth = preferedWidth;
}





-(void)initCells {
    
    @weakify(self)
    
    if (_inputVinCell == nil) {
        _inputVinCell = [self.tableView dequeueReusableCellWithIdentifier:@"inputVinCell"];
        _tfInputVin = (UITextField *)[_inputVinCell.contentView viewWithTag:100];
        _tfInputVin.delegate = self;
        _lblVinTitle = (UILabel *)[_inputVinCell.contentView viewWithTag:103];
        _lblVinTitle.hidden = YES;  //1001
//        )colorGrayDark {
// colorSilver
//        +(UIColor *)colorGray
//        UIColor *lineColor = [JPDesignSpec colorGray];
//        [JPUtils installTopLine:_lblVinTitle color:lineColor insets:UIEdgeInsetsMake(-4, 0, 0, 0)];
//        _lblVinTitle.numberOfLines = 0;
//        _lblVinTitle.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    if (_chooseModelCell == nil) {
        _chooseModelCell = [self.tableView dequeueReusableCellWithIdentifier:@"chooseModelCell"];
        _btnChooseModel = (JPSubmitButton *)[_chooseModelCell.contentView viewWithTag:100];
        _btnChooseModel.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _btnChooseModel.titleLabel.textAlignment = NSTextAlignmentCenter;
        _btnChooseModel.style = kJPButtonWhite;
        _btnChooseModel.userInteractionEnabled = (_inquiryID == nil);
        
        [[_btnChooseModel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            UNPChooseBrandVC *vc = [UNPChooseBrandVC newFromStoryboard];
            vc.viewModel = [self->_carModelChooseVM copy];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
            
            [[JPSidePopVC new] showVC:nc];
            [self.view endEditing:YES];
        }];
        

    }
    
    if (_descCell == nil) {
        _descCell = [self.tableView dequeueReusableCellWithIdentifier:@"descCell"];
        _tfDescription = [JPGrowingTextView new];
        _tfDescription.delegate = self;
        [_descCell addSubview:_tfDescription];
        [_tfDescription mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.right.equalTo(_descCell).insets(UIEdgeInsetsMake(8, 112, 8, 16));
        }];
        
        _tfDescription.maxTextCount = 100;
        _tfDescription.backgroundColor = [UIColor clearColor];
        _tfDescription.contentHeightChangedBlock = ^(void) {
            @strongify(self)
            // Reload data后，如果_tfDescription正在编辑状态，会失去焦点，通过改变showResignEditDesc控制它是否失去焦点
            self->_isFirstResponderEditDesc = [self->_tfDescription isFirstResponder];
            [self.tableView reloadData];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (self->_isFirstResponderEditDesc) {
                    self->_isFirstResponderEditDesc = NO;
                    [self->_tfDescription becomeFirstResponder];
                }
            });
        };
    }
    
    if (_choosePhotosCell == nil) {
        _choosePhotosCell = [self.tableView dequeueReusableCellWithIdentifier:@"choosePhotosCell"];
        _addPhotosView = (JPAddPhotoView *)[_choosePhotosCell.contentView viewWithTag:100];
        _addPhotosView.presentingVC = self;
        _addPhotosView.maxPhotoCount = 5;
        _addPhotosView.buttonSize = 56;
        _addPhotosView.imagePickedBlock = ^(void) {
            @strongify(self)
            [self.tableView reloadData];
        };
    }
    
    if (_recordAudioCell == nil) {
        
        @weakify(self)
        
        _recordAudioCell = [self.tableView dequeueReusableCellWithIdentifier:@"recordAudioCell"];
        _audioView = (JPAudiosView *)[_recordAudioCell.contentView viewWithTag:100];
        _audioView.maxAudioCount = 5;
        _audioView.isRecordingEnabled = YES;
        [_audioView setAudioURLs:nil];
        _audioView.contentHeightChangedBlock = ^(void) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                @strongify(self)
                [self.tableView reloadData];
            });
        };
    }
    
    if (_addPartsCell == nil) {
        _addPartsCell = [self.tableView dequeueReusableCellWithIdentifier:@"addPartsCell"];
    }
}


-(void)handleInquiryDetailReady {
    // 图片
//    NSMutableArray *fullPathPhotos = [NSMutableArray array];
//    for (id photo in _inquiry.picfilepList) {
//        NSString *relativePath = [photo objectForKey:@"picpath"];
//        [fullPathPhotos addObject:[JPUtils fullMediaPath:relativePath]];
//    }
    [_addPhotosView showImages:_inquiry.picfilepList pickEnabled:YES];
//    _addPhotosView.picfilepList = [_inquiry.picfilepList mutableCopy];
    
    
    
    // Model
    [_carModelChooseVM setSelectionWithInquiry:_inquiry];
    [_btnChooseModel setTitle:[_carModelChooseVM fullName] forState:UIControlStateNormal];
    
    // Vin码
    self.vinCode = _inquiry.vin;
    
    // 描述
    _tfDescription.text = [_inquiry.describe stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    
    // 语音
    NSArray *voices = _inquiry.picfilevList;
    [_audioView setAudioURLs:voices];
    
    // 组件
    [_carPartsChooseVM addPartsWithData:_inquiry.categorieList];
    
    [self.tableView reloadData];
}


#pragma mark - tableview methods


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath_IfDataOK:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
//            return 48;
            return 70;
        } else if (indexPath.row == 1) { // 选择车型按钮

            return UITableViewAutomaticDimension;
//            CGFloat height = _btnChooseModel.intrinsicContentSize.height;
//            return height * 2;
//            return _btnChooseModel.intrinsicContentSize.height * 2 + 32;
//            return 80;
        } else if (indexPath.row == 2) {
            
            [_descCell setNeedsLayout];
            [_descCell layoutIfNeeded];
            
            CGFloat height = _tfDescription.intrinsicContentSize.height + 16;
            
            return height > 48 ? height : 48;
            
        } else if (indexPath.row == 3) {
//            return [_addPhotosView sizeWithImageCount:_addPhotosView.allPhotos.count + 1].height + 16;
            NSInteger height1= _addPhotosView.allPhotos.count + 1;
            return [_addPhotosView sizeWithImageCount:height1].height + 16;
        } else if (indexPath.row == 4) {
            
            CGFloat height = [_audioView intrinsicContentSize].height + 16;
            
            return height;
            
        } else if (indexPath.row == 5) {
            return 56;
        }
    } else if (indexPath.section == 1) {
        return 152;
    }

    
    return 48;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection_IfDataOK:(NSInteger)section {
    if (section == 0) {
        return 6;
    }
    
    return _carPartsChooseVM.selectedParts.count;
}

-(NSInteger)numberOfSectionsInTableView_IfDataOK:(UITableView *)tableView {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cellSpecial = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (cellSpecial == self.emptyCell || cellSpecial == self.loadingCell) {
        return cellSpecial;
    }
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return _inputVinCell;
            
        } else if (indexPath.row == 1) {
            
//            [_btnChooseModel setTitle:@"adjkhsjkahdkjahsdjkhaskjdhakjsdhkjasdkjlasdjlasjdlasjdlkjaksdahsdkaskjdhaskjdhjkahskj" forState:UIControlStateNormal];
            return _chooseModelCell;
            
        } else if (indexPath.row == 2) {

            [_descCell setNeedsLayout];
            [_descCell layoutIfNeeded];
            
            return _descCell;
            
        } else if (indexPath.row == 3) {
            
            return _choosePhotosCell;
            
        } else if (indexPath.row == 4) {

            return _recordAudioCell;
            
        } else if (indexPath.row == 5) {

            return _addPartsCell;
        }
        
    } else if (indexPath.section == 1) {
        
        JPInquiryPartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JPInquiryPartCell" forIndexPath:indexPath];
        
        UNPInquiryPart *part = _carPartsChooseVM.selectedParts[indexPath.row];
        
        cell.inquiryPart = part;
        
        return cell;
    }
    
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isDataSourceEmpty]) {
        return;
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 5) { // add parts
            
            UNPChooseRootPartVC *vc = [UNPChooseRootPartVC new];
            vc.viewModel = [_carPartsChooseVM copy];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
            
            [[JPSidePopVC new] showVC:nc];
            [self.view endEditing:YES];
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        if (_viewFooter == nil) {
            _viewFooter = [UIView new];
            
            UIView *innerBgView = [UIView new];
            innerBgView.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1];
            [_viewFooter addSubview:innerBgView];
            [innerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_viewFooter).insets(UIEdgeInsetsMake(18, 0, 0, 0));
            }];
            
            UIColor *lineColor = [UIColor colorWithWhite:230/255.0 alpha:1];
            UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
            [JPUtils installTopLine:innerBgView color:lineColor insets:insets];
            
            _btnNext = [[JPSubmitButton alloc] initWithStyle:kJPButtonOrange];
            [_btnNext setTitle:@"下一步" forState:UIControlStateNormal];
            [innerBgView addSubview:_btnNext];
            [_btnNext mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(innerBgView).insets(UIEdgeInsetsMake(8, 16, 16, 16));
            }];
            
            @weakify(self)
            [[_btnNext rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self)
                [self nextStep];
                
            }];
        }
        
        return _viewFooter;
    }
    
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        return 90;
    }
    
    return 0.1;
}

/// 删除
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return YES;
    }
    
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            [_carPartsChooseVM.selectedParts removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//#pragma mark - text view delegate
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    
//    if (text.length > 1) {
//        return NO;
//    }
//    
//    return YES;
//}

#pragma mark - text field delegate
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _tfInputVin) {
        _tfInputVin.text = [_tfInputVin.text uppercaseString];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _tfInputVin) {
    
        _vinString = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (range.length == 0) {
            if (![GGPredicate checkCharacter:string]) {
                return NO;
            } else if (_vinString.length >= 17) {
                return NO;
            }
        }
        
        [self formatingTfInputVin];
    }
    
    return YES;
}

-(void)formatingTfInputVin {
    NSString *formatedString = [JPUtils vinFormatedString:_vinString];
    _tfInputVin.text = formatedString;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _tfInputVin.text = [_tfInputVin.text uppercaseString];
    });
}

#pragma mark - actions
-(void)nextStep {

    if (_vinString.length > 0 && ![GGPredicate checkCharacter:_vinString]) {
        
        [[JLToast makeText:@"VIN码必须为字母和数字"] show];
        [_tfInputVin becomeFirstResponder];
        
    } else if (_vinString.length > 17) {
        
        [[JLToast makeText:@"VIN码不能超过17个字符"] show];
        [_tfInputVin becomeFirstResponder];
        
    } else if ((!_chooseFromVin && _carModelChooseVM.brandVM.selectedItem == nil ) || (_chooseFromVin && !_vinScanReturnValue.success)) {
        [[JLToast makeText:@"请先选择车型"] show];
        
    } else if (_tfDescription.text.length > 0 && [JPUtils isContainsEmoji:_tfDescription.text]) {
        
        [[JLToast makeText:@"采购描述不能包含表情符号"] show];
        [_tfDescription becomeFirstResponder];
        
    } else if (_tfDescription.text.length <= 0
               && _addPhotosView.allPhotos.count <= 0
               && _carPartsChooseVM.selectedParts.count <= 0) {
        
        [[JLToast makeText:@"采购描述，附件，配件清单必须选填一项"] show];
        
    } else {
        
        InquiryApi_InquiryAdd *apiInquiryAdd = [InquiryApi_InquiryAdd new];
        apiInquiryAdd.vin = _vinString;
        apiInquiryAdd.describe = [_tfDescription.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
        
        if (_chooseFromVin) {
            apiInquiryAdd.make = _vinScanReturnValue.body[@"makeID"];
            apiInquiryAdd.car =  _vinScanReturnValue.body[@"seriesID"];
            apiInquiryAdd.year = _vinScanReturnValue.body[@"nk"];
            apiInquiryAdd.model =  _vinScanReturnValue.body[@"modelID"];
        }else{
            apiInquiryAdd.make = ((JPCarMake *)(_carModelChooseVM.brandVM.selectedItem)).makeid;
            apiInquiryAdd.car = ((JPCarSeries *)(_carModelChooseVM.seriesVM.selectedItem)).seriesid;
            apiInquiryAdd.year = [_carModelChooseVM.yearVM.selectedItem objectForKey:@"year"];
            apiInquiryAdd.model = ((JPCarModel *)(_carModelChooseVM.modelVM.selectedItem)).modelid;
        }
 
        apiInquiryAdd.categorieList = [_carPartsChooseVM partJsonObjects];
        
        UNPCreateInquiryDealersVC *vc = [UNPCreateInquiryDealersVC newFromStoryboard];
        vc.apiInquiryAdd = apiInquiryAdd;
        vc.inquiryID = _inquiryID;
        vc.dealerid = _inquiry.dealerid;
        
        vc.photos = _addPhotosView.pickedPhotos;
        if (_inquiryID) {
            vc.photosRemote = _addPhotosView.remotePhotos;
        }
        
        vc.localAudios = _audioView.localAudios;
        vc.remoteAudios = _audioView.remoteAudios;
        
//        if (_audioView.audioLocalPath) {
//            vc.audioFile = _audioView.audioLocalPath;
//        } else if(_inquiry.picfilevList.firstObject) {
//            id voice = _inquiry.picfilevList.firstObject;
//            vc.audioRemoteURL = voice[@"picpath"];
//        }
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - signals
-(RACSignal *)getInquiryInfoSignal {
    id params = @{@"inquiryid": self.inquiryID ? : @0};
    
    return [DymRequest commonApiSignalWithClass:[InquiryApi_GetInquiryInfo class] queue:self.apiQueue params:params];
}

#pragma mark -- vin functions --
- (IBAction)takeVinPhoto:(id)sender {
    if(!_inquiryID){
        DymNavigationController *nc = [[DymNavigationController alloc] initWithRootViewController:_cameraView];
        _cameraView.navigationController.navigationBarHidden = YES;
        [self presentViewController:nc animated:YES completion:nil];
    }
}
//update Vin code
-(void) setVinCode:(NSString *)vinCode
{
    _vinCode = vinCode;
    _tfInputVin.text = vinCode;
    
    _vinString = [_tfInputVin.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self formatingTfInputVin];
}

-(NSString *)vinFullNameLine {
    return [self fullNameWithLevelFromVin:kJPCarModelNameLevelModel type:1];
}

-(NSString *)vinFullNameBreakLine {
    return [self fullNameWithLevelFromVin:kJPCarModelNameLevelModel type:2];
}


-(NSString *)fullNameWithLevelFromVin:(EJPCarModelNameLevel)level type:(int) type{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    [arr addObject:_vinScanReturnValue.body[@"cjmc"]];
    
    if (_vinScanReturnValue.body[@"cxi"] && level > kJPCarModelNameLevelBrand) {
        [arr addObject:@" "];
        [arr addObject:_vinScanReturnValue.body[@"cxi"]];
        if (_vinScanReturnValue.body[@"nk"] && level > kJPCarModelNameLevelSeries) {
            [arr addObject:@" "];
            if ([_vinScanReturnValue.body[@"nk"] integerValue] > 0) {
                [arr addObject:[NSString stringWithFormat:@"%@款", _vinScanReturnValue.body[@"nk"]]];
            } else {
                [arr addObject:@"不确定年款"];
            }
            
            if (_vinScanReturnValue.body[@"cx"] && level > kJPCarModelNameLevelYear) {
                [arr addObject:@" "];
                [arr addObject:_vinScanReturnValue.body[@"cx"]];
                
                if (type==2) {    // 如果是超长字符串就换行
                    if ([arr componentsJoinedByString:@""].length > 18) {
                        [arr removeLastObject];
                        [arr addObject:[NSString stringWithFormat:@"\n%@", _vinScanReturnValue.body[@"cx"]]];
                    }
                }
                
            }
        }
    }
    
    
    return [arr componentsJoinedByString:@""];
}



#pragma mark - CamaraDelegate
//识别核心初始化结果，判断核心是否初始化成功
- (void)initVinTyperWithResult:(int)nInit{
    NSLog(@"识别核心初始化结果nInit>>>%d<<<",nInit);
}

////相机视图将要消失时回调此方法，返回相机视图控制器
//- (void)viewWillDisappearWithCameraViewController:(CameraViewController *)cameraVC
//{
//    cameraVC.navigationController.navigationBarHidden = NO;
//}



@end
