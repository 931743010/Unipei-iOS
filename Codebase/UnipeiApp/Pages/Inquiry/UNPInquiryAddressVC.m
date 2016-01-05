//
//  UNPInquiryAdressVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/9.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPInquiryAddressVC.h"
#import "JPAddressItemCell.h"
#import "InquiryApi_FindReceiveAddress.h"
#import "UNPTwoButtonsBarView.h"
#import "UnipeiApp-Swift.h"
#import "JPSensibleButton.h"
#import "DymStoryboard.h"
#import "UNPInquiryAddressModifyVC.h"
#import <Masonry/Masonry.h>
#import "GGPredicate.h"
#import "UNPChooseCouponVC.h"
#import "DymNavigationController.h"
#import "LotteryDrawViewController.h"
#import "JPAppStatus.h"
#import "LotteryDrawViewController.h"
#import "ShowLotteryViewController.h"


static NSString *keyLogisticCompany = @"logisticscompany";

@interface UNPInquiryAddressVC () <UITableViewDataSource, UITableViewDelegate
, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate> {
    NSArray             *_addresses;
    UIRefreshControl    *_refreshControl;
    NSUInteger          _selectedIndex;
    UIBarButtonItem     *_barBtnAdd;
    NSArray             *_logisticCompanies;
    
    UITableViewCell     *_logisticCell;
    UITextField         *_tfLogistic;
    UIButton            *_btnLogistic;
    UIPickerView        *_pvLogistic;
    
    UITableViewCell     *_couponCell;
    UITextField         *_tfCoupon; //999
    UIButton            *_btnCoupon; // 10000
    UILabel             *_lblOrderPrice; // 1000
    UILabel             *_lblCouponPrice; // 1001
    UILabel             *_lblActualPrice; // 1002
    
    CGFloat             _totalPrice;
    NSArray             *_coupons;
    id                  _selectedCoupon;
    BOOL                _dontUseCoupon; // 选择了『不使用优惠券』时 == YES
    
    NSUInteger          _pendingRequestCount;
    
    DymBaseRespModel    *_nextResult;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UNPTwoButtonsBarView *bottomView;

@end

@implementation UNPInquiryAddressVC

+(instancetype)newFromStoryboard {
    return [[DymStoryboard unipeiInquiry_Storyboard] instantiateViewControllerWithIdentifier:@"UNPInquiryAddressVC"];
}

+(instancetype)viewFromStoryboard {
    return [[DymStoryboard unipei_Lottery_Storyboard] instantiateViewControllerWithIdentifier:@"lotterydraw"];
}


-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self hidePickerView:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    @weakify(self)
    
    self.navigationItem.title = @"确认报价单";
    
    _pvLogistic = [[UIPickerView alloc] init];
    _pvLogistic.backgroundColor = [UIColor colorWithWhite:1 alpha:0.98];
    _pvLogistic.delegate = self;
    _pvLogistic.dataSource = self;
    _pvLogistic.alpha = 0;
    _pvLogistic.layer.shadowColor = [UIColor blackColor].CGColor;
    _pvLogistic.layer.shadowOpacity = 0.2;
    _pvLogistic.layer.shadowOffset = CGSizeMake(0, -3);
    _pvLogistic.layer.shadowRadius = 6;
    
    
    self.tableView.estimatedRowHeight = 115;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    _totalPrice = [self calcTotalPrice];
    
    // Create inquiry button
    JPSensibleButton *btnAdd = [[JPSensibleButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [btnAdd setImage:[UIImage imageNamed:@"btn_circle_add"] forState:UIControlStateNormal];
    [[btnAdd rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self modifyWithAddress:nil];
    }];
    
    _barBtnAdd = [[UIBarButtonItem alloc] initWithCustomView:btnAdd];
    self.navigationItem.rightBarButtonItem = _barBtnAdd;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:_refreshControl];
    
    [[_refreshControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self)
        [self getAddresses];
    }];
    
    
    // bottomView
    [_bottomView showSecondButton:NO];
    [_bottomView.btnFirst setTitle:@"确认发送" forState:UIControlStateNormal];
    [[_bottomView.btnFirst rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        @strongify(self)
        NSString *text = self->_tfLogistic.text;
        BOOL isShipNameValid = YES;
        NSString *message = nil;
        
        if (text.length > 10) {
            
            isShipNameValid = NO;
            message = @"物流公司名称最多10个字";
            
        } else if (![JPUtils checkHanCharacters:text]) {
            if (![self isBlankString:text]) {
                [self trimBlank:text];
            }else{
                isShipNameValid = NO;
                message = @"物流公司名称不能包含特殊字符";
            }
           

        }
        
        if (!isShipNameValid) {
            [[JLToast makeTextQuick:message] show];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self->_tfLogistic becomeFirstResponder];
            });
            
            return;
        }
        
        //
        self.tableView.userInteractionEnabled = NO;
        self->_bottomView.btnFirst.enabled = NO;
        @weakify(self)
        [[self commitSchemeSignal] subscribeNext:^(DymBaseRespModel *result) {
            @strongify(self)
            self.tableView.userInteractionEnabled = YES;
            self->_bottomView.btnFirst.enabled = YES;
            
            if (result.success) {
                
                [[JLToast makeTextQuick:@"方案已确认"] show];
                
                self->_nextResult = result;
                //    {
                //        Amount = 30;
                //        CouponSn = 1536543195;
                //        OrderMinAmount = "全场通用";
                //        State = 0;
                //        Title = "手机app武汉测试联盟获取优惠券";
                //        Validity = "有效期至 2016-01-30 17:26";
                //    }
                 NSNumber *status = result.body[@"Status"];
//                State: 0/1/2  0 没有优惠券，1，固定优惠券（Coupon 数据），2随机优惠券 
                if (status.intValue==2) {
                    [self goToDrawLottery];
                }else if (status.intValue==1) {  //固定优惠券,跳转到现实页面
                    NSDictionary *coupon = result.body[@"Coupon"];
                    [self goToShowLottery:coupon];
                }else{  //0,没有优惠券,直接返回
                    if (self.navigationController.presentingViewController == nil) {
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    } else {
                        [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                    }
                }
        

//                [[NSNotificationCenter defaultCenter] postNotificationName:JP_NOTIFICATION_INQUIRY_CHANGED object:nil];
   
                /// wait 3 sec
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    LotteryDrawViewController *lotteryDrawVC = (LotteryDrawViewController *)[UNPInquiryAddressVC viewFromStoryboard];
//                    [[JPUtils topMostVC] presentViewController:lotteryDrawVC animated:YES completion:nil];
//                });
                
            } else {
                
                NSString *errorMessage = result.msg;
                if (errorMessage) {
                    [[JLToast makeTextQuick:errorMessage] show];
                } else {
                    [[JLToast makeTextQuick:@"无法确认报价"] show];
                }
            }
            
        }];
    }];
    
    
    // Request data
    [self getLogistics];
    [self getCoupons];
    [self getAddresses];
    [_refreshControl beginRefreshing];
    _pendingRequestCount = 3;
    [self showLoadingView:YES];
    
    
    
    /// notifications
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:JP_NOTIFICATION_ADDRESS_CHANGED object:nil queue:nil usingBlock:^(NSNotification *note) {
        @strongify(self)
        [self getAddresses];
        [self->_refreshControl beginRefreshing];
    }];
    
    [self.observerQueue addObject:observer];
}


