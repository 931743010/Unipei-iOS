//
//  OrderApi_OrderFormDetails.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/26.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "OrderApi_OrderFormDetails.h"

@implementation OrderApi_OrderFormDetails

-(NSString *)requestUrl {
    return PATH_orderApi_orderFormDetails;
}

-(NSDictionary *)paramToPropertyMap {
    
    return @{@"id":  [JPUtils numberValueSafe:_orderID]};
    
}

-(Class)responseModelClass {
    return [OrderApi_OrderFormDetails_Result class];
}

@end


@implementation OrderApi_OrderFormDetails_Result

+(NSDictionary *) jsonMap {
    return @{
             @"orderDetail": @"body"
             };
}

@end
