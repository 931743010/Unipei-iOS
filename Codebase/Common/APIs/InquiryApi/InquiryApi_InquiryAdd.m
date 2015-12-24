//
//  InquiryApi_InquiryAdd.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/23.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "InquiryApi_InquiryAdd.h"

@implementation InquiryApi_InquiryAdd

-(NSString *)requestUrl {
    return PATH_inquiryApi_inquiryAdd;
}

-(NSDictionary *)paramToPropertyMap {
    return @{@"vin": _vin ? : @""
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
