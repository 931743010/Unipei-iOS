//
//  ShopApi_GetAuthCode.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/27.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "CommonApi_GetAuthCode.h"


@implementation CommonApi_GetAuthCode

-(NSString *)requestUrl {
    return PATH_commonApi_sendMessage;
}

-(NSDictionary *)paramToPropertyMap {
    
    return @{@"phone" : _phone ? : @""
             , @"type": _type ? : @0
             , @"msgTitle": _msgTitle ? : @""};
    
}



-(Class)responseModelClass {
    return [JPAuthCode class];
}

@end




///////////////////////////////////////////
@implementation JPAuthCode

+(NSDictionary *) jsonMap {
    return @{
             @"authCode": @"body.authCode",
             @"sendTime": @"body.sendTime"
             };
}

@end
