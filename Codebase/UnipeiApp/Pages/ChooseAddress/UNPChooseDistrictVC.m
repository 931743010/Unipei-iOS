//
//  UNPChooseAreaVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/15.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPChooseDistrictVC.h"
#import "UNPChooseItemsView.h"
#import "UNPChooseItemCell.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "JPDesignSpec.h"
#import <UnipeiApp-Swift.h>


@interface UNPChooseDistrictVC ()

@end

@implementation UNPChooseDistrictVC

- (void)viewDidLoad {
    @weakify(self)
    [super viewDidLoad];
    
    [self.rootView hideBottomBar];
    
    self.navigationItem.title = _viewModel.districtVM.title;
    
    id parentItem = _viewModel.cityVM.selectedItem;
    BOOL isDirty = [[_viewModel.districtVM.parentItem objectForKey:@"id"] longLongValue] != [[parentItem objectForKey:@"id"] longLongValue];
    _viewModel.districtVM.parentItem = parentItem;
    
    if (isDirty || _viewModel.districtVM.items.firstObject == nil) {
        [_viewModel.districtVM reset];
        
        [self.loadingView show:YES];
        [_viewModel getDistricts:^(InquiryApi_FindDistrict_Result *result) {
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
    
    return _viewModel.districtVM.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UNPChooseItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UNPChooseItemCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        id parentItem = _viewModel.districtVM.parentItem;
        cell.lblTitle.text = [parentItem objectForKey:@"name"];
        cell.lblTitle.textColor = [JPDesignSpec colorMajor];
        cell.ivCheck.hidden = YES;
        return cell;
    }
    
    
    id sub = _viewModel.districtVM.items[indexPath.row];
    cell.lblTitle.text = [sub objectForKey:@"name"];
    
    BOOL selected = _viewModel.districtVM.selectedItem == sub;
    
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
    if (_viewModel.districtVM.items.count>0) {
        id sub = _viewModel.districtVM.items[indexPath.row];
        
        [_viewModel.districtVM selectItem:sub];
        
        [tableView reloadData];
    }
    @weakify(self);
    [self.lazyBlock excuteBlock:^{
        @strongify(self)
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_String_addressSelected object:_viewModel];
        [self dismissPopView];
    }];
}


@end
