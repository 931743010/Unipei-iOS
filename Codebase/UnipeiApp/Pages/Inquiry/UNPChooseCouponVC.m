//
//  UNPChooseCouponVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/11/25.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UNPChooseCouponVC.h"

@interface UNPChooseCouponVC ()

@end

@implementation UNPChooseCouponVC

+(instancetype)newFromStoryboard {
    return [[DymStoryboard common_Storyboard] instantiateViewControllerWithIdentifier:@"UNPChooseCouponVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"选择优惠券";
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - table view
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _coupons.count;
}

//{"id":62,"couponsn":"1532195874","couponid":2,"promoid":4,"ownerid":174582,"isuse":0,"createtime":1447836132,"amount":30.00,"valid":"30","orderminamount":""}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel *lblCouponSN = [cell.contentView viewWithTag:101];
    UILabel *lblPrice = [cell.contentView viewWithTag:102];
    
    id item = _coupons[indexPath.row];
    lblCouponSN.text = item[@"couponsn"];
    lblPrice.text = [NSString stringWithFormat:@"￥%.2f", [item[@"amount"] floatValue]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_chosenBlock) {
        id item = _coupons[indexPath.row];
        _chosenBlock(item);
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIButton *btnClose = [UIButton new];
    btnClose.backgroundColor = [UIColor colorWithWhite:0.99 alpha:1];
    btnClose.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btnClose setTitleColor:[UIColor colorWithWhite:0 alpha:1] forState:UIControlStateNormal];
    [btnClose setTitle:@"不使用优惠券" forState:UIControlStateNormal];
    //    @weakify(self)
    [[btnClose rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //        @strongify(self)
        if (_chosenBlock) {
            _chosenBlock(nil);
        }
    }];
    
    return btnClose;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}


@end
