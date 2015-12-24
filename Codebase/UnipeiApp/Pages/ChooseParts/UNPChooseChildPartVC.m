//
//  UNPChooseChildPartVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPChooseChildPartVC.h"
#import "UNPChooseItemsView.h"
#import "UNPChooseItemCell.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "JPDesignSpec.h"
#import <UnipeiApp-Swift.h>
#import "UNPChooseGrandChildPartVC.h"
#import "NSDictionary+Dym.h"


@interface UNPChooseChildPartVC ()

@end

@implementation UNPChooseChildPartVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.rootView hideBottomBar];
    [self.rootView showTopView:YES];
    
    self.navigationItem.title = _viewModel.subVM.title;
    
    id root = _viewModel.rootVM.selectedItem;
    self.rootView.lblHeader.text = [root objectForKey:@"name"];
    
    BOOL isDirty = [[_viewModel.subVM.parentItem objectForKey:@"id"] longLongValue] != [[root objectForKey:@"id"] longLongValue];
    _viewModel.subVM.parentItem = root;
    
    if (isDirty || _viewModel.subVM.items.firstObject == nil) {
        [_viewModel.subVM reset];
        @weakify(self)
        [self.loadingView show:YES];
        [_viewModel getSubs:^(InquiryApi_FindGcategoryChild_Result *result) {
            @strongify(self)
            [self.loadingView show:NO];
            [self.rootView.tableView reloadData];
        } queue:self.apiQueue];
    }
}


#pragma mark - table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _viewModel.allSubsDictionary.allKeys.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionTitle = _viewModel.allSubsDictionary.sortedStringKeys[section];
    NSArray *items = _viewModel.allSubsDictionary[sectionTitle];
    return items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UNPChooseItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UNPChooseItemCell" forIndexPath:indexPath];
    
    NSString *sectionTitle = _viewModel.allSubsDictionary.sortedStringKeys[indexPath.section];
    NSArray *items = _viewModel.allSubsDictionary[sectionTitle];
    id sub = items[indexPath.row];
    cell.lblTitle.text = [sub objectForKey:@"name"];
    
    BOOL selected = _viewModel.subVM.selectedItem == sub;
    
    cell.lblTitle.textColor = selected ? [JPDesignSpec colorMajor] : [UIColor colorWithWhite:0 alpha:0.87];
    cell.ivCheck.hidden = !selected;
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _viewModel.allSubsDictionary.sortedStringKeys[section];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _viewModel.sectionTitles;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [_viewModel.allSubsDictionary.sortedStringKeys indexOfObject:title];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *sectionTitle = _viewModel.allSubsDictionary.sortedStringKeys[indexPath.section];
    NSArray *items = _viewModel.allSubsDictionary[sectionTitle];
    id sub = items[indexPath.row];
    
    [_viewModel.subVM selectItem:sub];
    
    [tableView reloadData];
    
    
    @weakify(self);
    [self.lazyBlock excuteBlock:^{
        @strongify(self)
        UNPChooseGrandChildPartVC *vc = [UNPChooseGrandChildPartVC new];
        vc.viewModel = _viewModel;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}


@end