//判断空格
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
//去掉空格
-(NSString *)trimBlank:(NSString *)string{
    NSString *trimString = nil;
    trimString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    trimString = [trimString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return  trimString;
}


-(CGFloat)calcTotalPrice {
    if (_commitApi.goodsinfo.count <= 0) {
        return 0;
    }
    
    CGFloat total = 0;
    for (id item in _commitApi.goodsinfo) {
        total += [item[@"realPrice"] floatValue] * [item[@"Num"] integerValue];
    }
    
    return total;
}

-(void)modifyWithAddress:(JPInquiryAddress *)address {
    
    if (address == nil && _addresses.count > 9) {
        [[JLToast makeTextQuick:@"收货地址最多10条，不能继续添加"] show];
        return;
    }
    
    UNPInquiryAddressModifyVC *vc = [UNPInquiryAddressModifyVC newFromStoryboard];
    vc.address = address;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    }
    
    return _addresses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (_logisticCell == nil) {
            _logisticCell = [tableView dequeueReusableCellWithIdentifier:@"logisticCell" forIndexPath:indexPath];
            _logisticCell.contentView.backgroundColor = [UIColor clearColor];
            UIView *containterView = [_logisticCell.contentView viewWithTag:100];
            containterView.backgroundColor = [UIColor whiteColor];
            _tfLogistic = (UITextField *)[containterView viewWithTag:999];
            _btnLogistic = (UIButton *)[containterView viewWithTag:101];
            
            _tfLogistic.placeholder = @"请填写/选择物流公司名称";
            _tfLogistic.delegate = self;
//            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
//                                                        name:UITextFieldTextDidChangeNotification
//                                                      object:_tfLogistic];
            
            @weakify(self)
            [[_btnLogistic rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self)
                [self showLogisticPicker];
            }];
        }
        
        return _logisticCell;
        
    } else if (indexPath.section == 1) {
        
        if (_couponCell == nil) {
            
            _couponCell = [tableView dequeueReusableCellWithIdentifier:@"couponCell" forIndexPath:indexPath];
            UIView *containterView = [_couponCell.contentView viewWithTag:100];
            containterView.backgroundColor = [UIColor whiteColor];
            _tfCoupon = (UITextField *)[containterView viewWithTag:999];
            _btnCoupon = (UIButton *)[containterView viewWithTag:10000];
            _btnCoupon.backgroundColor = [UIColor clearColor];
            
            _lblOrderPrice = (UILabel *)[containterView viewWithTag:1000];
            _lblCouponPrice = (UILabel *)[containterView viewWithTag:1001];
            _lblActualPrice = (UILabel *)[containterView viewWithTag:1002];
            
            @weakify(self)
            [[_btnCoupon rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                @strongify(self)
                UNPChooseCouponVC *vc = [UNPChooseCouponVC newFromStoryboard];
                vc.coupons = self->_coupons;
                @weakify(self)
                vc.chosenBlock = ^(id chosenItem) {
                    @strongify(self)
                    
                    if (chosenItem == nil) {
                        self->_dontUseCoupon = YES;
                    }
                    
                    self->_selectedCoupon = chosenItem;
                    [self.tableView reloadData];
                    [self dismissViewControllerAnimated:YES completion:nil];
                };
                
                UIBarButtonItem *btnClose = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:vc action:@selector(closeMe)];
                vc.navigationItem.rightBarButtonItem = btnClose;
                
                DymNavigationController *nc = [[DymNavigationController alloc] initWithRootViewController:vc];
                [self presentViewController:nc animated:YES completion:nil];
            }];
        }
        
        BOOL hasCoupon = _coupons.count > 0;
        NSString *couponStr = nil;
        CGFloat couponPrice = 0;
        
        if (_selectedCoupon) {
             couponPrice = [_selectedCoupon[@"amount"] floatValue];
            couponStr = [NSString stringWithFormat:@"￥%.2f", couponPrice];
        } else {
            couponStr = hasCoupon ? (_dontUseCoupon ? @"不使用优惠券" : @"请选择优惠券") : @"没有可用的优惠券";
        }
        
        _btnCoupon.enabled = hasCoupon;
        _tfCoupon.text = couponStr;
        
        _lblOrderPrice.text = [NSString stringWithFormat:@"订单金额：￥%.2f", _totalPrice];
        _lblCouponPrice.text = [NSString stringWithFormat:@"优惠券：￥%.2f", couponPrice];
        
        CGFloat actualPrice = _totalPrice - couponPrice;
        actualPrice = MAX(0, actualPrice);
        _lblActualPrice.text = [NSString stringWithFormat:@"实付金额：￥%.2f", actualPrice];
        
        return _couponCell;
    }
    
    JPAddressItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JPAddressItemCell" forIndexPath:indexPath];
    
    JPInquiryAddress *address = _addresses[indexPath.row];
    cell.lblAddress.text = address.address;
    cell.lblName.text = [NSString stringWithFormat:@"%@ %@", address.contactname, address.phone];

    cell.lblPostCode.text = address.zipcode;
    cell.btnEdit.tag = indexPath.row;
    [cell.btnEdit removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [cell.btnEdit addTarget:self action:@selector(actionEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setChecked:(_selectedIndex == indexPath.row)];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        _selectedIndex = indexPath.row;
        [tableView reloadData];
    }

}


