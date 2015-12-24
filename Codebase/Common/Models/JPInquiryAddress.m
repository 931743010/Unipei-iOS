//
//  JPInquiryAddress.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/12.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPInquiryAddress.h"

@implementation JPInquiryAddress

+(NSDictionary *)jsonMap {
    return @{
             @"addressID" : @"id"
             , @"organid" : @"organid"
             , @"contactname" : @"contactname"
             
             , @"state" : @"state"
             , @"city" : @"city"
             , @"district" : @"district"
             
             , @"statename" : @"statename"
             , @"cityname" : @"cityname"
             , @"districtname" : @"districtname"
             
             , @"zipcode" : @"zipcode"
             , @"address" : @"address"
             , @"phone" : @"phone"
             , @"memo" : @"memo"
             , @"isdefault" : @"isdefault"
             , @"createtime" : @"createtime"
             , @"updatetime" : @"updatetime"
             };
}

@end

/*
 {
 "id": 19,
 "organid": 169405,
 "contactname": "小白",
 "state": "370000",
 "city": "370200",
 "district": "370203",
 "zipcode": "147000",
 "address": "民族大道口锦绣龙城C区3301室",
 "phone": "13589009883",
 "memo": null,
 "isdefault": 0,
 "createtime": 1418697575,
 "updatetime": 1418697575,
 }
 */