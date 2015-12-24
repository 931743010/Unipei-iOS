//
//  InquiryApi_UpdateDefaultAddress.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/27.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "InquiryApi_UpdateDefaultAddress.h"

@implementation InquiryApi_UpdateDefaultAddress

-(NSString *)requestUrl {
    return PATH_inquiryApi_updateDefaultAddress;
}

-(NSDictionary *)paramToPropertyMap {
    return @{@"id": [JPUtils stringValueSafe:_addressID]};
}

@end
