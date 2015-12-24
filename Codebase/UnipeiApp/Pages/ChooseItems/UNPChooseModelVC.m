//
//  UNPChooseModelVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPChooseModelVC.h"
#import "UNPChooseItemsView.h"
#import "UNPChooseItemCell.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "JPDesignSpec.h"
#import <UnipeiApp-Swift.h>

//static const DDLogLevel ddLogLevel = DDLogLevelDebug;

@interface UNPChooseModelVC ()

@end

@implementation UNPChooseModelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _viewModel.modelVM.title;
    
    [self.rootView hideBottomBar];
    
    /// request data if needed
    id yearObj = _viewModel.yearVM.selectedItem;
    id year = [yearObj objectForKey:@"year"];
    id seriesID = [yearObj objectForKey:@"id"];

    id originalParentItem = _viewModel.modelVM.parentItem;
    BOOL differentYear = ([[originalParentItem objectForKey:@"year"] longLongValue] != [year longLongValue]);
    BOOL differentSeries = ([[originalParentItem objectForKey:@"id"] longLongValue] != [seriesID longLongValue]);
    
    _viewModel.modelVM.parentItem = yearObj;
    
    if (_viewModel.modelVM.items.firstObject == nil || differentYear || differentSeries) {
        [_viewModel.modelVM resetItemsAndSelectedItems];
        
        // request data
        @weakify(self)
        [self.loadingView show:YES];
        [_viewModel getModels:^(ModelPictureApi_FindModelList_Result *result) {
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
    
    return _viewModel.modelVM.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UNPChooseItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UNPChooseItemCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
//        NSNumber *year = [_viewModel.modelVM.parentItem objectForKey:@"year"];
//        cell.lblTitle.text = [NSString stringWithFormat:@"%@款", year];
        cell.lblTitle.text = [_viewModel fullNameWithLevel:kJPCarModelNameLevelYear];
        cell.lblTitle.textColor = [JPDesignSpec colorMajor];
        cell.ivCheck.hidden = YES;
        return cell;
    }
    
    
    JPCarModel *model = _viewModel.modelVM.items[indexPath.row];
    cell.lblTitle.text = model.name;
    
    JPCarModel *selectedItem = [_viewModel.modelVM selectedItem];
    BOOL selected = (selectedItem && [model.modelid longLongValue] == [selectedItem.modelid longLongValue]);
    
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
    
    JPCarModel *model = _viewModel.modelVM.items[indexPath.row];
    
    [_viewModel.modelVM selectItem:model];
    
    [tableView reloadData];
    
    @weakify(self);
    [self.lazyBlock excuteBlock:^{
        @strongify(self)
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_String_carModelSelected object:_viewModel];
        [self dismissPopView];
    }];

}



@end
