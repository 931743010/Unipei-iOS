//
//  InquiryApi_FindReceiveAddress.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/12.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "InquiryApi_FindReceiveAddress.h"

@implementation InquiryApi_FindReceiveAddress

-(NSString *)requestUrl {
    return PATH_inquiryApi_findReceiveAddress;
}

-(NSString *)organIdParamKey {
    return @"organId";
}

-(Class)organIdParamClass {
    return [NSString class];
}

-(Class)responseModelClass {
    return [InquiryApi_FindReceiveAddress_Result class];
}

@end


@implementation InquiryApi_FindReceiveAddress_Result

+(NSDictionary *)jsonMap {
    return @{@"addressList" : @"body.addressList"};
}

+(NSValueTransformer *)addressListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[JPInquiryAddress class]];
}

@end