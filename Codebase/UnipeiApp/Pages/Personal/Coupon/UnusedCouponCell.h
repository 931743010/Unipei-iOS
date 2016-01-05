//
//  UnusedCouponCell.h
//  DymIOSApp
//
//  Created by 沈梦月 on 15/12/22.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"
@interface UnusedCouponCell : UITableViewCell
-(void)configWithModel:(CouponModel *)model;

@property (weak, nonatomic) IBOutlet UIView *couponView;
@property (weak, nonatomic) IBOutlet UILabel *couponNum;
@property (weak, nonatomic) IBOutlet UILabel *couponPrice;
@property (weak, nonatomic) IBOutlet UIButton *couponFull;
@property (weak, nonatomic) IBOutlet UIButton *couponTime;
@property (weak, nonatomic) IBOutlet UILabel *couponTitle;

@end
