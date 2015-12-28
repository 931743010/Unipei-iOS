//
//  UNPOrderDetailVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/26.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UNPOrderDetailVC.h"
#import "OrderApi_OrderFormDetails.h"
#import "JPOrderGoodsCell.h"
#import "JPDesignSpec.h"
#import "JPUtils.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JPSubmitButton.h"
#import "UNPGoodsDetailVC.h"
#import "DymCommonApi.h"
#import "UNPOrderTrackVC.h"
#import "JPGuessMyKey.h"

@interface UNPOrderDetailVC () <UITableViewDataSource, UITableViewDelegate> {
//    NSInteger   _orderStatus;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderTime;
@property (weak, nonatomic) IBOutlet JPSubmitButton *btnOrderTrack;
@property (weak, nonatomic) IBOutlet JPSubmitButton *btnOrderCancel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBtnOrderCancelTrailing;


@property (nonatomic, strong, readonly) NSMutableDictionary           *order;

@end

@implementation UNPOrderDetailVC

-(BOOL)canCancelOrder {
    
    return [JPUtils canCancelOrder:_order];

}

-(BOOL)canConfirmOrder {
    
    return [JPUtils canConfirmOrder:_order];
    
}

-(void)setTheOrder:(id)order {
    if ([order isKindOfClass:[NSDictionary class]]) {
        _order = [order mutableCopy];
    }
}

-(NSNumber *)safeOrderID {
    
    if (_order[@"ID"]) {
        return [JPUtils numberValueSafe:_order[@"ID"]];
    } else if (_order[@"orderId"]) {
        return [JPUtils numberValueSafe:_order[@"orderId"]];
    }
    
    return _orderID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"订单详情";
    
    _btnOrderTrack.style = kJPButtonWhite;
    _btnOrderCancel.style = kJPButtonWhite;

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    @weakify(self)
    
    NSNumber *orderID = [self safeOrderID];
    if ([orderID longLongValue] > 0) {
        OrderApi_OrderFormDetails *api = [OrderApi_OrderFormDetails new];
        api.orderID = orderID;
        
        [self showLoadingView:YES];
        [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(OrderApi_OrderFormDetails_Result *result) {
            [self showLoadingView:NO];
            
            if (result.success) {
                @strongify(self)
                [self setTheOrder:result.orderDetail];
                
//                self->_orderStatus = [self.order[@"status"] integerValue];
                [self updateUIForOrderStatus];
                
                NSNumber *createTimeStamp = [JPUtils numberValueSafe:self.order[@"createTime"]];
                NSString *createTimeStr = [JPUtils timeStringFromStamp:[createTimeStamp longLongValue]];
                self.lblOrderTime.text = [NSString stringWithFormat:@"下单时间:\n%@", createTimeStr];
                
                [self.tableView reloadData];
            } else {
                [self showEmptyView:YES text:@"无订单详情数据"];
            }
        }];
        
    } else {
        [self showEmptyView:YES text:@"无订单详情数据"];
    }
    
    /// 取消订单
    [[_btnOrderCancel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        @strongify(self)
        BOOL canCancel = [self canCancelOrder];
//        BOOL canConfirm = [self canConfirmOrder];
        NSString *title = canCancel ? @"是否取消此订单？" : @"是否确认收货？";

        @weakify(self)
        UIAlertController *vc = [JPUtils alert:title message:nil comfirmBlock:^(UIAlertAction *action) {
            
            @strongify(self)
            NSNumber *orderID = [self safeOrderID];
            if ([orderID longLongValue] > 0) {
                
                DymCommonApi *api = [DymCommonApi new];
                api.relativePath = canCancel ? PATH_orderApi_orderCancel : PATH_orderApi_orderConfirm;
                api.params = @{@"orderID": orderID};
                api.custom_organIdKey = @"organID";
                
                @weakify(self)
                [[DymRequest commonApiSignal:api queue:self.apiQueue] subscribeNext:^(DymBaseRespModel *result) {
                    if (result.success) {
                        @strongify(self)
                        id status = @(canCancel ? kJPOrderStatusCancelled : kJPOrderStatusReceived);
                        [JPUtils setValue:status object:self.order possibleKeys:[JPGuessMyKey keys_status]];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:JP_NOTIFICATION_ORDER_STATUS_CHANGED object:self.order];
                        
                        [self updateUIForOrderStatus];
                    }
                }];
            }
            
        } cancelBlock:^(UIAlertAction *action) {
            
        }];
        
        [self presentViewController:vc animated:YES completion:nil];
    }];
    
