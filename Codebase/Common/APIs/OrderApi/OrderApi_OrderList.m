//
//  OrderApi_OrderList.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/26.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "OrderApi_OrderList.h"
#import "JPDesignSpec.h"

@implementation OrderApi_OrderList

-(BOOL)conditionChanged:(OrderApi_OrderList *)object{

    return YES;
    
}
- (id)copyWithZone:(NSZone *)zone {
    OrderApi_OrderList *copy = [[[self class] allocWithZone:zone] init];
    
    copy.page = [self.page copyWithZone:zone];
    copy.pageSize = [self.pageSize copyWithZone:zone];
    copy.minAmount = [self.minAmount copyWithZone:zone];
    copy.beginTime = [self.beginTime copyWithZone:zone];
    copy.endTime = [self.endTime copyWithZone:zone];
    copy.status = [self.status copyWithZone:zone];
    copy.maxAmount = [self.maxAmount copyWithZone:zone];
    copy.sellerName = [self.sellerName copyWithZone:zone];
    
    return copy;
}

-(NSString *)requestUrl {
    return PATH_orderApi_orderList;
}

-(NSDictionary *)paramToPropertyMap {
    
    NSMutableDictionary *map = @{@"page":  [JPUtils numberValueSafe:_page]
             , @"pageSize":  [JPUtils numberValueSafe:_pageSize]
             , @"sellerName": [JPUtils stringValueSafe:_sellerName]}.mutableCopy;
    
    if ([_status integerValue] > 0) {
        [map setObject:_status forKey:@"status"];
    }
    
    if (_minAmount && _maxAmount) {
        [map setObjectSafe:_minAmount forKey:@"minAmount"];
        [map setObjectSafe:_maxAmount forKey:@"maxAmount"];
    }
    
    if (_beginTime && _endTime) {
        [map setObject:_beginTime forKey:@"beginTime"];
        [map setObject:_endTime forKey:@"endTime"];
    }
    
    return map;
}

-(NSString *)organIdParamKey {
    return @"buyerID";
}

-(Class)responseModelClass {
    return [OrderApi_OrderList_Result class];
}
+(NSString *)stringWithInquiryStatus:(EJPOrderStatus)status {
    if (status == kJPOrderStatusWaitingForPayment) {
        return @"待付款";
    } else if (status == kJPOrderStatusWaitingForShipping) {
        return @"待发货";
    } else if (status == kJPOrderStatusWaitingForReceival) {
        return @"待收货";
    } else if (status == kJPOrderStatusRefused) {
        return @"已拒收";
    }else if (status == kJPOrderStatusReceived){
        return @"已收货";
    }else if (status == kJPOrderStatusCancelled){
        return @"已取消";
    }else if (status == kJPOrderStatusReturnPending){
        return @"待同意退货";
    }else if (status == kJPOrderStatusReturnWaitForShipping) {
        return @"退货待发货";
    }else if (status == kJPOrderStatusReturnWaitForReceival) {
        return @"退货待收货";
    }else if (status == kJPOrderStatusReturnOK) {
        return @"退货完成";
    }
    return nil;
}

+(UIColor *)colorWithInquiryStatus:(EJPOrderStatus)status {
    if (status == kJPOrderStatusWaitingForPayment) {
        return [UIColor blackColor];
    } else if (status == kJPOrderStatusWaitingForShipping) {
        return [JPDesignSpec colorMajor];
    } else if (status == kJPOrderStatusWaitingForReceival) {
        return [JPDesignSpec colorMinor];
    } else if (status == kJPOrderStatusRefused) {
        return [JPDesignSpec colorGray];
    }else if (status == kJPOrderStatusReceived){
        return [JPDesignSpec colorGray];
    }else if (status == kJPOrderStatusCancelled){
        return [JPDesignSpec colorGray];
    }else if (status == kJPOrderStatusReturnPending){
        return [JPDesignSpec colorGray];
    }else if (status == kJPOrderStatusReturnWaitForShipping) {
        return [JPDesignSpec colorGray];
    }else if (status == kJPOrderStatusReturnWaitForReceival) {
        return [JPDesignSpec colorGray];
    }else if (status == kJPOrderStatusReturnOK) {
        return [JPDesignSpec colorGray];
    }
    
    return [UIColor blackColor];
}

@end


@implementation OrderApi_OrderList_Result

+(NSDictionary *) jsonMap {
    return @{
             @"orderList": @"body.orderList"
             };
}

@end
