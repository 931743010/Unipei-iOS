//
//  UNP4sQueryVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/12/25.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UNP4sQueryVC.h"
#import "JPSubmitButton.h"
#import "JPBorderedTextField.h"
#import <Masonry/Masonry.h>
#import "UNPCarModelChooseVM.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UNPChooseBrandVC.h"
#import "JPSidePopVC.h"
#import "GGPredicate.h"
#import <UnipeiApp-Swift.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "NSString+GGAddOn.h"
#import "JPDesignSpec.h"
#import "OfferInqueryResultFor4sViewController.h"
#import "CameraViewController.h"
#import "DymNavigationController.h"

static NSString *VIN = @"VIN码";
static NSString *OE = @"OE号";


@interface UNP4sQueryVC () <UITextFieldDelegate,CameraDelegate> {
    
    UNPCarModelChooseVM     *_carModelChooseVM;
    NSString                *_vinString;
    
    id                      _vinInfo;
    CameraViewController *_cameraView ;
    DymBaseRespModel *_vinScanReturnValue;
    DymBaseRespModel *_veScanReturnValue;
    NSString *_vinCode;
    NSString *_veCode;
}

@property (weak, nonatomic) IBOutlet UIView *bgChooseModel;
@property (weak, nonatomic) IBOutlet JPSubmitButton *btnChooseModel;
@property (weak, nonatomic) IBOutlet JPBorderedTextField *tfVinCode;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;


@property (weak, nonatomic) IBOutlet UIView *bgOE;
@property (weak, nonatomic) IBOutlet JPBorderedTextField *tfOE;

@property (weak, nonatomic) IBOutlet UIView *bgPart;
@property (weak, nonatomic) IBOutlet JPBorderedTextField *tfPart;

@property (weak, nonatomic) IBOutlet JPSubmitButton *btnSubmit;

@end

@implementation UNP4sQueryVC

+(instancetype)newFromStoryboard {
    return [[UIStoryboard storyboardWithName:@"Unipei_4S" bundle:nil] instantiateViewControllerWithIdentifier:@"UNP4sQueryVC"];
}

+(instancetype)viewFromStoryboard {
    return [[DymStoryboard unipei_Lottery_Storyboard] instantiateViewControllerWithIdentifier:@"lotterydraw"];
}

- (void)viewDidLoad {
    @weakify(self)
    [super viewDidLoad];
    
    self.navigationItem.title = @"4S报价查询";
    
    _carModelChooseVM = [UNPCarModelChooseVM new];
    _carModelChooseVM.hideUnsureOptions = YES;
    
    _lblMessage.text = nil;
    
    _bgChooseModel.layer.masksToBounds = _bgOE.layer.masksToBounds = _bgPart.layer.masksToBounds = YES;
    _bgChooseModel.layer.cornerRadius = _bgOE.layer.cornerRadius = _bgPart.layer.cornerRadius = 5;
    _bgChooseModel.layer.borderWidth = _bgOE.layer.borderWidth = _bgPart.layer.borderWidth = 0.5;
    _bgChooseModel.layer.borderColor = _bgOE.layer.borderColor = _bgPart.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    
    _btnChooseModel.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _btnChooseModel.titleLabel.textAlignment = NSTextAlignmentCenter;
    _btnChooseModel.style = kJPButtonWhite;
    _btnChooseModel.verticalWhiteSpace = 20;
    _btnSubmit.style = kJPButtonOrange;
    
    _tfVinCode.backgroundColor = _tfOE.backgroundColor = _tfPart.backgroundColor = [UIColor clearColor];
    _tfVinCode.textField.placeholder = @"请输入17位Vin码字符/扫一扫";
    _tfVinCode.textField.delegate = self;
    
    [[ _tfVinCode.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self takeVinPhoto];
     }];
    _tfVinCode.textField.returnKeyType = UIReturnKeySearch;
    
    _tfOE.textField.placeholder = @"请输入OE号/扫一扫";
    [[ _tfOE.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self takeVEPhoto];
    }];

    
    
    _tfPart.textField.placeholder = @"请填写配件名称";
    _tfPart.rightButton.hidden = YES;
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
    
    //通知
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFY_String_carModelSelected object:nil queue:nil usingBlock:^(NSNotification *note) {
        @strongify(self)
        if ([note.object isKindOfClass:[UNPCarModelChooseVM class]]) {
            self->_carModelChooseVM = note.object;
            [self->_btnChooseModel setTitle:[self->_carModelChooseVM fullName] forState:UIControlStateNormal];
        }
    }];
    
    [self.observerQueue addObject:observer];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleVinCodeRec:) name:JP_NOTIFICATION_VIN_CODE_RECOGNIZED object:nil];
    

    
    
    // 按钮事件
    [[_btnChooseModel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        
//#error 选择车型，一选到底，去掉不确定XX
        UNPChooseBrandVC *vc = [UNPChooseBrandVC newFromStoryboard];
        vc.viewModel = [self->_carModelChooseVM copy];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [[JPSidePopVC new] showVC:nc];
        [self.view endEditing:YES];
    }];
    
    [[_btnSubmit rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self actionSubmit];
    }];
    
    
    //vin 识别
    _cameraView= [[CameraViewController alloc]init];
    _cameraView.nsCompanyName = @"北京嘉配科技有限公司";
    _cameraView.delegate = self;
}


