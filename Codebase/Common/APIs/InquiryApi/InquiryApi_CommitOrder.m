//
//  InquiryApi_CommitOrder.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/9.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "InquiryApi_CommitOrder.h"
#import "JPUtils.h"

@implementation InquiryApi_CommitOrder

-(NSString *)requestUrl {
    return PATH_inquiryApi_commitOrder;
}

-(NSDictionary *)paramToPropertyMap {
    NSMutableDictionary *map = @{@"status": _status ? @"true" : @"false"
             , @"schid": [JPUtils stringValueSafe:_schid defaultValue:@"0"]
             , @"inquiryid": [JPUtils stringValueSafe:_inquiryid defaultValue:@"0"]
             , @"quoid": [JPUtils stringValueSafe:_quoid defaultValue:@"0"]
             }.mutableCopy;
    
    if (_status) {
        [map setObjectSafe:[JPUtils stringValueSafe:_addressID] forKey:@"id"];
        [map setObjectSafe:_goodsinfo forKey:@"goodsinfo"];
//        [map setObjectSafe:[JPUtils stringValueSafe:_MakeID] forKey:@"MakeID"];
//        [map setObjectSafe:[JPUtils stringValueSafe:_CarID] forKey:@"CarID"];
//        [map setObjectSafe:[JPUtils stringValueSafe:_Year] forKey:@"Year"];
//        [map setObjectSafe:[JPUtils stringValueSafe:_ModelID] forKey:@"ModelID"];
        
        [map setObjectSafe:[JPUtils stringValueSafe:_shiplogis defaultValue:@""] forKey:@"shiplogis"];
        [map setObjectSafe:[JPUtils stringValueSafe:_shipname defaultValue:@""] forKey:@"shipname"];
        
        if (_couponsn.length > 0) {
            [map setObject:_couponsn forKey:@"couponsn"];
        }
    }
    
    return map;
}



@end
