//
//  UNPOrderTrackVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/29.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UNPOrderTrackVC.h"
#import "JPOrderTrackCell.h"

@interface UNPOrderTrackVC () <UITableViewDataSource, UITableViewDelegate> {
    NSArray     *_trailList;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UNPOrderTrackVC

+(instancetype)newFromStoryboard {
    return [[DymStoryboard unipeiOrder_Storyboard] instantiateViewControllerWithIdentifier:@"UNPOrderTrackVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单跟踪";
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    
    
    if ([_orderID longLongValue] > 0) {
        
        DymCommonApi *api = [DymCommonApi new];
        api.relativePath = PATH_orderApi_orderTrail;
        api.params = @{@"orderID": _orderID};
        api.custom_organIdKey = @"organID";
        
        __weak typeof (self) weakSelf = self;
        [self showLoadingView:YES];
        [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
            __strong typeof (self) strongSelf = weakSelf;
            [strongSelf showLoadingView:NO];
            
            if (result.success) {
                id trailList = result.body[@"trailList"];
                if ([trailList isKindOfClass:[NSArray class]]) {
                    strongSelf->_trailList = [[trailList reverseObjectEnumerator] allObjects];
                    [strongSelf.tableView reloadData];
                }
            }
        }];
    }
}


#pragma mark - table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return _trailList.count;
    }
    
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
        UILabel *lblSN = (UILabel *)[cell.contentView viewWithTag:100];
        lblSN.text = [NSString stringWithFormat:@"订单编号：%@", _orderSN];
        
        UILabel *lblPhone = (UILabel *)[cell.contentView viewWithTag:101];
        lblPhone.text = @"服务热线：400-0909-839";
        
        return cell;
        
    } else if (indexPath.section == 1) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trackHeaderCell"];
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
        
    } else if (indexPath.section == 2) {
        
        JPOrderTrackCell *cell = [self trackCellForIndexPath:indexPath];
        
        return cell;
    }
    
    return [UITableViewCell new];
}

-(JPOrderTrackCell *)trackCellForIndexPath:(NSIndexPath *)indexPath {
    
    JPOrderTrackCell *cell = (JPOrderTrackCell *)[self.tableView dequeueReusableCellWithIdentifier:@"trackCell" forIndexPath:indexPath];
    
    id item = _trailList[indexPath.row];
    
    NSString *message = item[@"msg"];
    NSString *shipLogis = item[@"shipLogis"];
    if (shipLogis) {
        message = [message stringByAppendingFormat:@" 物流公司:%@", shipLogis];
    }
    NSString *shipSn = item[@"shipSn"];
    if (shipSn) {
        message = [message stringByAppendingFormat:@" 运单号码:%@", shipSn];
    }
    cell.lblDesc.text = message;
    cell.lblTime.text = item[@"date"];
    
    EJPCellPosition pos = kJPCellPositionAlone;
    if (_trailList.count > 1) {
        if (indexPath.row == 0) {
            pos = kJPCellPositionFirst;
        } else if (indexPath.row == _trailList.count - 1) {
            pos = kJPCellPositionLast;
        } else {
            pos = kJPCellPositionCenter;
        }
    }
    
    [cell setPos:pos];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [UIView new];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 8;
    }
    
    return 0.1;
}

@end