#pragma mark - actions
-(void)actionSubmit {
    
    [self.view endEditing:YES];
    
    NSString *oeString = _tfOE.textField.text.trim;
    NSString *partString = _tfPart.textField.text.trim;
    
//    if (_vinString.length < 10) {
//        [[JLToast makeTextQuick:@"VIN码不能少于10位"] show];

    if (_vinInfo[@"modelID"] == nil && _carModelChooseVM.modelVM.selectedItem == nil) {
        [[JLToast makeText:@"请先选择车型"] show];
    } else if (oeString.length <= 0 && partString.length <= 0) {
        [[JLToast makeText:@"OE号和配件至少选填一项"] show];
    } else if (oeString.length > 0 && ![GGPredicate checkCharacter:oeString]) {
        [[JLToast makeText:@"OE号必须由字母或数字组成"] show];
        [_tfOE.textField becomeFirstResponder];
    } else {
        
        // type=0,表示根据oe号查询 type=1,表示根据配件名称查询 type=2表示oe号，配件名称都填
        // {"type":"0", "token": "0", "modelId":"1001001","oeno":"S","name":"AB"}
        
        DymCommonApi *api = [DymCommonApi new];
        api.relativePath = @"foursApi/allfoursList.do";
        api.apiVersion = @"V2.2";
        
        NSInteger type = 0;
        if (oeString.length > 0 && partString.length > 0) {
            type = 2;
        } else if (partString.length > 0) {
            type = 1;
        }
        
        //{"header":{"code":"200","success":true,"msg":"操作成功"},"body":{"cxi":"英朗","isexist":0,"cjmc":"上海通用","cx":"英朗XT","pp":"别克","nk":"2013","txt":"上海通用 别克 英朗 2013 英朗XT"}}
        
        NSInteger modelId = 0;
        if (_vinInfo[@"modelID"]) {
            modelId = [_vinInfo[@"modelID"] integerValue];
        } else {
            modelId = [((JPCarModel *)(_carModelChooseVM.modelVM.selectedItem)).modelid integerValue];
        }
        
        NSMutableDictionary *params = @{@"type": [@(type) stringValue], @"modelId": [@(modelId) stringValue]}.mutableCopy;
        if (oeString.length > 0) {
            [params setObject:oeString forKey:@"oeno"];
        }
        if (partString.length > 0) {
            [params setObject:partString forKey:@"name"];
        }
        
        api.params = params;
        _btnSubmit.enabled = NO;
        [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
            _btnSubmit.enabled = YES;
            if (result.success) {
                NSArray *allfoursList = result.body[@"allfoursList"];
                if(allfoursList.count >0){
                    OfferInqueryResultFor4sViewController *offerVC = [self getOfferInqueryResultFor4sVC];
                    offerVC.allfoursList = allfoursList;
                    offerVC.titleContent= self->_btnChooseModel.titleLabel.text;
                    [self.navigationController pushViewController:offerVC animated:YES];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"暂未查到数据！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                     [alert show];
                    
                }
              
            }
        }];
    }
}


- (void)takeVinPhoto {
        DymNavigationController *nc = [[DymNavigationController alloc] initWithRootViewController:_cameraView];
         _cameraView.scanType = VIN;
        _cameraView.navigationController.navigationBarHidden = YES;
        [self presentViewController:nc animated:YES completion:nil];
}

- (void)takeVEPhoto {
    DymNavigationController *nc = [[DymNavigationController alloc] initWithRootViewController:_cameraView];
    _cameraView.scanType = OE;
    _cameraView.navigationController.navigationBarHidden = YES;
    [self presentViewController:nc animated:YES completion:nil];
}

-(void)handleVinCodeRec:(NSNotification *)note {
    
//    self.vinCode = note.object[@"vinCode"];
    
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
    
    NSString *scanType = note.object[@"scanType"];
    NSLog(@"scanType = %@",scanType);
    NSString *code = note.object[@"vinCode"];
    if ([scanType isEqualToString:VIN]) {
        _vinString = code;
        _tfVinCode.textField.text = code;
        [self formatingTfInputVin];
        [self validateVinCode];
    }
    if ([scanType isEqualToString:OE]) {
        _tfOE.textField.text = code;
    }

//    [self.tableView reloadData];
}

