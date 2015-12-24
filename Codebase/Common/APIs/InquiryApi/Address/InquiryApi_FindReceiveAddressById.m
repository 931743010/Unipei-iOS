//
//  InquiryApi_FindReceiveAddressById.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/12.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "InquiryApi_FindReceiveAddressById.h"

@implementation InquiryApi_FindReceiveAddressById

-(NSString *)requestUrl {
    return PATH_inquiryApi_findReceiveAddressById;
}

-(NSDictionary *)paramToPropertyMap {
    return @{@"id": [JPUtils stringValueSafe:_addressID]};
}

-(Class)responseModelClass {
    return [InquiryApi_FindReceiveAddressById_Result class];
}

@end



@implementation InquiryApi_FindReceiveAddressById_Result

+(NSDictionary *)jsonMap {
    return @{@"address" : @"body.address"};
}

+(NSValueTransformer *)addressJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[JPInquiryAddress class]];
}

@end