#pragma mark - actions
-(void)actionEdit:(UIButton *)button {
    NSInteger index = button.tag;
    JPInquiryAddress *address = _addresses[index];
    [self modifyWithAddress:address];
}

-(void)goToDrawLottery{
    LotteryDrawViewController *lotteryDrawVC = (LotteryDrawViewController *)[UNPInquiryAddressVC viewFromStoryboard];
    lotteryDrawVC.lotteryParam =  _nextResult;
    [self.navigationController pushViewController:lotteryDrawVC animated:YES];
    
}

-(void)goToShowLottery:(NSDictionary *) coupon{
    ShowLotteryViewController *showLotteryVC = [[ShowLotteryViewController alloc] initWithNibName:@"ShowLotteryViewController" bundle:nil];
    showLotteryVC.coupon = coupon;
    [self presentViewController:showLotteryVC animated:YES completion:nil];
}



#pragma mark - requests
-(void)handleReuqstFinished {
    _pendingRequestCount--;
    if (_pendingRequestCount == 0) {
        [self showLoadingView:NO];
    }
}

-(void)getLogistics {
    @weakify(self)
    DymCommonApi *api = [DymCommonApi new];
    api.relativePath = PATH_commonApi_findLogisticsList;
    [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
        @strongify(self)
        if (result.success) {
            self->_logisticCompanies = result.body[@"logisticsList"];
        }
        [self handleReuqstFinished];
    }];
}

