//
//  UNPOfferItemsVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPOfferItemsVC.h"
#import "JPDesignSpec.h"
#import "UIImage+ImageWithColor.h"
#import "JPOfferItemCell.h"
#import "JPUtils.h"
#import "InquiryApi_GetScheme.h"
#import "InquiryApi_CommitOrder.h"
#import "JPAppStatus.h"
#import "UNPInquiryAddressVC.h"
#import "UnipeiApp-Swift.h"
#import "DymStoryboard.h"
#import "InquiryApi_InquiryList.h"
#import "InquiryApi_GetInquiryInfo.h"

@interface UNPOfferItemsVC () <UITableViewDataSource, UITableViewDelegate> {
    NSArray             *_optionButtons;
    UIButton            *_selectedButton;
    
    UITableViewCell     *_listHeaderCell;
    UILabel             *_lblTotalPrice;
    
    NSMutableArray      *_schemes;
    
    EJPInquiryStatus    _inquiryStatus;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *viewTopBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopBarHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnOption1;
@property (weak, nonatomic) IBOutlet UIButton *btnOption2;
@property (weak, nonatomic) IBOutlet UIButton *btnOption3;

@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIButton *btnAccept;
@property (weak, nonatomic) IBOutlet UIButton *btnRefuse;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTableViewBottom;

@end



@implementation UNPOfferItemsVC

+(instancetype)newFromStoryboard {
    return [[DymStoryboard unipeiInquiry_Storyboard] instantiateViewControllerWithIdentifier:@"UNPOfferItemsVC"];
}

-(RACSignal *)getInquiryDetail {
    
    id params = @{@"inquiryid": _inquiryID ? [JPUtils numberValueSafe:_inquiryID] : [JPUtils numberValueSafe:_quoid]};
    
    return [DymRequest commonApiSignalWithClass:[InquiryApi_GetInquiryInfo class] queue:self.apiQueue params:params];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    
    self.tableView.estimatedRowHeight = 48;
    
    _schemes = [NSMutableArray array];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    _viewTopBar.backgroundColor = [UIColor clearColor];
    _optionButtons = @[_btnOption1, _btnOption2, _btnOption3];
    
    
//    [self showLoadingView:YES];
//    [[self getInquiryDetail] subscribeNext:^(InquiryApi_GetInquiryInfo_Result *result) {
//        @strongify(self)
//        
//        if ([result isKindOfClass:[InquiryApi_GetInquiryInfo_Result class]] && result.success) {
//            
//            self->_inquiry = result.inquiryInfo;
//            self->_inquiryStatus = [_inquiry[@"status"] integerValue];
//            
//            
//            
//        } else {
//            self->_inquiryID = nil;
//            [self.tableView reloadData];
//        }
//        
//    }];
    
    [_optionButtons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        obj.layer.cornerRadius = 2;
        obj.clipsToBounds = YES;
        obj.layer.borderColor = [UIColor colorWithHexString:@"#c8c8c8"].CGColor;
        obj.layer.borderWidth = 0.5;
        [obj setTitleColor:[UIColor colorWithWhite:0 alpha:0.54] forState:UIControlStateNormal];
        [obj setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [obj setTitleColor:[UIColor colorWithWhite:0 alpha:0.54] forState:UIControlStateHighlighted];
        
        [obj setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [obj setBackgroundImage:[UIImage imageWithColor:[JPDesignSpec colorMajor]] forState:UIControlStateSelected];
        [obj setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.95 alpha:1]] forState:UIControlStateHighlighted];
        
        
        [[obj rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self optionButtonTapped:obj];
        }];
    }];
    
    [self optionButtonTapped:_btnOption1];
    
    ///
    _btnAccept.layer.cornerRadius = 4;
    _btnAccept.clipsToBounds = YES;
//    _btnAccept.layer.borderColor = [JPDesignSpec colorMajor].CGColor;
    [_btnAccept setBackgroundImage:[UIImage imageWithColor:[JPDesignSpec colorMajor]] forState:UIControlStateNormal];
    [_btnAccept setBackgroundImage:[UIImage imageWithColor:[JPDesignSpec colorGray]] forState:UIControlStateDisabled];
