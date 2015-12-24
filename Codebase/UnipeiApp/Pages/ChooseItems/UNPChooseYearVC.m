//
//  UNPChooseYearVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPChooseYearVC.h"
#import "UNPChooseItemsView.h"
#import "UNPChooseItemCell.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "JPDesignSpec.h"
#import <UnipeiApp-Swift.h>
#import "UNPChooseModelVC.h"

//static const DDLogLevel ddLogLevel = DDLogLevelDebug;

@interface UNPChooseYearVC ()

@end

@implementation UNPChooseYearVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _viewModel.yearVM.title;
    
    [self.rootView hideBottomBar];
    
    /// request data if needed
    JPCarSeries *series = _viewModel.seriesVM.selectedItem;
    BOOL isDirty = ([((JPCarSeries *)_viewModel.yearVM.parentItem).seriesid longLongValue] != [series.seriesid longLongValue]);
    _viewModel.yearVM.parentItem = series;
    
    if (_viewModel.yearVM.items.firstObject == nil || isDirty) {
        [_viewModel.yearVM resetItemsAndSelectedItems];
        
        // request data
        @weakify(self)
        [self.loadingView show:YES];
        [_viewModel getYears:^(ModelPictureApi_FindYearList_Result *result) {
            @strongify(self)
            [self.loadingView show:NO];
            [self.rootView.tableView reloadData];
        } queue:self.apiQueue];
    }
}

#pragma mark - table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    return _viewModel.yearVM.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UNPChooseItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UNPChooseItemCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
//        JPCarSeries *series = _viewModel.yearVM.parentItem;
//        cell.lblTitle.text = series.name;
        cell.lblTitle.text = [_viewModel fullNameWithLevel:kJPCarModelNameLevelSeries];
        cell.lblTitle.textColor = [JPDesignSpec colorMajor];
        cell.ivCheck.hidden = YES;
        return cell;
    }
    
    
    id year = _viewModel.yearVM.items[indexPath.row];
    if ([year[@"year"] integerValue] > 0) {
        cell.lblTitle.text = [NSString stringWithFormat:@"%@款", year[@"year"]];
    } else {
        cell.lblTitle.text = @"不确定年款";
    }
    
    
    id selectedYear = [_viewModel.yearVM selectedItem];
    
    BOOL selected = (selectedYear && [year[@"year"] longLongValue] == [selectedYear[@"year"] longLongValue]);
    
    cell.lblTitle.textColor = selected ? [JPDesignSpec colorMajor] : [UIColor colorWithWhite:0 alpha:0.87];
    cell.ivCheck.hidden = !selected;
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 8;
    }
    
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id year = _viewModel.yearVM.items[indexPath.row];
    
    [_viewModel.yearVM selectItem:year];
    
    [tableView reloadData];
    
    
    @weakify(self);
    [self.lazyBlock excuteBlock:^{
        @strongify(self)
        if ([year[@"year"] integerValue] <= 0) {
            
            [self.viewModel.modelVM reset];
//            [self.viewModel.modelVM selectFirstItem];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_String_carModelSelected object:self.viewModel];
            [self dismissPopView];
            
        } else {
            
            if (self.viewModel.yearVM.selectedItem != nil) {
                
                UNPChooseModelVC *vc = [UNPChooseModelVC new];
                vc.viewModel = self.viewModel;
                [self.navigationController pushViewController:vc animated:YES];
                
            } else {
                [[JLToast makeText:@"请先选择年款"] show];
            }
        }
    }];
}

@end
