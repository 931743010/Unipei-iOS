//
//  UNPAddressManageVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/27.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPAddressManageVC.h"
#import "JPSensibleButton.h"
#import "UNPInquiryAddressModifyVC.h"
#import "JPAddressItemCell.h"
#import "InquiryApi_FindReceiveAddress.h"
#import "InquiryApi_UpdateDefaultAddress.h"
#import "InquiryApi_DeleteReceiveAddressById.h"
#import <UnipeiApp-Swift.h>

@interface UNPAddressManageVC () {
    NSArray             *_addresses;
    UIRefreshControl    *_refreshControl;
    NSUInteger          _defaultIndex;
    
    UIBarButtonItem     *_barBtnAdd;
}
@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UNPAddressManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self)
    
    self.navigationItem.title = @"收货地址";
    
    self.tableView.estimatedRowHeight = 115;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Create inquiry button
    JPSensibleButton *btnAdd = [[JPSensibleButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    [btnAdd setImage:[UIImage imageNamed:@"btn_circle_add"] forState:UIControlStateNormal];
    [[btnAdd rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self modifyWithAddress:nil];
    }];
    
    _barBtnAdd = [[UIBarButtonItem alloc] initWithCustomView:btnAdd];
    self.navigationItem.rightBarButtonItem = _barBtnAdd;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:_refreshControl];
    
    [[_refreshControl rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        @strongify(self)
        [self getAddresses];
    }];
    
    // Request data
    [self getAddresses];
    [_refreshControl beginRefreshing];
    
    
    /// notifications
    id observer = [[NSNotificationCenter defaultCenter] addObserverForName:JP_NOTIFICATION_ADDRESS_CHANGED object:nil queue:nil usingBlock:^(NSNotification *note) {
        @strongify(self)
        [self getAddresses];
        [self->_refreshControl beginRefreshing];
    }];
    
    [self.observerQueue addObject:observer];
}

-(void)modifyWithAddress:(JPInquiryAddress *)address {
    
    if (address == nil && _addresses.count > 9) {
        [[JLToast makeTextQuick:@"收货地址最多10条，不能继续添加"] show];
        return;
    }
    
    UNPInquiryAddressModifyVC *vc = [UNPInquiryAddressModifyVC newFromStoryboard];
    vc.address = address;
    
    [self.navigationController pushViewController:vc animated:YES];
}


+(instancetype)newFromStoryboard {
    return [[DymStoryboard common_Storyboard] instantiateViewControllerWithIdentifier:@"UNPAddressManageVC"];
}


#pragma mark - table view
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _addresses.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JPAddressItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JPAddressItemCell" forIndexPath:indexPath];
    
    JPInquiryAddress *address = _addresses[indexPath.row];
    cell.lblAddress.text = address.address;
    cell.lblName.text = [NSString stringWithFormat:@"%@ %@", address.contactname, address.phone];
    cell.lblPostCode.text = address.zipcode;
    
    cell.btnEdit.tag = indexPath.row;
    [cell.btnEdit removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [cell.btnEdit addTarget:self action:@selector(actionEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnDelete.tag = indexPath.row;
    [cell.btnDelete removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDelete addTarget:self action:@selector(actionDelete:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setDefault:(_defaultIndex == indexPath.row)];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JPInquiryAddress *address = _addresses[indexPath.row];
    
    InquiryApi_UpdateDefaultAddress *api = [InquiryApi_UpdateDefaultAddress new];
    api.addressID = address.addressID;
    
    @weakify(self)
    [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
        
        @strongify(self)
        if (result.success) {
            self->_defaultIndex = indexPath.row;
        }
        
        [tableView reloadData];
    }];
}

-(void)actionEdit:(UIButton *)button {
    NSInteger index = button.tag;
    JPInquiryAddress *address = _addresses[index];
    [self modifyWithAddress:address];
}

-(void)actionDelete:(UIButton *)button {
    dispatch_block_t block = ^(void) {
        NSInteger index = button.tag;
        JPInquiryAddress *address = _addresses[index];
        
        InquiryApi_DeleteReceiveAddressById *api = [InquiryApi_DeleteReceiveAddressById new];
        api.addressID = address.addressID;
        
        @weakify(self)
        [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
            @strongify(self)
            if (result.success) {
                [self getAddresses];
                [self->_refreshControl beginRefreshing];
            }
        }];
    };
    
    UIAlertController *vc = [JPUtils alert:@"是否删除此收货地址？" message:nil comfirmBlock:^(UIAlertAction *action) {
        block();
    } cancelBlock:^(UIAlertAction *action) {
        
    }];
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - requests
-(void)getAddresses {
    
    @weakify(self)
    [[self getAddressesSignal] subscribeNext:^(InquiryApi_FindReceiveAddress_Result *result) {
        @strongify(self)
        [self->_refreshControl endRefreshing];
        BOOL hasData = NO;
        if ([result isKindOfClass:[InquiryApi_FindReceiveAddress_Result class]] && result.success) {
            NSArray *addressList = result.addressList;
            self->_addresses = addressList;
            
            __block BOOL hasDefault = NO;
            [addressList enumerateObjectsUsingBlock:^(JPInquiryAddress *obj, NSUInteger idx, BOOL *stop) {
                if ([obj.isdefault boolValue]) {
                    self->_defaultIndex = idx;
                    hasDefault = YES;
                    *stop = YES;
                }
            }];
            
            if (!hasDefault) {
                self->_defaultIndex = -1;
            }
            //_defaultIndex
            [self.tableView reloadData];
            hasData = result.addressList.count > 0;
        }
        
//        BOOL canAdd = (self->_addresses.count < 10);
//        self.navigationItem.rightBarButtonItem = canAdd ? _barBtnAdd : nil;
        
        [self showEmptyView:!hasData text:@"您还没有添加收货地址哦"];
    }];
}

#pragma mark - signals
-(RACSignal *)getAddressesSignal {
    return [DymRequest commonApiSignalWithClass:[InquiryApi_FindReceiveAddress class] queue:self.apiQueue params:nil];
}


@end