    /// 订单跟踪
    [[_btnOrderTrack rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self viewOrderTrack];
        
    }];
}

-(void)viewOrderTrack {
    NSNumber *orderID = [self safeOrderID];
    if ([orderID longLongValue] > 0) {
        UNPOrderTrackVC *vc = [UNPOrderTrackVC newFromStoryboard];
        vc.orderID = orderID;
        vc.orderSN = self->_order[@"orderSN"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)updateUIForOrderStatus {
    BOOL canCancel = [self canCancelOrder];
    BOOL canConfirm = [self canConfirmOrder];
    BOOL needHideCancelButton = !canCancel && !canConfirm;
    
    _btnOrderCancel.hidden = needHideCancelButton;
    _constraintBtnOrderCancelTrailing.constant = needHideCancelButton ? -72 : 16;
    
    if (canCancel) {
        [_btnOrderCancel setTitle:@"取消订单" forState:UIControlStateNormal];
    } else if (canConfirm) {
        [_btnOrderCancel setTitle:@"确认收货" forState:UIControlStateNormal];
    }
}

+(instancetype)newFromStoryboard {
    return [[DymStoryboard unipeiOrder_Storyboard] instantiateViewControllerWithIdentifier:@"UNPOrderDetailVC"];
}


#pragma mark - table view
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 1;
    } else if (section == 3) {
        return [self goods].count;
    } else if (section == 4) {
        return 1;
    }
    
    return 0;
}

-(NSArray *)goods {
    return _order[@"orderGoodsVo_list"];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderSnCell"];
            UILabel *label = ((UILabel *)[cell.contentView viewWithTag:100]);
            label.text = _order[@"orderSN"];
            return cell;
        } else if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderStatusCell"];
            cell.backgroundColor = [UIColor whiteColor];
            UILabel *label = ((UILabel *)[cell.contentView viewWithTag:100]);
            label.text = _order[@"status_Name"];

            return cell;
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"orderAddressCell"];
            
            UILabel *labelContact = ((UILabel *)[cell.contentView viewWithTag:100]);
            UILabel *labelPhone = ((UILabel *)[cell.contentView viewWithTag:101]);
            UILabel *labelAddress = ((UILabel *)[cell.contentView viewWithTag:102]);
            
            labelContact.text = _order[@"shippingName"];
            labelPhone.text = _order[@"buyerMobile"];
            labelAddress.text = _order[@"buyerAddress"];
            
            return cell;
        }
    }  else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dealerCell"];
            cell.backgroundColor = [UIColor whiteColor];
            ((JPLinedTableCell *)cell).bottomLine.backgroundColor = [JPDesignSpec colorMajor];
            
            UILabel *label = ((UILabel *)[cell.contentView viewWithTag:100]);
            label.text = _order[@"organName"];
