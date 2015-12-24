//
//  JPInquiry.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/28.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPInquiry.h"

@implementation JPInquiry

+(NSDictionary *) jsonMap {
    return @{
             @"token": @"token"
             , @"organid": @"organid"
             , @"vin": @"vin"
             , @"describe": @"describe"
             , @"dealerid": @"dealerid"
             
             , @"make": @"make"
             , @"type": @"type"
             , @"car": @"car"
             , @"year": @"year"
             , @"model": @"model"
             , @"desc": @"description"
             
             , @"inquiryid": @"inquiryid"
             , @"status": @"status"
             , @"createtime": @"createtime"
             , @"ordersn": @"ordersn"
             , @"inquirysn": @"inquirysn"
             , @"startSearchTime": @"startSearchTime"
             , @"endSearchTime": @"endSearchTime"
             
             , @"makeName": @"makeName"
             , @"carName": @"carName"
             , @"modelName": @"modelName"
             , @"dealerOrganName": @"dealerOrganName"
             , @"dealerPhone": @"dealerPhone"
             , @"searchStatus": @"searchStatus"
             , @"categorieList": @"categorieList"
             
             , @"picfilepList": @"picfileList"
             , @"picfilevList": @"picfilevList"
             , @"pageIndex": @"pageIndex"
             , @"pageSize": @"pageSize"
             };
}

-(NSString *)fullModelString {
    NSMutableArray *strings = [NSMutableArray array];
    if (_makeName) {
        [strings addObject:_makeName];
    }
    if (_carName) {
        [strings addObject:_carName];
    }
    if (_year) {
        [strings addObject:_year];
    }
    if (_modelName) {
        [strings addObject:_modelName];
    }
    
    return [strings componentsJoinedByString:@" "];
}

@end
