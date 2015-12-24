//
//  InquiryApi_InquiryListUpdate.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/8.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "InquiryApi_InquiryListUpdate.h"

@implementation InquiryApi_InquiryListUpdate

-(NSString *)requestUrl {
    return PATH_inquiryApi_inquiryListUpdate;
}

-(NSDictionary *)paramToPropertyMap {
    return @{@"inquiryid": _inquiryid ? : @0
             , @"vin": _vin ? : @""
             , @"describe": _describe ? : @""
             , @"dealerid": _dealerid ? : @""
             , @"make": _make ? : @0
             , @"car": _car ? : @0
             , @"year": _year ? : @0
             , @"model": _model ? : @0
             , @"description": _remark ? : @""
             , @"categorieList": _categorieList ? : @[]
             , @"picfileList": _picfileList ? : @[]
             };
}

@end
