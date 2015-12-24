//
//  UserApi_RegistXLCXX.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/10.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UserApi_RegistXLCXX.h"

@implementation UserApi_RegistXLCXX


-(NSString *)requestUrl {
    return PATH_userApi_registXLCXX;
}

-(NSDictionary *)paramToPropertyMap {
    
    return @{@"organName" : _organName ? : @""
             , @"bossName": _bossName ? : @""
             , @"shopPhoto": _shopPhoto ? : @""
             , @"mdPhoto": _mdPhoto ? : @""
             , @"cardPhoto": _cardPhoto ? : @""
             , @"bLPhoto": _bLPhoto ? : @""
             , @"longitude": _longitude ? : @""
             , @"latitude": _latitude ? : @""
             , @"province": _province ? : @""
             , @"city": _city ? : @""
             , @"area": _area ? : @""
             , @"address": _address ? : @""
             , @"provinceName": _provinceName ? : @""
             , @"cityName": _cityName ? : @""
             , @"areaName": _areaName ? : @""
             , @"scope": _scope ? : @""
             , @"userID": _userID ? : @""
             , @"logo": _logo ? : @""};
    
}


-(Class)responseModelClass {
    return [DymBaseRespModel class];
}

@end