//    _btnAccept.layer.borderWidth = 0.5;
    [[_btnAccept rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
#if 0
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"接受报价" message:@"您是否确认接受此报价方案？" preferredStyle:UIAlertControllerStyleAlert];
        
        @weakify(self)
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            @strongify(self)
            [self actionAccept:nil];
        }];
        
        UIAlertAction *canel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:ok];
        [alertVC addAction:canel];
        
        [self presentViewController:alertVC animated:YES completion:nil];
#else
      [self actionAccept:nil];
#endif
        
    }];
    
    //
    _btnRefuse.layer.cornerRadius = 4;
    _btnRefuse.clipsToBounds = YES;
    _btnRefuse.layer.borderColor = [UIColor colorWithHexString:@"#c8c8c8"].CGColor;
    _btnRefuse.layer.borderWidth = 0.5;
    
    [[_btnRefuse rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"拒绝报价" message:@"您是否确认拒绝\n该经销商的所有报价方案？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            @weakify(self)
            [[self declineSchemaSignal] subscribeNext:^(DymBaseRespModel *result) {
                @strongify(self)
                
                if (result.success) {
                    self->_inquiryStatus = kJPInquiryStatusRefused;
                    
                    [self showFooterView:NO];
                    
                    [self.tableView reloadData];
                    
                    [[JLToast makeTextQuick:@"已拒绝"] show];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:JP_NOTIFICATION_INQUIRY_CHANGED object:nil];
                    
                    if (_schemeRefusedBlock) {
                        _schemeRefusedBlock();
                    }
                    
                } else {
                    if (result.msg.length > 0) {
                        [[JLToast makeTextQuick:result.msg] show];
                    } else {
                        [[JLToast makeTextQuick:@"拒绝失败"] show];
                    }
                }
                
            }];
        }];
        
        UIAlertAction *canel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:ok];
        [alertVC addAction:canel];
        
        [self presentViewController:alertVC animated:YES completion:nil];
    }];
    
    //
    [JPUtils installBottomLine:_viewTopBar color:[JPDesignSpec colorGray] insets:UIEdgeInsetsZero];
    [JPUtils installTopLine:_footerView color:[JPDesignSpec colorGray] insets:UIEdgeInsetsZero];
    
    
    // 请求方案数据
    [self getSchemas];
}

-(void)getSchemas {
    @weakify(self)
    
    [self showLoadingView:YES];
    [[self getSchemaSignal] subscribeNext:^(InquiryApi_GetScheme_Result *result) {
        
        @strongify(self)
        [self showLoadingView:NO];
        
        if ([result isKindOfClass:[InquiryApi_GetScheme_Result class]]) {
            
            [self->_schemes removeAllObjects];
            NSArray *schemesDic = result.schemes;
            
            for (NSArray *schemeDic in schemesDic) {
                
                NSMutableArray *scheme = [NSMutableArray array];
                
                for (id itemDic in schemeDic) {
                    JPQuatationItem *item = [MTLJSONAdapter modelOfClass:[JPQuatationItem class] fromJSONDictionary:itemDic error:nil];
                    if (item) {
                        item.selected = @(YES);
                        [scheme addObject:item];
                    }
                }
                
                [self->_schemes addObject:scheme];
            }
            
            self->_inquiryStatus = [result.QuoStatus integerValue];
        }
        
        [self handleRefresh];
    }];
}

-(void)handleRefresh {
    
    if (_schemes.count > 0) {
        
        _btnOption2.hidden = _schemes.count <= 1;
        _btnOption3.hidden = _schemes.count <= 2;
        
        [self.tableView reloadData];
        [self showEmptyView:NO text:nil];
        
    } else {
        [self showEmptyView:YES text:@"暂无商品信息"];
    }
    
    [self updateSubmitButton];
    
    BOOL shouldSelect = [self shouldSelectSchemeItems];
    [self showFooterView:shouldSelect];
    [self showTopView:_inquiryStatus != kJPInquiryStatusConformed];
}

