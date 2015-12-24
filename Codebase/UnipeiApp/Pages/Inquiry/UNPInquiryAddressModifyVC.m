//
//  UNPInquiryAddressModifyVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/15.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPInquiryAddressModifyVC.h"
#import "JPLinedTableCell.h"
#import "JPSubmitButton.h"
#import "UNPAddressChooseVM.h"
#import "UNPChooseProvinceVC.h"
#import "JPSidePopVC.h"
#import <UnipeiApp-Swift.h>
#import "InquiryApi_AddReciveAddress.h"
#import "InquiryApi_UpdateReciveAddress.h"
#import "GGPredicate.h"
#import "InquiryApi_FindReceiveAddressById.h"
#import "GGPredicate.h"
#import "JPGrowingTextView.h"
#import <Masonry/Masonry.h>
#import "JPLimitedTextField.h"

@interface UNPInquiryAddressModifyVC () <UITextFieldDelegate, UITextViewDelegate> {
    
    NSArray                 *_cells;
    UNPAddressChooseVM      *_addressViewModel;
    
    JPGrowingTextView       *_tfDescription;
    BOOL                    _isFirstResponderEditDesc;
}

@property (weak, nonatomic) IBOutlet JPLinedTableCell *nameCell;
@property (weak, nonatomic) IBOutlet JPLinedTableCell *addressCell;
@property (weak, nonatomic) IBOutlet JPLinedTableCell *streetCell;
@property (weak, nonatomic) IBOutlet JPLinedTableCell *postcodeCell;
@property (weak, nonatomic) IBOutlet JPLinedTableCell *phoneCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *confirmCell;

@property (weak, nonatomic) IBOutlet JPLimitedTextField *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
//@property (weak, nonatomic) IBOutlet UITextField *lblStreet;
@property (weak, nonatomic) IBOutlet UITextField *lblPostCode;
@property (weak, nonatomic) IBOutlet UITextField *lblPhone;
@property (weak, nonatomic) IBOutlet JPSubmitButton *btnSubmit;


@end

@implementation UNPInquiryAddressModifyVC

+(instancetype)newFromStoryboard {
    return [[DymStoryboard unipeiInquiry_Storyboard] instantiateViewControllerWithIdentifier:@"UNPInquiryAddressModifyVC"];
}

- (void)handleAddressReceived {
    _lblName.text = _address.contactname;
    _addressViewModel.state = [JPUtils numberValueSafe:_address.state];
    _addressViewModel.city = [JPUtils numberValueSafe:_address.city];
    _addressViewModel.district = [JPUtils numberValueSafe:_address.district];
    _lblAddress.text = [NSString stringWithFormat:@"%@%@%@", _address.statename, _address.cityname, _address.districtname];
    _tfDescription.text = _address.address;
    _lblPostCode.text = _address.zipcode;
    _lblPhone.text = _address.phone;
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    @weakify(self)
    
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.title = _address ? @"修改收货地址" : @"添加收货地址";
    
    _addressViewModel = [UNPAddressChooseVM new];
    
    _cells = @[_nameCell, _addressCell, _streetCell, _postcodeCell, _phoneCell, _confirmCell];
    
    
    _lblName.maxLength = 10;
    
    
    ///
    _tfDescription = [JPGrowingTextView new];
    _tfDescription.lblPlaceHolder.text = @"请输入街道地址";
    _tfDescription.font = [UIFont systemFontOfSize:16];
    _tfDescription.lblPlaceHolder.textColor = [UIColor colorWithRed:1.0f/255.0f green:1.0f/255.0f blue:1.0f/255.0f alpha:0.25];
    _tfDescription.placeHolderLeadingSpace = 4;
    
    _tfDescription.delegate = self;
    [_streetCell addSubview:_tfDescription];
    [_tfDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(_streetCell).insets(UIEdgeInsetsMake(8, 110, 8, 16));
    }];
    [_tfDescription setContentCompressionResistancePriority:1000 forAxis:1];
    
    _tfDescription.maxTextCount = 50;
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
    
    ///
    _confirmCell.backgroundColor = [UIColor clearColor];
    _btnSubmit.style = kJPButtonOrange;
    
    if (_address) {
        
        InquiryApi_FindReceiveAddressById *api = [InquiryApi_FindReceiveAddressById new];
        api.addressID = _address.addressID;
        
        [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(InquiryApi_FindReceiveAddressById_Result *result) {
            @strongify(self)
            if (result.success) {
                self->_address = result.address;
            }
            
            [self handleAddressReceived];
        }];
    }
    
    // btn submit
    [[_btnSubmit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(JPSubmitButton *button) {
        @strongify(self)
        [self checkAndSubmit];
    }];
    
    // notifications
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_String_addressSelected object:nil queue:nil usingBlock:^(NSNotification *note) {
        @strongify(self)
        if ([note.object isKindOfClass:[UNPAddressChooseVM class]]) {
            self->_addressViewModel = note.object;
            self->_lblAddress.text = [self->_addressViewModel fullAddress];
            
            [self.tableView reloadData];
        }
    }];
    
    [self.observerQueue addObject:observer];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
