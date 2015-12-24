//
//  MyOrderFilterVC.m
//  DymIOSApp
//
//  Created by xujun on 15/10/28.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "MyOrderFilterVC.h"
#import "JPDesignSpec.h"
#import <Masonry/Masonry.h>
#import "JPOptionButtonsView.h"
#import "JPDatePicker.h"
#import <UnipeiApp-Swift.h>
#import "JPSidePopVC.h"
#import "JPUtils.h"
#import "MyOrderFilterTimeCell.h"
#import "MyOrderFilterStatusCell.h"
#import "MyOrderFilterClearCell.h"
#import "MyOrderFilterSellernameCell.h"
#import "MyOrderFilterMoneyCell.h"

@interface MyOrderFilterVC ()<UITableViewDataSource,UITableViewDelegate,MyOrderFilterSellernameCell,MyOrderFilterMoneyCellDelegate>
{
    UITableView *_table;
    OrderApi_OrderList  *_filterDataCopy;
    NSInteger *_clickNum;
    MyOrderFilterTimeCell *dateCell;
    MyOrderFilterMoneyCell *moneyCell;
    MyOrderFilterSellernameCell *sellernameCell;
}
@end

@implementation MyOrderFilterVC
- (void)viewDidLoad {
    
    @weakify(self)
    
    [super viewDidLoad];
    
    _clickNum = 0;
    
    [self.navigationItem setTitle:@"筛选"];
    
    _filterDataCopy = [_filterData copy];
    
    /// 导航条按钮
    UIBarButtonItem *fixedGap = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedGap.width = 16;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil];
    leftBarButton.tintColor = [UIColor colorWithWhite:0 alpha:0.54];
    self.navigationItem.leftBarButtonItems = @[fixedGap, leftBarButton];
    leftBarButton.rac_command = [self dismissPopViewCommand];
    
    //
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:nil action:nil];
    rightBarButton.tintColor = [JPDesignSpec colorMajor];
    self.navigationItem.rightBarButtonItems = @[fixedGap, rightBarButton];
    
    rightBarButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        [self comfirmAndDismiss];
        
        return [RACSignal empty];
    }];
    
    _table = [UITableView new];
    _table.dataSource = self;
    _table.delegate = self;
    _table.backgroundColor = [UIColor clearColor];