-(void)optionButtonTapped:(UIButton *)theButton {
    [_optionButtons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        if (obj != theButton) {
            obj.selected = NO;
            obj.layer.borderColor = [UIColor colorWithHexString:@"#c8c8c8"].CGColor;
        }
    }];
    
    theButton.selected = YES;
    theButton.layer.borderColor = [JPDesignSpec colorMajor].CGColor;
    
    _selectedButton = theButton;
    
    [self.tableView reloadData];
    
    [self updateSubmitButton];
}

#pragma mark - data source
-(NSInteger)selectedIndex {
    return [_optionButtons indexOfObject:_selectedButton];
}

-(NSArray *)schemeAtIndex:(NSUInteger)index {
    if (index < _schemes.count) {
        return _schemes[index];
    }
    
    return nil;
}

-(NSArray *)currentScheme {
    return [self schemeAtIndex:[self selectedIndex]];
}

-(NSNumber *)selectedSchemeID {
    JPQuatationItem *item = [self schemeAtIndex:[self selectedIndex]].firstObject;
    return item.SchID;
}

-(NSArray *)selectedItemsInCurrentScheme {
    
    NSArray *currentScheme = [self currentScheme];
    if (currentScheme.count <= 0) {
        return nil;
    }
    
    NSMutableArray *selectedItems = [NSMutableArray array];
    for (JPQuatationItem* item in currentScheme) {
        if ([item.selected boolValue]) {
            [selectedItems addObject:item];
        }
    }
    
    return selectedItems.count > 0 ? selectedItems : nil;
}

-(CGFloat)totalPriceForScheme:(NSArray *)scheme {
    
    if (scheme.count <= 0) {
        return 0;
    }
    
    CGFloat sum = 0;
    for (JPQuatationItem* item in scheme) {
        if ([item.selected boolValue]) {
            sum += [item.RealPrice doubleValue] * [item.Num integerValue];
        }
    }
    
    return sum;
}

-(CGFloat)currentTotalPrice {
    return [self totalPriceForScheme:[self currentScheme]];
}

#pragma mark - table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return [self currentScheme].count;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 52;
    }  else if (indexPath.section == 1) {
        return UITableViewAutomaticDimension;
    }
    
    return 0;
}

-(BOOL)shouldSelectSchemeItems {
    return _inquiryStatus == kJPInquiryStatusWaitingConfirmation;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (_listHeaderCell == nil) {
            _listHeaderCell = [tableView dequeueReusableCellWithIdentifier:@"listHeaderCell" forIndexPath:indexPath];
            _lblTotalPrice = (UILabel *)[_listHeaderCell.contentView viewWithTag:100];
        }
        
        _lblTotalPrice.text = [NSString stringWithFormat:@"￥%.2f", [self currentTotalPrice]];
        
        return _listHeaderCell;
        
    } else if (indexPath.section == 1) {
        JPOfferItemCell *cell = [self shouldSelectSchemeItems] ? [tableView dequeueReusableCellWithIdentifier:@"JPOfferItemCell" forIndexPath:indexPath] : [tableView dequeueReusableCellWithIdentifier:@"JPOfferItemCell_noCheck" forIndexPath:indexPath];
        
//        {"PartsLevel":"经济实用","Name":"雨刮臂","TotalFee":150.00,"GoodFee":150.00,"Status":"2","Num":1,"GoodsID":139431,"QuoID":119,"OENO":null,"Price":2345.00,"JpCodei":0,"GoodsNO":"YGB 12222222223-----","Version":"null","RealPrice":150.00,"SchID":124}
        
        cell.tag = indexPath.row;
        
        JPQuatationItem *item = [self currentScheme][indexPath.row];
        cell.quatationItem = item;
        
        @weakify(self)
        cell.changeNumberView.numberChangedBlock = ^void(NSInteger number) {
            item.Num = @(number);
            @strongify(self)
//            [self.tableView reloadData];
            
            JPOfferItemCell *theCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:cell.tag inSection:1]];
            JPQuatationItem *item = [self currentScheme][cell.tag];
            theCell.quatationItem = item;
            self->_lblTotalPrice.text = [NSString stringWithFormat:@"￥%.2f", [self currentTotalPrice]];
        };
        
        return cell;
    }
    
    return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self shouldSelectSchemeItems] && indexPath.section == 1) {
        JPQuatationItem *item = [self currentScheme][indexPath.row];
        item.selected = @(![item.selected boolValue]);
        
        [tableView reloadData];
        
        [self updateSubmitButton];
    }
}

