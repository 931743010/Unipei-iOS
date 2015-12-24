//
//  InquiryApi_GetScheme.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/29.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "InquiryApi_GetScheme.h"


@implementation InquiryApi_GetScheme

-(NSString *)requestUrl {
    return PATH_inquiryApi_getScheme;
}

-(NSDictionary *)paramToPropertyMap {
    return @{@"inquiryid": [JPUtils stringValueSafe:_inquiryid defaultValue:@"0"]
             , @"quoid": [JPUtils stringValueSafe:_quoid defaultValue:@"0"]};
}

-(Class)responseModelClass {
    return [InquiryApi_GetScheme_Result class];
}

@end


@implementation InquiryApi_GetScheme_Result


+(NSDictionary *) jsonMap {
    return @{
             @"schemes": @"body.Scheme"
             , @"QuoStatus": @"body.QuoStatus"
             };
}

@end