-(OfferInqueryResultFor4sViewController *)getOfferInqueryResultFor4sVC{
    OfferInqueryResultFor4sViewController *offerVC = (OfferInqueryResultFor4sViewController *)
    [[DymStoryboard unipei_Lottery_Storyboard] instantiateViewControllerWithIdentifier:@"offerInquery4s"];
    return offerVC;
}


#pragma mark - table View delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return 4;
    }
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [UIView new];
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor colorWithWhite:0.54 alpha:1];
    
    [header addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(header).insets(UIEdgeInsetsMake(0, 16, 0, 16));
    }];
    
    if (section == 0) {
        label.text = @"车型选择";
    } else if (section == 1) {
        label.text = @"OE号";
    } else if (section == 2) {
        label.text = @"配件名称";
    }
    
    return header;
}



#pragma mark - text field delegate
//1G1BL52P7T0000000
//LBVCU3106DSH37179
//LDCC23141C1336812
//LFV3B28RXC3003666
//LSGPB64E9DD306118
//LSVAA49J132047371
//LWVAA1561CA010631
//WVWZZZ1KZ90000000
//cvV3B28RXC3003666

//{"header":{"code":"200","success":true,"msg":"操作成功"},"body":{"cxi":"英朗","isexist":0,"cjmc":"上海通用","cx":"英朗XT","pp":"别克","nk":"2013","txt":"上海通用 别克 英朗 2013 英朗XT"}}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    @weakify(self)
    if (textField == _tfVinCode.textField) {

        [self formatingTfInputVin];
//        [self formatVINInput:textField.text];

        if (_vinString.length < 10) {
//         if (textField.text.length < 10) {
            [[JLToast makeTextQuick:@"VIN码不能少于10位"] show];
            return NO;
        } else {
            
            DymCommonApi *api = [DymCommonApi new];
            api.relativePath = PATH_commonApi_getVinInfo;
            api.custom_organIdKey = @"organID";
            api.params = @{@"vinCode": _vinString};
//            api.params = @{@"vinCode": @"LFV3B28RXC3003666"};
            [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
                @strongify(self)
                if (result.success) {
                    self->_vinInfo = result.body;
                    self.lblMessage.textColor = [JPDesignSpec colorGrayDark];
                    
                    NSString *message = [NSString stringWithFormat:@"%@", result.body[@"txt"]];
                    self.lblMessage.text = message;
                    if (result.body[@"modelID"]) {
                        [self->_btnChooseModel setTitle:result.body[@"txt"] forState:UIControlStateNormal];
                    }
                } else {
                    self->_vinInfo = nil;
                    self.lblMessage.textColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
                    self.lblMessage.text = @"此VIN码未能匹配到任何车型";
//                    [SVProgressHUD showInfoWithStatus:@"此VIN码未能匹配到任何车型"];
                }
            }];
        }
        
    }
    
    [textField resignFirstResponder];
    return YES;
}


-(void) validateVinCode{
  @weakify(self)
    if (_vinString.length < 10) {
        [[JLToast makeTextQuick:@"VIN码不能少于10位"] show];
    } else {
        DymCommonApi *api = [DymCommonApi new];
        api.relativePath = PATH_commonApi_getVinInfo;
        api.custom_organIdKey = @"organID";
        api.params = @{@"vinCode": _vinString};
        //            api.params = @{@"vinCode": @"LFV3B28RXC3003666"};
        [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
            @strongify(self)
            if (result.success) {
                self->_vinInfo = result.body;
                self.lblMessage.textColor = [JPDesignSpec colorGrayDark];
                
                NSString *message = [NSString stringWithFormat:@"%@", result.body[@"txt"]];
                self.lblMessage.text = message;
                if (result.body[@"modelID"]) {
                    [self->_btnChooseModel setTitle:result.body[@"txt"] forState:UIControlStateNormal];
                }
            } else {
                self->_vinInfo = nil;
                self.lblMessage.textColor = [[UIColor redColor] colorWithAlphaComponent:0.8];
                self.lblMessage.text = @"此VIN码未能匹配到任何车型";
            }
        }];
    }
}


-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _tfVinCode.textField) {
        _tfVinCode.textField.text = [_tfVinCode.textField.text uppercaseString];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _tfVinCode.textField) {
        _vinString = [_vinString stringByAppendingString:string];
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
    _tfVinCode.textField.text = formatedString;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _tfVinCode.textField.text = [_tfVinCode.textField.text uppercaseString];
    });
}

-(void)formatVINInput:(NSString *) text {
    NSString *formatedString = [JPUtils vinFormatedString:text];
    _tfVinCode.textField.text = formatedString;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _tfVinCode.textField.text = [_tfVinCode.textField.text uppercaseString];
    });
}



#pragma mark - CamaraDelegate
//识别核心初始化结果，判断核心是否初始化成功
- (void)initVinTyperWithResult:(int)nInit{
    NSLog(@"识别核心初始化结果nInit>>>%d<<<",nInit);
}

@end