//            label.text = @"dkashhdfjkhdkjhakjsdhjkashdkjahskdjhaskjdhkjashdkjasd";
            
            return cell;
        }
    } else if (indexPath.section == 3) {
        
        JPOrderGoodsCell *cell = (JPOrderGoodsCell *)[tableView dequeueReusableCellWithIdentifier:@"goodsCell"];
        id goodsItem = [self goods][indexPath.row];
        
        cell.lblName.text = goodsItem[@"goodsname"];
        
        NSNumber *proprice = [JPUtils numberValueSafe:goodsItem[@"proprice"]];
        NSString *priceStr = [NSString stringWithFormat:@"￥%.2f", [proprice doubleValue]];
        cell.lblMoney.text = priceStr;
        
        NSArray *imagePaths = goodsItem[@"imagePath"];
        NSString *imagePath = [JPUtils stringValueSafe:(imagePaths.firstObject)[@"mallimage"]];
        if (imagePath.length) {
            imagePath = [JPUtils fullMediaPath:imagePath];
            [cell.ivLogo sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"icon_goods_logo_default"]];
        } else {
            cell.ivLogo.image = [UIImage imageNamed:@"icon_goods_logo_default"];
        }

        cell.lblModel.text = [NSString stringWithFormat:@"档次:%@",[JPUtils stringValueSafe:goodsItem[@"partsLevelName"]]];
        NSMutableArray *strArr = [NSMutableArray arrayWithObjects:goodsItem[@"makeIdName"],goodsItem[@"carIdName"],goodsItem[@"year"],goodsItem[@"modelIdName"], nil];
        NSString *modelStr = [strArr componentsJoinedByString:@" "];
        cell.lblCarModel.text = [NSString stringWithFormat:@"定位车型:%@",modelStr];
        
        cell.lblQuality.text = nil;
        NSNumber *amountStr = [JPUtils numberValueSafe:goodsItem[@"quantity"]];
        if (amountStr) {
            cell.lblAmount.text = [NSString stringWithFormat:@"x %ld", (long)[amountStr integerValue]];
        } else {
            cell.lblAmount.text = nil;
        }
        
        
        //            {"pog_id":2953,"goodsId":139660,"makeId":5000000,"carId":0,"modelId":0,"year":"不确定年款","makeIdName":"上海通用别克","carIdName":"","modelIdName":"","partsLevel":"A","partsLevelName":"原厂","imagePath":[{"id":733,"organid":170182,"goodsid":139660,"imageurl":"dealer/170182/goods/small/A2015091601050128735.jpg","createtime":1442371979,"imagename":"东风日产.jpg","mallimage":"dealer/170182/goods/thumb/A2015091601050128735.jpg","bigimage":"dealer/170182/goods/normal/A2015091601050128735.jpg"}],"goodsnum":"CMBL-123456","goodsoe":"10425838","goodsname":"车门玻璃","cpname":"车门玻璃","brand":"","price":23.00,"proprice":21.85,"quantity":5,"shipcost":"","goodsamount":109.25}
        
        return cell;
        
    } else if (indexPath.section == 4) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"totalCell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        
        UILabel *lblOrderPrice = ((UILabel *)[cell.contentView viewWithTag:100]);
        UILabel *lblCouponPrice = ((UILabel *)[cell.contentView viewWithTag:101]);
        UILabel *lblActualPrice = ((UILabel *)[cell.contentView viewWithTag:102]);
        
        NSNumber *orderPriceNumber = [JPUtils numberValueSafe:_order[@"goodsAmount"]];
        NSNumber *couponPriceNumber = [JPUtils numberValueSafe:_order[@"ppo_amount"]];
        NSNumber *actualPriceNumber = [JPUtils numberValueSafe:_order[@"totalAmount"]];
        
        lblOrderPrice.text = [NSString stringWithFormat:@"￥%.2f", [orderPriceNumber doubleValue]];
        lblCouponPrice.text = [NSString stringWithFormat:@"￥%.2f", [couponPriceNumber doubleValue]];
        lblActualPrice.text = [NSString stringWithFormat:@"￥%.2f", [actualPriceNumber doubleValue]];
        
        return cell;
    }
    
    return [UITableViewCell new];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 8;
    } else if (section == 2) {
        return 8;
    }
    
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            [self viewOrderTrack];
        }
    } else if (indexPath.section == 3) {
        id goodsItem = [self goods][indexPath.row];
        
        UNPGoodsDetailVC *vc = [UNPGoodsDetailVC newFromStoryboard];
        vc.goodsID = goodsItem[@"pog_id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
