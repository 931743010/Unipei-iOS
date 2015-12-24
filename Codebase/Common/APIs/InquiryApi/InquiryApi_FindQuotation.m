//
//  InquiryApi_FindQuotation.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/28.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "InquiryApi_FindQuotation.h"

@implementation InquiryApi_FindQuotation

-(NSString *)requestUrl {
    return PATH_inquiryApi_findQuotation;
}

-(NSDictionary *)paramToPropertyMap {
    return @{@"inquiryid": [JPUtils stringValueSafe:_inquiryid defaultValue:@"0"]
             , @"quoid": [JPUtils stringValueSafe:_quoid defaultValue:@"0"]};
}

@end
