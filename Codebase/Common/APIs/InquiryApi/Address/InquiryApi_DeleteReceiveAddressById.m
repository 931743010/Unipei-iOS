//
//  InquiryApi_DeleteReceiveAddressById.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/27.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "InquiryApi_DeleteReceiveAddressById.h"

@implementation InquiryApi_DeleteReceiveAddressById

-(NSString *)requestUrl {
    return PATH_inquiryApi_deleteReceiveAddressById;
}

-(NSDictionary *)paramToPropertyMap {
    return @{@"id": [JPUtils stringValueSafe:_addressID]};
}

@end
