//
//  InquiryApi_AddReciveAddress.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/12.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "InquiryApi_AddReciveAddress.h"
#import "JPUtils.h"

@implementation InquiryApi_AddReciveAddress

-(NSString *)requestUrl {
    return PATH_inquiryApi_addReciveAddress;
}

-(NSDictionary *)paramToPropertyMap {
    return @{@"contactname": [JPUtils stringValueSafe:_contactname]
             , @"state": [JPUtils stringValueSafe:_state]
             , @"city": [JPUtils stringValueSafe:_city]
             , @"district": [JPUtils stringValueSafe:_district]
             , @"zipcode": [JPUtils stringValueSafe:_zipcode]
             , @"address": [JPUtils stringValueSafe:_address]
             , @"phone": [JPUtils stringValueSafe:_phone]
                                 };
}
@end