-(void)getCoupons {
//    [self testApiPath:@"inquiryApi/findCouponList.do"
//               params:@{@"amount": @200}
//           organIDKey:@"ownerId" organIdClass:nil
//              apiName:@"查询优惠券"];
    
    DymCommonApi *api = [DymCommonApi new];
    api.relativePath = @"inquiryApi/findCouponList.do";
    api.params = @{@"amount": @(_totalPrice)};
    api.custom_organIdKey = @"ownerId";
    
    @weakify(self)
    [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
        
        @strongify(self)
        if (result.success) {
            self->_coupons = result.body[@"list"];
        }
        
        [self.tableView reloadData];
        [self handleReuqstFinished];
    }];
}

-(void)getAddresses {
    
    @weakify(self)
    [[self getAddressesSignal] subscribeNext:^(InquiryApi_FindReceiveAddress_Result *result) {
        @strongify(self)
        [self->_refreshControl endRefreshing];
        BOOL hasData = NO;
        if ([result isKindOfClass:[InquiryApi_FindReceiveAddress_Result class]] && result.success) {
            self->_addresses = result.addressList;
            [self.tableView reloadData];
            hasData = result.addressList.count > 0;
        }
        
        [self handleReuqstFinished];
        [self showEmptyView:!hasData text:@"您还没有添加收货地址哦"];
    }];
}






#pragma mark - signals


-(RACSignal *)getLotterySignal {

    DymCommonApi *api = [DymCommonApi new];
    api.relativePath = PATH_inquiryApi_lottery;
    api.apiVersion = @"V2.2";
 
    
    NSString *promoid = _nextResult.body[@"promoid"];
    api.params = @{@"promoid": promoid};
          api.params = @{@"organid": [JPAppStatus loginInfo].unionID
                          , @"promoid": promoid
                         };
    return [DymRequest commonApiSignal:api queue:self.apiQueue];
}

-(RACSignal *)getAddressesSignal {
    return [DymRequest commonApiSignalWithClass:[InquiryApi_FindReceiveAddress class] queue:self.apiQueue params:nil];
}