//    [_table setBackgroundColor:[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0]];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
        
    }];
    
    [_table reloadData];
    
}
#pragma mark - UITableViewDatasource and Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 5;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 8;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        return 70;
    }else if (indexPath.section == 1){
        return 70;
    }else if (indexPath.section == 2){
        return 220;
    }else if (indexPath.section == 3){
        return 70;
    }else if (indexPath.section == 4){
        return 60;
    }return 0;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (!dateCell) {
            
            dateCell = [[MyOrderFilterTimeCell alloc] init];
            [dateCell.endTimeBtn addTarget:self action:@selector(endTimeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [dateCell.startTimeBtn addTarget:self action:@selector(startTimeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [self updateFilterOptionViews];

            dateCell.selectionStyle = UITableViewCellSelectionStyleNone;
            

        }
        return dateCell;

        
    }else if (indexPath.section == 1){
        
        if (!moneyCell) {
            
            moneyCell = [[MyOrderFilterMoneyCell alloc] init];
            moneyCell.selectionStyle = UITableViewCellSelectionStyleNone;
            moneyCell.delegate = self;
            
            [self updateFilterOptionViews];
        }
        
        return moneyCell;
        
    }else if (indexPath.section == 2){
        
        MyOrderFilterStatusCell *cell = [[MyOrderFilterStatusCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *values = @[@(kJPOrderStatusAll),@(kJPOrderStatusWaitingForPayment),@(kJPOrderStatusWaitingForShipping),@(kJPOrderStatusWaitingForReceival),@(kJPOrderStatusReceived),@(kJPOrderStatusCancelled),@(kJPOrderStatusRefused)];
        
        NSArray *titles = @[@"全部",@"待付款",@"待发货",@"待收货",@"已收货",@"已取消",@"已拒收"];
        
        [cell.optionsButtonsView setValues:values titles:titles];
        @weakify(self)
        @weakify(cell)
        cell.optionsButtonsView.valueChangedBlock = ^(void) {
            @strongify(self)
            @strongify(cell)
            self->_filterDataCopy.status = [NSNumber numberWithInteger:cell.optionsButtonsView.selectedValue];
            
        };
        if (_filterDataCopy.status == nil || [_filterDataCopy.status integerValue] == kJPOrderStatusAll) {
            
            [cell.optionsButtonsView setSelectedValue:kJPOrderStatusAll];
            
        }else {
            
            [cell.optionsButtonsView setSelectedValue:[_filterDataCopy.status integerValue]];
            
        }
        
        return cell;
        
    }else if (indexPath.section == 3){
        if (!sellernameCell) {
            
            sellernameCell = [[MyOrderFilterSellernameCell alloc] init];
            sellernameCell.selectionStyle = UITableViewCellSelectionStyleNone;
            sellernameCell.delegate = self;
            
            [self updateFilterOptionViews];
        }
        
        return sellernameCell;
        
    }else if (indexPath.section == 4){
        
        MyOrderFilterClearCell *cell = [[MyOrderFilterClearCell alloc] init];
        [cell.btnClearAll addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;

    }
    return nil;
    
}
//起始时间选择
-(void)startTimeBtnAction:(UIButton *)btn{

//    UIButton *endBtn = (UIButton *)[self.view viewWithTag:1000];
    [self.view endEditing:YES];
    dateCell.endTimeBtn.selected = NO;
    btn.selected = YES;
    
    NSDate *date = _filterDataCopy.beginTime ?
    [NSDate dateWithTimeIntervalSince1970:[_filterDataCopy.beginTime longLongValue]] : nil;
    
    [JPDatePicker showDate:date eventBlock:^BOOL(JPDatePickerEvent event, NSDate *date) {
        
        if (event == kJPDatePickerConfirmed) {
            
            if (_filterDataCopy.endTime && [date timeIntervalSinceDate:
                                                  [NSDate dateWithTimeIntervalSince1970:[_filterDataCopy.endTime longLongValue]]] > 0) {
                
                [[JLToast makeTextQuick:@"结束时间不能小于开始时间"] show];
                return NO;
            }
            
            NSDate *beginningOfDate = [JPUtils beginningOfDate:date];
            _filterDataCopy.beginTime = @([beginningOfDate timeIntervalSince1970]);
            [self updateFilterOptionViews];
        }
        
        
        if (event != kJPDatePickerValueChanged) {
            btn.selected = NO;
        }
        return YES;
    }];
    
}
//结束时间选择
-(void)endTimeBtnAction:(UIButton *)btn{
    
    [self.view endEditing:YES];
    
    if (_filterDataCopy.beginTime == nil) {
        [[JLToast makeTextQuick:@"请先选择起始时间"] show];
        return;
    }
    
//    da = (UIButton *)[self.view viewWithTag:100];
    dateCell.startTimeBtn.selected = NO;
    btn.selected = YES;
    
    NSDate *date = _filterDataCopy.endTime ?
    [NSDate dateWithTimeIntervalSince1970:[_filterDataCopy.endTime longLongValue]] : nil;
    
    [JPDatePicker showDate:date eventBlock:^BOOL(JPDatePickerEvent event, NSDate *date) {
        
        if (event == kJPDatePickerConfirmed) {
            
            if ([date timeIntervalSinceDate:
                 [NSDate dateWithTimeIntervalSince1970:[_filterDataCopy.beginTime longLongValue]]] < 0) {
                
                [[JLToast makeTextQuick:@"结束时间不能小于开始时间"] show];
                return NO;
            }
            
            NSDate *endingOfDate = [JPUtils endingOfDate:date];
            _filterDataCopy.endTime = @([endingOfDate timeIntervalSince1970]);
            [self updateFilterOptionViews];
        }
        
        
        if (event != kJPDatePickerValueChanged) {
            btn.selected = NO;
        }
        return YES;
    }];
    
}
-(void)updateFilterOptionViews {
    
    
    if (_filterDataCopy.beginTime) {
        NSString *dateStr = [JPUtils dateStringFromStamp:[_filterDataCopy.beginTime longLongValue]];
        [dateCell.startTimeBtn setTitle:dateStr forState:UIControlStateNormal];
        [dateCell.startTimeBtn setTitleColor:[UIColor colorWithWhite:0 alpha:.54] forState:UIControlStateNormal];
    } else {
        [dateCell.startTimeBtn setTitle:@"起始时间" forState:UIControlStateNormal];
        [dateCell.startTimeBtn setTitleColor:[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    }
    
    if (_filterDataCopy.endTime) {
        NSString *dateStr = [JPUtils dateStringFromStamp:[_filterDataCopy.endTime longLongValue] - SECONDS_ALMOST_A_DAY];
        [dateCell.endTimeBtn setTitle:dateStr forState:UIControlStateNormal];
        [dateCell.endTimeBtn setTitleColor:[UIColor colorWithWhite:0 alpha:.54] forState:UIControlStateNormal];
    } else {
        [dateCell.endTimeBtn setTitle:@"结束时间" forState:UIControlStateNormal];
         [dateCell.endTimeBtn setTitleColor:[UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    }
    
    if (_filterDataCopy.minAmount&& [_filterDataCopy.minAmount integerValue]>0) {
        NSString *string = [NSString stringWithFormat:@"%@",_filterDataCopy.minAmount];
        [moneyCell.minAmount setText:string];
    }else{
        [moneyCell.minAmount setText:nil];
    }
    
    if (_filterDataCopy.maxAmount && [_filterDataCopy.maxAmount integerValue]>0) {
        NSString *string = [NSString stringWithFormat:@"%@",_filterDataCopy.maxAmount];
        [moneyCell.maxAmount setText:string];
    }else{
        [moneyCell.maxAmount setText:nil];
    }
    
    if (_filterDataCopy.sellerName&&_filterDataCopy.sellerName.length > 0) {
        
        [sellernameCell.sellerName setText:_filterDataCopy.sellerName];
        
    }else{
        [sellernameCell.sellerName setText:nil];
    }
    
    [self updateStatusOptionsView];
    
}
//清除全部选项
-(void)reset{
    
    _filterDataCopy.beginTime = nil;
    _filterDataCopy.endTime = nil;
    _filterDataCopy.status = nil;
    _filterDataCopy.minAmount = nil;
    _filterDataCopy.maxAmount = nil;
    _filterDataCopy.sellerName = nil;
    
    [self updateFilterOptionViews];
    
}
-(void)updateStatusOptionsView {
    @weakify(self)
    JPOptionButtonsView *optionsButtonsView = (JPOptionButtonsView *)[self.view viewWithTag:999];
    @weakify(optionsButtonsView)
    optionsButtonsView.valueChangedBlock = ^(void) {
        @strongify(self)
        @strongify(optionsButtonsView)
        self->_filterDataCopy.status = [NSNumber numberWithInteger:optionsButtonsView.selectedValue];
        
    };
    if (_filterDataCopy.status == nil || [_filterDataCopy.status integerValue] == kJPOrderStatusAll) {
        
        [optionsButtonsView setSelectedValue:kJPOrderStatusAll];
        
    }else {
        
        [optionsButtonsView setSelectedValue:[_filterDataCopy.status integerValue]];
        
    }

    
}
#pragma mark -
-(BOOL)canReturnWithTextField:(UITextField *)currentTextField {
//    NSInteger tag = currentTextField.tag;
    NSString *text = currentTextField.text;
    
    if (currentTextField == moneyCell.minAmount) {
        
        if (_filterDataCopy.maxAmount
            && [_filterDataCopy.maxAmount integerValue] < [text integerValue]) {
            [[JLToast makeText:@"最大金额不能小于最小金额"] show];
            _filterDataCopy.minAmount = @([text integerValue]);
            
            return NO;
            
        } else {
            if (text.length <= 0) {
                _filterDataCopy.minAmount = nil;
            } else {
                _filterDataCopy.minAmount = @([text integerValue]);
            }
        }
        
    } else if (currentTextField == moneyCell.maxAmount) {
        
        if (_filterDataCopy.minAmount
            && [_filterDataCopy.minAmount integerValue] > [text integerValue]) {
            [[JLToast makeText:@"最大金额不能小于最小金额"] show];
            _filterDataCopy.maxAmount = @([text integerValue]);
            
            return NO;
            
        } else {
            if (text.length <= 0) {
                _filterDataCopy.maxAmount = nil;
            } else {
                _filterDataCopy.maxAmount = @([text integerValue]);
            }
        }
        
    }
    
    return YES;
}


-(void)endwithcurrentTextFied:(UITextField *)currentTextFied {
    _filterDataCopy.sellerName = currentTextFied.text;
    
    [self updateFilterOptionViews];
}

//确定按钮事件
-(void)comfirmAndDismiss{
    if (moneyCell.minAmount.text.length <= 0) {
        _filterDataCopy.minAmount = nil;
    }else{
        _filterDataCopy.minAmount = @([moneyCell.minAmount.text integerValue]);
    }
    if (moneyCell.maxAmount.text.length <= 0) {
        _filterDataCopy.maxAmount = nil;
    }else{
        _filterDataCopy.maxAmount = @([moneyCell.maxAmount.text integerValue]);
    }
    if (sellernameCell.sellerName.text) {
        _filterDataCopy.sellerName = sellernameCell.sellerName.text;
    }
  
    if (_filterDataCopy.endTime == nil && _filterDataCopy.beginTime != nil) {
        [[JLToast makeTextQuick:@"请选择结束时间"] show];
    }else if (_filterDataCopy.maxAmount == nil && _filterDataCopy.minAmount != nil){
        [[JLToast makeText:@"请选择最大金额"] show];
    }else if (_filterDataCopy.minAmount == nil && _filterDataCopy.maxAmount != nil) {
        [[JLToast makeTextQuick:@"请选择最小金额"] show];
    }else if ([_filterDataCopy.maxAmount integerValue] <[_filterDataCopy.minAmount integerValue]) {
        [[JLToast makeText:@"最大金额不能小于最小金额"] show];
    }else {
        
        if ([_filterData conditionChanged:_filterDataCopy]) {
            
            _filterData.beginTime = _filterDataCopy.beginTime;
            _filterData.endTime = _filterDataCopy.endTime;
            _filterData.status = _filterDataCopy.status;
            _filterData.sellerName = _filterDataCopy.sellerName;
            _filterData.minAmount = _filterDataCopy.minAmount;
            _filterData.maxAmount = _filterDataCopy.maxAmount;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:JP_NOTIFICATION_INQUIRY_FILTER_CHANGED object:_filterData];
        }
        
        if ([self.view.window.rootViewController isKindOfClass:[JPSidePopVC class]]) {
            [((JPSidePopVC *)self.view.window.rootViewController) dismiss];
        }
    }

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
