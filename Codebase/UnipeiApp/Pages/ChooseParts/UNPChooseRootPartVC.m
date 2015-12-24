//
//  UNPChooseRootPartVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPChooseRootPartVC.h"
#import "UNPChooseItemsView.h"
#import "UNPChooseItemCell.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "JPDesignSpec.h"
#import <UnipeiApp-Swift.h>
#import "UNPChooseChildPartVC.h"
#import "NSDictionary+Dym.h"

@interface UNPChooseRootPartVC ()

@end

@implementation UNPChooseRootPartVC

- (void)viewDidLoad {
    
    @weakify(self)
    
    [super viewDidLoad];
    
    [self.rootView hideBottomBar];
    
    // Install cancel button to dismiss the pop view
    UIBarButtonItem *fixedGap = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedGap.width = 16;
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil];
    leftBarButton.tintColor = [UIColor colorWithWhite:0 alpha:0.54];
    self.navigationItem.leftBarButtonItems = @[fixedGap, leftBarButton];
    leftBarButton.rac_command = [self dismissPopViewCommand];
    
   
    self.navigationItem.title = _viewModel.rootVM.title;
    
    if (_viewModel.rootVM.items.count <= 0) {

        [self.loadingView show:YES];
        [_viewModel getRoots:^(InquiryApi_FindGcategory_Result *result) {
            @strongify(self)
            [self.loadingView show:NO];
            [self.rootView.tableView reloadData];
        } queue:self.apiQueue];
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController.view layoutIfNeeded];
}


#pragma mark - table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _viewModel.allRootsDictionary.allKeys.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionTitle = _viewModel.allRootsDictionary.sortedStringKeys[section];
    NSArray *items = _viewModel.allRootsDictionary[sectionTitle];
    return items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UNPChooseItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UNPChooseItemCell" forIndexPath:indexPath];
    
    NSString *sectionTitle = _viewModel.allRootsDictionary.sortedStringKeys[indexPath.section];
    NSArray *items = _viewModel.allRootsDictionary[sectionTitle];
    id item = items[indexPath.row];
    cell.lblTitle.text = [item objectForKey:@"name"];
    
    BOOL selected = _viewModel.rootVM.selectedItem == item;
    
    cell.lblTitle.textColor = selected ? [JPDesignSpec colorMajor] : [UIColor colorWithWhite:0 alpha:0.87];
    cell.ivCheck.hidden = !selected;
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return _viewModel.allRootsDictionary.sortedStringKeys[section];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _viewModel.sectionTitles;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [_viewModel.allRootsDictionary.sortedStringKeys indexOfObject:title];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *sectionTitle = _viewModel.allRootsDictionary.sortedStringKeys[indexPath.section];
    NSArray *items = _viewModel.allRootsDictionary[sectionTitle];
    id item = items[indexPath.row];
    
    [_viewModel.rootVM selectItem:item];
    
    [tableView reloadData];
    
    
    @weakify(self);
    [self.lazyBlock excuteBlock:^{
        @strongify(self)
        UNPChooseChildPartVC *vc = [UNPChooseChildPartVC new];
        vc.viewModel = _viewModel;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
