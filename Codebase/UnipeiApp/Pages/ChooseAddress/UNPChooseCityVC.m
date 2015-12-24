//
//  UNPChooseCityVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/15.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPChooseCityVC.h"
#import "UNPChooseItemsView.h"
#import "UNPChooseItemCell.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "JPDesignSpec.h"
#import <UnipeiApp-Swift.h>
#import "UNPChooseDistrictVC.h"

@interface UNPChooseCityVC ()

@end

@implementation UNPChooseCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.rootView hideBottomBar];
    
    self.navigationItem.title = _viewModel.cityVM.title;
    
    id root = _viewModel.provinceVM.selectedItem;
    BOOL isDirty = [[_viewModel.cityVM.parentItem objectForKey:@"id"] longLongValue] != [[root objectForKey:@"id"] longLongValue];
    _viewModel.cityVM.parentItem = root;
    
    if (isDirty || _viewModel.cityVM.items.firstObject == nil) {
        [_viewModel.cityVM reset];
        @weakify(self)
        [self.loadingView show:YES];
        [_viewModel getCities:^(InquiryApi_FindCity_Result *result) {
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
    
    return _viewModel.cityVM.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UNPChooseItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UNPChooseItemCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        id root = _viewModel.cityVM.parentItem;
        cell.lblTitle.text = [root objectForKey:@"name"];
        cell.lblTitle.textColor = [JPDesignSpec colorMajor];
        cell.ivCheck.hidden = YES;
        return cell;
    }
    
    
    id sub = _viewModel.cityVM.items[indexPath.row];
    cell.lblTitle.text = [sub objectForKey:@"name"];
    
    BOOL selected = _viewModel.cityVM.selectedItem == sub;
    
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
    
    id sub = _viewModel.cityVM.items[indexPath.row];
    
    [_viewModel.cityVM selectItem:sub];
    
    [tableView reloadData];
    
    
    @weakify(self);
    [self.lazyBlock excuteBlock:^{
        @strongify(self)
        UNPChooseDistrictVC *vc = [UNPChooseDistrictVC new];
        vc.viewModel = _viewModel;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
