//
//  OrderApi_OrderList.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/26.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"
#import "JPUtils.h"

@class UIColor;

//{"buyerID":"169475","status":"9","minAmount":"4000","maxAmount":"10000","sellerName":"测试经销商","beginTime":"0","endTime":"99999999999999","page":1,"pageSize":3,"token":"FCJ32CVC6LKL24HACGW9HB0XIXTE5B"}


@interface OrderApi_OrderList : DymRequest <NSCopying>
@property (nonatomic, strong) NSNumber  *status;
@property (nonatomic, strong) NSNumber  *minAmount;
@property (nonatomic, strong) NSNumber  *maxAmount;
@property (nonatomic, strong) NSString  *sellerName;
@property (nonatomic, strong) NSNumber  *beginTime;
@property (nonatomic, strong) NSNumber  *endTime;

@property (nonatomic, strong) NSNumber  *page;
@property (nonatomic, strong) NSNumber  *pageSize;

+(NSString *)stringWithInquiryStatus:(EJPOrderStatus)status;
+(UIColor *)colorWithInquiryStatus:(EJPOrderStatus)status;

/// 过滤条件是否改变
-(BOOL)conditionChanged:(OrderApi_OrderList *)object;

@end


@interface OrderApi_OrderList_Result : DymBaseRespModel
@property (nonatomic, copy) NSArray  *orderList;
@end
