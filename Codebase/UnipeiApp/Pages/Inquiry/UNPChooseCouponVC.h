//
//  UNPChooseCouponVC.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/11/25.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseTableVC.h"

typedef void(^UNPCouponChosenBlock)(id coupon);

@interface UNPChooseCouponVC : DymBaseTableVC

@property (nonatomic, strong) NSArray   *coupons;

@property (nonatomic, copy) UNPCouponChosenBlock   chosenBlock;

@end
