//
//  OrderApi_OrderFormDetails.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/26.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

@interface OrderApi_OrderFormDetails : DymRequest
@property (nonatomic, strong) NSNumber  *orderID;
@end


@interface OrderApi_OrderFormDetails_Result : DymBaseRespModel
@property (nonatomic, copy) id  orderDetail;
@end
