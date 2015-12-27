//
//  CouponModel.h
//  DymIOSApp
//
//  Created by 沈梦月 on 15/12/24.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseModel.h"

@interface CouponModel : DymBaseModel
@property(nonatomic,copy)NSString *Amount;
@property(nonatomic,copy)NSString *CouponSn;
@property(nonatomic,copy)NSString *OrderMinAmount;
@property(nonatomic,copy)NSString *State;
@property(nonatomic,copy)NSString *Title;
@property(nonatomic,copy)NSString *Validity;
@end