//                                                name:UITextFieldTextDidChangeNotification
//                                              object:nil];
}

#pragma mark - UITextView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (range.length != 0) {
        return YES;
    }
    
    if (textView == _tfDescription && textView.text.length > 49) {
        return NO;
    }
    
    return YES;
}

#pragma mark - UITextField delegate
//
//-(void)textFiledEditChanged:(NSNotification *)notification {
//    UITextField *textField = notification.object;
//    if (_lblName == textField) {
//        NSLog(@"text:%@", textField.text);
//        if (textField.text.length > 10) {
//            
//            textField.text = [textField.text substringToIndex:10];
//        }
//    }
//}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (range.length != 0) {
        return YES;
    }
    
    if (textField == _lblPostCode && textField.text.length > 5) {
        return NO;
    } else if (textField == _lblPhone && textField.text.length > 10) {
        return NO;
    }
    return YES;
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

-(NSString *)trimBlank:(NSString *)string{
    NSString *trimString = nil;
    trimString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    trimString = [trimString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return  trimString;
}



//收货姓名：最多只能输入10个字；
//街道地址：最多只能输入50个字，且分行显示；
//邮编：必须为6位数字，且仅能输入6位；
//手机号码：只能输入11位；及姓名及地址的特殊字符输入的限制；
//地址个数（最多10个）应在点击“收货地址列表”右上角 “+”号判断；
-(void)checkAndSubmit {
//    if (_lblName.text.length <= 0) {
    if ([self isBlankString:_lblName.text]) {
        [[JLToast makeTextQuick:@"请输入姓名收货人姓名"] show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_lblName becomeFirstResponder];
        });
        
    } else if (_lblName.text.length > 10) {
        [[JLToast makeTextQuick:@"收货姓名最多只能输入10个字"] show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_lblName becomeFirstResponder];
        });
        
    } else if (![JPUtils checkHanCharacters:[self trimBlank:_lblName.text]]) {
        [[JLToast makeTextQuick:@"收货姓名不能包含特殊字符"] show];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_lblName becomeFirstResponder];
        });
        
    } else if (_addressViewModel.provinceVM.selectedItem == nil && _addressViewModel.state == nil) {
        [[JLToast makeTextQuick:@"请选择收货地址"] show];
        return;
        
    } else if (_tfDescription.text.length <= 0) {
        [[JLToast makeTextQuick:@"请输入街道地址"] show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tfDescription becomeFirstResponder];
        });
        
    } else if (_tfDescription.text.length > 50) {
        [[JLToast makeTextQuick:@"街道地址最多只能输入50个字"] show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tfDescription becomeFirstResponder];
        });
        
    }  else if ([JPUtils isContainsEmoji:_tfDescription.text]) {
        [[JLToast makeTextQuick:@"街道地址不能包含表情符号"] show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_tfDescription becomeFirstResponder];
        });
        
    } else if (_lblPostCode.text.length <= 0) {
        [[JLToast makeTextQuick:@"请输入邮政编码"] show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_lblPostCode becomeFirstResponder];
        });
        
    } else if (_lblPostCode.text.length != 6) {
        [[JLToast makeTextQuick:@"邮编必须为6位数字"] show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_lblPostCode becomeFirstResponder];
        });
        
    } else if (_lblPhone.text.length <= 0) {
        [[JLToast makeTextQuick:@"请输入手机号码"] show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_lblPhone becomeFirstResponder];
        });
        
    } else if (![GGPredicate checkPhoneNumber:_lblPhone.text]) {
        [[JLToast makeTextQuick:@"手机号码格式不对"] show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_lblPhone becomeFirstResponder];
        });
        
    } else {
        @weakify(self)
        _btnSubmit.enabled = NO;
        [[self addAddressSignal] subscribeNext:^(DymBaseRespModel *result) {
            
            @strongify(self)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self->_btnSubmit.enabled = YES;
            });
            
            if (result.success) {
                [[JLToast makeTextQuick:_address ? @"修改成功" : @"添加成功"] show];
                [self.navigationController popViewControllerAnimated:YES];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:JP_NOTIFICATION_ADDRESS_CHANGED object:nil];
                
            } else if (result.msg.length) {
                [[JLToast makeTextQuick:result.msg] show];
            }
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = _cells[indexPath.row];
    if (cell == _addressCell) {
        UILabel *label = (UILabel *)[cell viewWithTag:100];
        
        // |-16-title(90)-8-label-8-arrow(20)-16-|
        label.preferredMaxLayoutWidth = tableView.frame.size.width - (16 + 90 + 8 +8 + 20 + 16);
    } else if (cell == _streetCell) {
        [_streetCell setNeedsLayout];
        [_streetCell layoutIfNeeded];
        
        CGFloat height = _tfDescription.intrinsicContentSize.height + 16;
        
        return height > 48 ? height : 48;
    }
    
    return UITableViewAutomaticDimension;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        NSLog(@"choose province");
        UNPChooseProvinceVC *vc = [UNPChooseProvinceVC new];
        vc.viewModel = [_addressViewModel copy];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [[JPSidePopVC new] showVC:nc];
        [self.view endEditing:YES];
    }
}

