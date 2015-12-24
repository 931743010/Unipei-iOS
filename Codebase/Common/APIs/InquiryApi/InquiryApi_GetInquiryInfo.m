//
//  InquiryApi_GetInquiryInfo.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/28.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "InquiryApi_GetInquiryInfo.h"

@implementation InquiryApi_GetInquiryInfo

-(NSString *)requestUrl {
    return PATH_inquiryApi_getInquiryInfo;
}

-(NSDictionary *)paramToPropertyMap {
    return @{@"inquiryid": _inquiryid ? : @0};
}

-(Class)responseModelClass {
    return [InquiryApi_GetInquiryInfo_Result class];
}

@end



@implementation InquiryApi_GetInquiryInfo_Result

+(NSDictionary *) jsonMap {
    return @{
             @"inquiryInfo": @"body.inquiryInfo"
             };
}

+(NSValueTransformer *)inquiryInfoJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[JPInquiry class]];
}

@end