-(void)updateSubmitButton {
    _btnAccept.enabled = ([self selectedItemsInCurrentScheme].firstObject != nil);
}

-(void)showFooterView:(BOOL)show {
    _constraintTableViewBottom.constant = show ? 60 : 0;
    _footerView.hidden = !show;
}

-(void)showTopView:(BOOL)show {
    _constraintTopBarHeight.constant = show ? 52 : 0;
    _viewTopBar.hidden = !show;
}

#pragma mark - signals
-(RACSignal *)getSchemaSignal {
    id params = @{@"inquiryid": [JPUtils numberValueSafe:_inquiryID], @"quoid": [JPUtils numberValueSafe:_quoid]};
    
    return [DymRequest commonApiSignalWithClass:[InquiryApi_GetScheme class] queue:self.apiQueue params:params];
}

-(RACSignal *)declineSchemaSignal {
    
    NSArray *selectedItems = [self selectedItemsInCurrentScheme];
    JPQuatationItem *firstSelectedItem = selectedItems.firstObject;
    
    InquiryApi_CommitOrder *acceptAPI = [InquiryApi_CommitOrder new];
    acceptAPI.status = NO;
    acceptAPI.schid = firstSelectedItem.SchID;
    acceptAPI.inquiryid = _inquiryID;
    acceptAPI.quoid = firstSelectedItem.QuoID;
//    acceptAPI.MakeID = _inquiry[@"make"];
    
    return [DymRequest commonApiSignal:acceptAPI queue:self.apiQueue];
}

-(void)actionAccept:(id)sender {
    
    NSArray *selectedItems = [self selectedItemsInCurrentScheme];
    JPQuatationItem *firstSelectedItem = selectedItems.firstObject;
    
    InquiryApi_CommitOrder *acceptAPI = [InquiryApi_CommitOrder new];
    acceptAPI.status = YES;
    acceptAPI.schid = firstSelectedItem.SchID;
    acceptAPI.inquiryid = _inquiryID;
    acceptAPI.quoid = firstSelectedItem.QuoID;
//    acceptAPI.MakeID = _inquiry[@"make"];
//    acceptAPI.CarID = _inquiry[@"car"];
//    acceptAPI.Year = _inquiry[@"year"];
//    acceptAPI.ModelID = _inquiry[@"model"];
    
    NSMutableArray *goodsInfo = [NSMutableArray array];
    for (JPQuatationItem *item in selectedItems) {
        id itemDic = @{
                       @"TotalFee": [JPUtils stringValueSafe:item.TotalFee]
                       , @"GoodFee": [JPUtils stringValueSafe:item.GoodFee]
                       , @"Num": [JPUtils stringValueSafe:item.Num]
                       , @"GoodsNO": [JPUtils stringValueSafe:item.GoodsNO]
                       , @"SchID": [JPUtils stringValueSafe:item.SchID]
                       , @"PartsLevel": [JPUtils stringValueSafe:item.PartsLevel]
                       , @"Name": [JPUtils stringValueSafe:item.Name]
                       
                       , @"Status": [JPUtils stringValueSafe:item.Status]
                       , @"GoodsID": [JPUtils stringValueSafe:item.GoodsID]
                       , @"QuoID": [JPUtils stringValueSafe:item.QuoID]
                       , @"Price": [JPUtils stringValueSafe:item.Price]
                       , @"OENO": [JPUtils stringValueSafe:item.OENO]
                       , @"Version": [JPUtils stringValueSafe:item.Version]
                       , @"realPrice": [JPUtils stringValueSafe:item.RealPrice]
                       , @"BrandName": [JPUtils stringValueSafe:item.BrandName]
                       };
        [goodsInfo addObject:itemDic];
    }
    acceptAPI.goodsinfo = goodsInfo;
    
    UNPInquiryAddressVC *vc = [UNPInquiryAddressVC newFromStoryboard];
    vc.commitApi = acceptAPI;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
