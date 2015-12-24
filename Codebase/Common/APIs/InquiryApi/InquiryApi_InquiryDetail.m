//
//  InquiryApi_InquiryDetail.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/28.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "InquiryApi_InquiryDetail.h"

@implementation InquiryApi_InquiryDetail

-(NSString *)requestUrl {
    return PATH_inquiryApi_inquiryDetail;
}

-(NSDictionary *)paramToPropertyMap {
    return @{@"organid": _organid ? : @0
             , @"inquiryid": _inquiryid ? : @0};
}

-(Class)responseModelClass {
    return [InquiryApi_InquiryDetail_Result class];
}

@end



@implementation InquiryApi_InquiryDetail_Result

+(NSDictionary *) jsonMap {
    return @{
             @"inquiryInfo": @"body.inquiryVo"
             };
}


+(NSValueTransformer *)inquiryInfoJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[JPInquiry class]];
}

@end



