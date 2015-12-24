//
//  UNPChooseProvinceVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/15.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPChooseProvinceVC.h"
#import "JPDesignSpec.h"
#import "UNPChooseCityVC.h"

@interface UNPChooseProvinceVC ()

@end

@implementation UNPChooseProvinceVC

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
    
    
    self.navigationItem.title = _viewModel.provinceVM.title;
    
    if (_viewModel.provinceVM.items.count <= 0) {
        [self.loadingView show:YES];
        [_viewModel getProvinces:^(InquiryApi_FindState_Result *result) {
            @strongify(self)
            [self.loadingView show:NO];
            [self.rootView.tableView reloadData];
        } queue:self.apiQueue];
    }
}


#pragma mark - table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _viewModel.provinceVM.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UNPChooseItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UNPChooseItemCell" forIndexPath:indexPath];
    
    
    id item = _viewModel.provinceVM.items[indexPath.row];
    cell.lblTitle.text = [item objectForKey:@"name"];
    
    BOOL selected = _viewModel.provinceVM.selectedItem == item;
    
    cell.lblTitle.textColor = selected ? [JPDesignSpec colorMajor] : [UIColor colorWithWhite:0 alpha:0.87];
    cell.ivCheck.hidden = !selected;
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id item = _viewModel.provinceVM.items[indexPath.row];
    
    [_viewModel.provinceVM selectItem:item];
    
    [tableView reloadData];
    
    
    @weakify(self);
    [self.lazyBlock excuteBlock:^{
        @strongify(self)
        UNPChooseCityVC *vc = [UNPChooseCityVC new];
        vc.viewModel = _viewModel;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

@end
