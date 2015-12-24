//
//  UNPChooseSeriesVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPChooseSeriesVC.h"
#import "UNPChooseItemsView.h"
#import "UNPChooseItemCell.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "JPDesignSpec.h"
#import <UnipeiApp-Swift.h>
#import "UNPChooseYearVC.h"

//static const DDLogLevel ddLogLevel = DDLogLevelDebug;


@interface UNPChooseSeriesVC ()

@end


@implementation UNPChooseSeriesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _viewModel.seriesVM.title;
    
    [self.rootView hideBottomBar];
    
    
    /// request data if needed
    JPCarMake *brand = _viewModel.brandVM.selectedItem;
    BOOL isDirty = ([((JPCarMake *)_viewModel.seriesVM.parentItem).makeid longLongValue] != [brand.makeid longLongValue]);
    _viewModel.seriesVM.parentItem = brand;
    
    JPCarSeries *firstSeries = _viewModel.seriesVM.items.firstObject;
    
    if (firstSeries == nil || isDirty) {
        [_viewModel.seriesVM resetItemsAndSelectedItems];
        
        // request series data
        @weakify(self)
        [self.loadingView show:YES];
        [_viewModel getSeries:^(ModelPictureApi_FindSeriesList_Result *result) {
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
    
    return _viewModel.seriesVM.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UNPChooseItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UNPChooseItemCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
//        JPCarMake *brand = _viewModel.seriesVM.parentItem;
//        cell.lblTitle.text = brand.mName;
        cell.lblTitle.text = [_viewModel fullNameWithLevel:kJPCarModelNameLevelBrand];
        cell.lblTitle.textColor = [JPDesignSpec colorMajor];
        cell.ivCheck.hidden = YES;
        return cell;
    }
    
    
    JPCarSeries *series = _viewModel.seriesVM.items[indexPath.row];
    cell.lblTitle.text = series.name;
    
    JPCarSeries *selectedSeries = [_viewModel.seriesVM selectedItem];
    
    BOOL selected = (selectedSeries && [series.seriesid longLongValue] == [selectedSeries.seriesid longLongValue]);
    
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
    
    JPCarSeries *series = _viewModel.seriesVM.items[indexPath.row];
    
    [_viewModel.seriesVM selectItem:series];
    
    [tableView reloadData];
    
    
    @weakify(self);
    [self.lazyBlock excuteBlock:^{
        @strongify(self)
        if ([series.seriesid integerValue] <= 0) {
            
            [self.viewModel.yearVM reset];
//            [self.viewModel.yearVM selectFirstItem];
            
            [self.viewModel.modelVM reset];
//            [self.viewModel.modelVM selectFirstItem];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_String_carModelSelected object:self.viewModel];
            [self dismissPopView];
            
        } else {
            
            if (self.viewModel.seriesVM.selectedItem != nil) {
                
                UNPChooseYearVC *vc = [UNPChooseYearVC new];
                vc.viewModel = self.viewModel;
                [self.navigationController pushViewController:vc animated:YES];
                
            } else {
                [[JLToast makeText:@"请先选择车系"] show];
            }
        }
    }];
    
    
}

@end
