//
//  UNPInquiriesFilterVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPInquiriesFilterVC.h"
#import "JPDesignSpec.h"
#import "JPCheckButton.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "JPUtils.h"
#import "JPSubmitButton.h"
#import <Masonry/Masonry.h>
#import "JPSidePopVC.h"
#import "JPDatePicker.h"
#import <UnipeiApp-Swift.h>
#import "JPOptionButtonsView.h"

@interface UNPInquiriesFilterVC () <UITextFieldDelegate> {
    NSArray                 *_typeButtons;
    UIButton                *_selectedTypeButton;
    
//    NSArray                 *_statusButtons;
//    UIButton                *_selectedStatusButton;
    
    UIView                  *_footerView;
    
    InquiryApi_InquiryList  *_filterDataCopy;
}

/// cells
@property (weak, nonatomic) IBOutlet UITableViewCell *typeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *timeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *statusCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *clearCell;


/// views in cells
@property (weak, nonatomic) IBOutlet UIButton *btnStartTime;
@property (weak, nonatomic) IBOutlet UIButton *btnEndTime;
@property (weak, nonatomic) IBOutlet UIButton *btnTypeInqire;
@property (weak, nonatomic) IBOutlet UIButton *btnTypeOffer;

@property (weak, nonatomic) IBOutlet JPOptionButtonsView *optionsButtonsView;

@property (weak, nonatomic) IBOutlet JPSubmitButton *btnClearAll;


@end

@implementation UNPInquiriesFilterVC

+(instancetype)newFromStoryboard {
    return [[DymStoryboard unipeiInquiry_Storyboard] instantiateViewControllerWithIdentifier:@"UNPInquiriesFilterVC"];
}

-(void)setOptionViewMoreOrLess:(BOOL)more {
    @weakify(self)
    NSArray *values, *titles;
    
    if (more) {
        values = @[@(kJPInquiryStatusAll)
                            , @(kJPInquiryStatusWaitingQuatation)
                            , @(kJPInquiryStatusWaitingConfirmation)
                            , @(kJPInquiryStatusConformed)
                            , @(kJPInquiryStatusCancelled)
                            , @(kJPInquiryStatusRefused)
                            , @(kJPInquiryStatusInvalidated)];
        titles = @[@"全部", @"待报价", @"已报价待确认", @"已确认", @"已撤消", @"已拒绝", @"已失效"];
    } else {
        values = @[@(kJPInquiryStatusAll)
                   , @(kJPInquiryStatusWaitingConfirmation)
                   , @(kJPInquiryStatusConformed)
                   , @(kJPInquiryStatusRefused)
                   , @(kJPInquiryStatusInvalidated)];
        titles = @[@"全部", @"已报价待确认", @"已确认", @"已拒绝", @"已失效"];
    }
    
    [_optionsButtonsView setValues:values titles:titles];
    _optionsButtonsView.valueChangedBlock = ^(void) {
        @strongify(self)
        self->_filterDataCopy.status = @(self->_optionsButtonsView.selectedValue);
    };
}

