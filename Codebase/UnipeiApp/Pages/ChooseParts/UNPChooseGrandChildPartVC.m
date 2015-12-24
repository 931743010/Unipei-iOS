//
//  UNPChooseGrandChildPartVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPChooseGrandChildPartVC.h"
#import "UNPChooseItemsView.h"
#import "UNPChooseItemCell.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "JPDesignSpec.h"
#import <UnipeiApp-Swift.h>
#import "NSDictionary+Dym.h"

@interface UNPChooseGrandChildPartVC ()

@end

@implementation UNPChooseGrandChildPartVC

- (void)viewDidLoad {
    @weakify(self)
    [super viewDidLoad];
    
//    [self.rootView.bottomBar showSecondButton:NO];
    [self.rootView hideBottomBar];
    [self.rootView showTopView:YES];
    
//    [[self.rootView.bottomBar.btnFirst rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        
//        if (_viewModel.partsVM.selectedItem != nil) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_String_carPartsSelected object:_viewModel];
//            @strongify(self)
//            [self dismissPopView];
//        } else {
//            [[JLToast makeText:@"请先选择标准名称"] show];
//        }
//        
//    }];
    
    self.navigationItem.title = _viewModel.partsVM.title;
    
    id parentItem = _viewModel.subVM.selectedItem;
    self.rootView.lblHeader.text = [parentItem objectForKey:@"name"];
    
    BOOL isDirty = [[_viewModel.partsVM.parentItem objectForKey:@"id"] longLongValue] != [[parentItem objectForKey:@"id"] longLongValue];
    _viewModel.partsVM.parentItem = parentItem;
    
    if (isDirty || _viewModel.partsVM.items.firstObject == nil) {
        [_viewModel.partsVM reset];
        
        [self.loadingView show:YES];
        [_viewModel getParts:^(InquiryApi_FindGcategoryGrandchild_Result *result) {
            @strongify(self)
            [self.loadingView show:NO];
            [self.rootView.tableView reloadData];
        } queue:self.apiQueue];
    }
}

#pragma mark - table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _viewModel.allPartsDictionary.allKeys.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionTitle = _viewModel.allPartsDictionary.sortedStringKeys[section];
    NSArray *items = _viewModel.allPartsDictionary[sectionTitle];
    return items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UNPChooseItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UNPChooseItemCell" forIndexPath:indexPath];
    
    NSString *sectionTitle = _viewModel.allPartsDictionary.sortedStringKeys[indexPath.section];
    NSArray *items = _viewModel.allPartsDictionary[sectionTitle];
    id sub = items[indexPath.row];
    cell.lblTitle.text = [sub objectForKey:@"name"];
    
    BOOL selected = _viewModel.partsVM.selectedItem == sub;
    
    cell.lblTitle.textColor = selected ? [JPDesignSpec colorMajor] : [UIColor colorWithWhite:0 alpha:0.87];
    cell.ivCheck.hidden = !selected;
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _viewModel.allPartsDictionary.sortedStringKeys[section];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _viewModel.sectionTitles;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [_viewModel.allPartsDictionary.sortedStringKeys indexOfObject:title];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *sectionTitle = _viewModel.allPartsDictionary.sortedStringKeys[indexPath.section];
    NSArray *items = _viewModel.allPartsDictionary[sectionTitle];
    id sub = items[indexPath.row];
    
    [_viewModel.partsVM selectItem:sub];
    
    [tableView reloadData];
    
    @weakify(self);
    [self.lazyBlock excuteBlock:^{
        @strongify(self)
        if (self.viewModel.partsVM.selectedItem != nil) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_String_carPartsSelected object:_viewModel];
            [self dismissPopView];
        } else {
            [[JLToast makeText:@"请先选择标准名称"] show];
        }
    }];
}

@end
