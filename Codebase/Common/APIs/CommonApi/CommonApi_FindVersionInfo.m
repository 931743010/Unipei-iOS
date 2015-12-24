//
//  CommonApi_FindVersionInfo.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "CommonApi_FindVersionInfo.h"

@implementation CommonApi_FindVersionInfo

-(NSString *)requestUrl {
    return PATH_commonApi_findVersionInfo;
}

-(NSDictionary *)paramToPropertyMap {
    
    return @{@"osType": [JPUtils stringValueSafe:_osType defaultValue:@"0"]
             , @"apptype": [JPUtils stringValueSafe:_apptype defaultValue:@"0"]};
    
}

-(Class)responseModelClass {
    return [CommonApi_FindVersionInfo_Result class];
}

@end


@implementation CommonApi_FindVersionInfo_Result

+(NSDictionary *) jsonMap {
    return @{
             @"versoinname": @"body.jpdVersionInfo.versoinname"
             , @"versioncode": @"body.jpdVersionInfo.versioncode"
             , @"download": @"body.jpdVersionInfo.download"
             , @"desc": @"body.jpdVersionInfo.description"
             , @"appsize": @"body.jpdVersionInfo.appsize"
             , @"isforce": @"body.jpdVersionInfo.isforce"
             };
}

@end