- (void)viewDidLoad {
    @weakify(self)
    
    [super viewDidLoad];
    self.navigationItem.title = @"筛选";
    
    _filterDataCopy = [_filterData copy];
    
    _btnClearAll.style = kJPButtonWhite;
    _btnClearAll.layer.cornerRadius = 2;
    _btnClearAll.clipsToBounds = YES;
    
   
    _typeButtons = @[_btnTypeInqire, _btnTypeOffer];
    [_typeButtons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        [[obj rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            [self selectTypeButton:obj];
        }];
    }];
    
    
    /// 询价单状态选择视图
    
    
    
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
    
    
    
    [_btnStartTime setTitleColor:[JPDesignSpec colorMinor] forState:UIControlStateSelected];
    [_btnEndTime setTitleColor:[JPDesignSpec colorMinor] forState:UIControlStateSelected];
    
    /// 开始日期选择
    [[_btnStartTime rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *theButton) {
        
        @strongify(self)
        self->_btnEndTime.selected = NO;
        theButton.selected = YES;
        
        @weakify(self)
        NSDate *date = _filterDataCopy.startSearchTime ?
        [NSDate dateWithTimeIntervalSince1970:[_filterDataCopy.startSearchTime longLongValue]] : nil;
        
        [JPDatePicker showDate:date eventBlock:^BOOL(JPDatePickerEvent event, NSDate *date) {
            @strongify(self)
            
            if (event == kJPDatePickerConfirmed) {
                
                if (_filterDataCopy.endSearchTime && [date timeIntervalSinceDate:
                     [NSDate dateWithTimeIntervalSince1970:[_filterDataCopy.endSearchTime longLongValue]]] > 0) {
                    
                    [[JLToast makeTextQuick:@"结束时间不能小于开始时间"] show];
                    return NO;
                }
                
                NSDate *beginningOfDate = [JPUtils beginningOfDate:date];
                self->_filterDataCopy.startSearchTime = @([beginningOfDate timeIntervalSince1970]);
                [self updateFilterOptionViews];
            }
            
            
            if (event != kJPDatePickerValueChanged) {
                theButton.selected = NO;
            }
            return YES;
        }];
        
    }];
    
    /// 结束日期选择
    [[_btnEndTime rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *theButton) {
        
        @strongify(self)
        if (self->_filterDataCopy.startSearchTime == nil) {
            [[JLToast makeTextQuick:@"请先选择起始时间"] show];
            return;
        }
        
        self->_btnStartTime.selected = NO;
        theButton.selected = YES;
        
        @weakify(self)
        NSDate *date = _filterDataCopy.endSearchTime ?
        [NSDate dateWithTimeIntervalSince1970:[_filterDataCopy.endSearchTime longLongValue]] : nil;
        
        [JPDatePicker showDate:date eventBlock:^BOOL(JPDatePickerEvent event, NSDate *date) {
            @strongify(self)
            
            if (event == kJPDatePickerConfirmed) {
                
                if ([date timeIntervalSinceDate:
                     [NSDate dateWithTimeIntervalSince1970:[_filterDataCopy.startSearchTime longLongValue]]] < 0) {
                    
                    [[JLToast makeTextQuick:@"结束时间不能小于开始时间"] show];
                    return NO;
                }
                
                NSDate *endingOfDate = [JPUtils endingOfDate:date];
                self->_filterDataCopy.endSearchTime = @([endingOfDate timeIntervalSince1970]);
                [self updateFilterOptionViews];
            }
            
            
            if (event != kJPDatePickerValueChanged) {
                theButton.selected = NO;
            }
            return YES;
        }];
        
    }];
    
    
    /// 清除全部选项
    [[_btnClearAll rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self reset];
    }];
    
    
    ///
    [self updateFilterOptionViews];
}

#pragma mark - text field delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    _filterDataCopy.inquirysn = textField.text;
    return YES;
}

-(void)reset {
    _filterDataCopy.startSearchTime = nil;
    _filterDataCopy.endSearchTime = nil;
    _filterDataCopy.status = nil;
    _filterDataCopy.inquirysn = nil;
    _filterDataCopy.listType = @(kJPInquiryTypeAll);
    
    [self updateFilterOptionViews];
}

