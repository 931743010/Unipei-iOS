//
//  DymBaseTableVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/25.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseTableVC.h"
#import <Masonry/Masonry.h>

@interface DymBaseTableVC () <UITextFieldDelegate>

@end



@implementation DymBaseTableVC

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return [self __textFieldShouldReturn:textField];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self __doInit];
}

-(void)dealloc {
    [self __doDealloc];
}

#pragma mark - orientations
- (BOOL)shouldAutorotate
{
    return [self _shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self _supportedInterfaceOrientations];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return [self __preferredStatusBarStyle];
}

@end



@implementation DymBaseLoadingTableVC

-(void)viewDidLoad {
    [super viewDidLoad];
    
    _emptyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _emptyCell.backgroundColor = [UIColor clearColor];
    _emptyCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [_emptyCell.contentView addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_emptyCell.contentView);
    }];
    
    
    _loadingCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    _loadingCell.backgroundColor = [UIColor clearColor];
    _loadingCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [_loadingCell.contentView addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_loadingCell.contentView);
    }];
}


#pragma mark - table view

-(BOOL)showEmptyCellIfNeeded {
    return YES;
}

-(BOOL)showLoadingCellIfNeeded {
    return YES;
}

/// 是否无数据显示，子类重写
-(BOOL)isDataSourceEmpty {
    return NO;
}

-(BOOL)allowBounceWhenDataSourceIsEmpty {
    return NO;
}

-(void)setDataSourceIsLoading:(BOOL)dataSourceIsLoading {
    _dataSourceIsLoading = dataSourceIsLoading;
    
    [self.tableView reloadData];
}

-(BOOL)shouldShowEmptyCell {
    return [self showEmptyCellIfNeeded] && [self isDataSourceEmpty];
}

-(BOOL)shouldShowLoadingCell {
    return [self showLoadingCellIfNeeded] && [self dataSourceIsLoading];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self shouldShowEmptyCell] || [self shouldShowLoadingCell]) {
        return 1;
    }
    
    return [self numberOfSectionsInTableView_IfDataOK:tableView];
}

-(NSInteger)numberOfSectionsInTableView_IfDataOK:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self shouldShowEmptyCell] || [self shouldShowLoadingCell]) {
        return 1;
    }
    
    return [self tableView:tableView numberOfRowsInSection_IfDataOK:section];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection_IfDataOK:(NSInteger)section {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([self shouldShowEmptyCell] || [self shouldShowLoadingCell]) {
        return 0.1;
    }
    
    return [self tableView:tableView heightForHeaderInSection_IfDataOK:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection_IfDataOK:(NSInteger)section {
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self shouldShowEmptyCell] || [self shouldShowLoadingCell]) {
        return tableView.frame.size.height;
    }
    
    return [self tableView:tableView heightForRowAtIndexPath_IfDataOK:indexPath];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath_IfDataOK:(NSIndexPath *)indexPath {
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.loadingView show:NO];
    [self.emptyView show:NO withText:nil];
    self.tableView.bounces = YES;
    
    if ([self shouldShowLoadingCell]) {
        [self.loadingView show:YES];
        self.tableView.bounces = NO;
        return _loadingCell;
    } else if ([self shouldShowEmptyCell]) {
        [self.emptyView show:YES withText:_emptyMessage];
        self.tableView.bounces = [self allowBounceWhenDataSourceIsEmpty];
        return _emptyCell;
    }
    
    return [UITableViewCell new];
}

@end