-(RACSignal *)addAddressSignal {
    DymRequest *theAPI;
    
    NSNumber *state = _addressViewModel.state;
    if (_addressViewModel.provinceVM.selectedItem) {
        state = [JPUtils numberValueSafe:(_addressViewModel.provinceVM.selectedItem)[@"id"]];
    }
    NSNumber *city = _addressViewModel.city;
    if (_addressViewModel.cityVM.selectedItem) {
        city = [JPUtils numberValueSafe:(_addressViewModel.cityVM.selectedItem)[@"id"]];
    }
    NSNumber *district = _addressViewModel.district;
    if (_addressViewModel.districtVM.selectedItem) {
        district = [JPUtils numberValueSafe:(_addressViewModel.districtVM.selectedItem)[@"id"]];
    }
    
    if (_address) {
        
        InquiryApi_UpdateReciveAddress *api = [InquiryApi_UpdateReciveAddress new];
        api.addressID = _address.addressID;
        api.contactname = _lblName.text;
        api.state = state;
        api.city = city;
        api.district = district;
        api.zipcode = [JPUtils numberValueSafe:_lblPostCode.text];
        api.address = _tfDescription.text;
        api.phone = _lblPhone.text;
        theAPI = api;
        
    } else {
        
        InquiryApi_AddReciveAddress *api = [InquiryApi_AddReciveAddress new];
        api.contactname = _lblName.text;
        api.state = state;
        api.city = city;
        api.district = district;
        api.zipcode = [JPUtils numberValueSafe:_lblPostCode.text];
        api.address = _tfDescription.text;
        api.phone = _lblPhone.text;
        theAPI = api;
    }
    
    return [DymRequest commonApiSignal:theAPI queue:self.apiQueue];
}

@end