-(RACSignal *)commitSchemeSignal {
    JPInquiryAddress *address = _addresses[_selectedIndex];
    _commitApi.addressID = address.addressID;
    if (_tfLogistic.text.length > 0) {
        BOOL isInTheList = [self indexOfLogisticName:_tfLogistic.text] != NSNotFound;
        if (isInTheList) {
            _commitApi.shipname = _tfLogistic.text;
        } else {
            _commitApi.shiplogis = _tfLogistic.text;
        }
    }
    
    if (_selectedCoupon) {
        _commitApi.couponsn = _selectedCoupon[@"couponsn"];
    }
    
    return [DymRequest commonApiSignal:_commitApi queue:self.apiQueue waitingMessage:@"确认中"];
}


#pragma mark - @protocol UIPickerViewDataSource<NSObject>

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    if (pickerView == _pvLogistic) {
        return _logisticCompanies.count;
    }
    
    return _coupons.count;
}

#pragma mark -@protocol UIPickerViewDelegate<NSObject>

// If you return back a different object, the old one will be released. the view will be centered in the row rect
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (pickerView == _pvLogistic) {
        
        if (_logisticCompanies.count > row) {
            id info = _logisticCompanies[row];
            return info[keyLogisticCompany];
        }
        
    }
    
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    @weakify(self)
    if (pickerView == _pvLogistic) {
        
        [self hidePickerView:^{
            @strongify(self)
            NSString *title = [self pickerView:pickerView titleForRow:row forComponent:component];
            self->_tfLogistic.text = title;
        }];
        
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 44;
}



-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self hidePickerView:nil];
}

#pragma mark - helper
// Coupon data JSON
//{"id":62,"couponsn":"1532195874","couponid":2,"promoid":4,"ownerid":174582,"isuse":0,"createtime":1447836132,"amount":30.00,"valid":"30","orderminamount":""}

//-(void)showCouponPicker {
//    [_tfLogistic resignFirstResponder];
//    [_pvCoupon removeFromSuperview];
//    [self.view.window addSubview:_pvCoupon];
//    [_pvCoupon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.trailing.and.bottom.equalTo(self.view.window);
//        make.height.equalTo(@150);
//    }];
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        _pvCoupon.alpha = 1;
//        
//        [_coupons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if (_selectedCoupon == obj) {
//                [_pvCoupon selectRow:idx inComponent:0 animated:YES];
//                *stop = YES;
//            }
//        }];
//    }];
//}
//
//-(void)hideCouponPickerView:(dispatch_block_t)completion {
//    _pvCoupon.userInteractionEnabled = NO;
//    [UIView animateWithDuration:0.25 animations:^{
//        _pvCoupon.alpha = 0;
//    } completion:^(BOOL finished) {
//        [_pvCoupon removeFromSuperview];
//        _pvCoupon.userInteractionEnabled = YES;
//        
//        if (completion) {
//            completion();
//        }
//    }];
//}

-(void)showLogisticPicker {
    [_tfLogistic resignFirstResponder];
    [_pvLogistic removeFromSuperview];
    [self.view.window addSubview:_pvLogistic];
    [_pvLogistic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.and.bottom.equalTo(self.view.window);
        make.height.equalTo(@150);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
        _pvLogistic.alpha = 1;
        NSInteger index = [self indexOfLogisticName:_tfLogistic.text];
        if (index != NSNotFound) {
            [_pvLogistic selectRow:index inComponent:0 animated:YES];
        }
    }];
}

-(void)hidePickerView:(dispatch_block_t)completion {
    _pvLogistic.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
        _pvLogistic.alpha = 0;
    } completion:^(BOOL finished) {
        [_pvLogistic removeFromSuperview];
        _pvLogistic.userInteractionEnabled = YES;
        
        if (completion) {
            completion();
        }
    }];
}

-(NSInteger)indexOfLogisticName:(NSString *)name {
    __block NSInteger index = NSNotFound;
    if (name.length <= 0) {
        return index;
    }
    
    [_logisticCompanies enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj[keyLogisticCompany] isEqualToString:name]) {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}

#pragma mark -

//-(void)updateCouponState {
//    BOOL hasCoupon = _coupons.count > 0;
//    
//}

@end