-(void)updateFilterOptionViews {
    
    if (_filterDataCopy.startSearchTime) {
        NSString *dateStr = [JPUtils dateStringFromStamp:[_filterDataCopy.startSearchTime longLongValue]];
        [_btnStartTime setTitle:dateStr forState:UIControlStateNormal];
    } else {
        [_btnStartTime setTitle:@"起始时间" forState:UIControlStateNormal];
    }
    
    if (_filterDataCopy.endSearchTime) {
        NSString *dateStr = [JPUtils dateStringFromStamp:[_filterDataCopy.endSearchTime longLongValue] - SECONDS_ALMOST_A_DAY];
        [_btnEndTime setTitle:dateStr forState:UIControlStateNormal];
    } else {
        [_btnEndTime setTitle:@"结束时间" forState:UIControlStateNormal];
    }
    

    
    NSInteger listType = [_filterDataCopy.listType integerValue];
    if (listType == kJPInquiryTypeAll) {
        [self selectTypeButton:nil revertable:NO];
    } else if (listType == kJPInquiryTypeInquiry) {
        [self selectTypeButton:_btnTypeInqire revertable:NO];
    } else if (listType == kJPInquiryTypeNoInquiry) {
        [self selectTypeButton:_btnTypeOffer revertable:NO];
    }
    
    ///
    [self updateStatusOptionsView];
}


-(void)updateStatusOptionsView {
        
    NSInteger listType = [_filterDataCopy.listType integerValue];
    [self setOptionViewMoreOrLess:(listType != kJPInquiryTypeNoInquiry)];
    
    if (_filterDataCopy.status == nil || [_filterDataCopy.status integerValue] == kJPInquiryStatusAll) {
        
        [_optionsButtonsView setSelectedValue:kJPInquiryStatusAll];
        
    } else if (listType == kJPInquiryTypeNoInquiry
               && ([_filterDataCopy.status integerValue] == kJPInquiryStatusWaitingQuatation
                   || [_filterDataCopy.status integerValue] == kJPInquiryStatusCancelled)) {
                   
                   [_optionsButtonsView setSelectedValue:kJPInquiryStatusAll];
                   
               } else {
                   
                   [_optionsButtonsView setSelectedValue:[_filterDataCopy.status integerValue]];
                   
               }
}

-(void)selectTypeButton:(UIButton *)obj {
    [self selectTypeButton:obj revertable:YES];
}

-(void)selectTypeButton:(UIButton *)obj revertable:(BOOL)revertable {
    
    [_typeButtons enumerateObjectsUsingBlock:^(UIButton *innnerObj, NSUInteger idx, BOOL *stop) {
        if (innnerObj != obj) {
            innnerObj.selected = NO;
        }
    }];
    
    obj.selected = revertable ? !obj.selected : YES;
    
    _selectedTypeButton = obj.selected ? obj : nil;
    
    if (_selectedTypeButton == nil) {
        _filterDataCopy.listType = @(kJPInquiryTypeAll);
    } else if (_selectedTypeButton == _btnTypeInqire) {
        _filterDataCopy.listType = @(kJPInquiryTypeInquiry);
    } else if (_selectedTypeButton == _btnTypeOffer) {
        _filterDataCopy.listType = @(kJPInquiryTypeNoInquiry);
    }
    
    [self updateStatusOptionsView];
}

-(void)comfirmAndDismiss {
    
    if (_filterDataCopy.endSearchTime == nil && _filterDataCopy.startSearchTime != nil) {
        [[JLToast makeTextQuick:@"请选择结束时间"] show];
    } else {
        
        if ([_filterData conditionChanged:_filterDataCopy]) {
            
            _filterData.startSearchTime = _filterDataCopy.startSearchTime;
            _filterData.endSearchTime = _filterDataCopy.endSearchTime;
            _filterData.status = _filterDataCopy.status;
            _filterData.listType = _filterDataCopy.listType;
//            _filterData.inquirysn = _filterDataCopy.inquirysn;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:JP_NOTIFICATION_INQUIRY_FILTER_CHANGED object:_filterData];
        }
        
        if ([self.view.window.rootViewController isKindOfClass:[JPSidePopVC class]]) {
            [((JPSidePopVC *)self.view.window.rootViewController) dismiss];
        }
    }
}

#pragma mark - table view 
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return _typeCell;
    } else if (indexPath.row == 1) {
        return _timeCell;
    } else if (indexPath.row == 2) {
        return _statusCell;
    } else if (indexPath.row == 3) {
        return _clearCell;
    }
    
    return [UITableViewCell new];
}

@end
