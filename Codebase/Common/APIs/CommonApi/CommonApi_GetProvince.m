//
//  CommonApi_GetProvince.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/7.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "CommonApi_GetProvince.h"


///////////////////////// CommonApi_GetProvince //////////////////////////

@implementation CommonApi_GetProvince

-(NSString *)requestUrl {
    return PATH_commonApi_getProvince;
}

-(Class)responseModelClass {
    return [CommonApi_GetProvince_Result class];
}

- (NSInteger)cacheTimeInSeconds {
    return kJPTimeSecondsWeek; // 1 week
}

@end


///////////////////////// CommonApi_GetProvince_Result //////////////////////////

@implementation CommonApi_GetProvince_Result


+(NSDictionary *) jsonMap {
    return @{
             @"provinceList": @"body.provinceList"
             };
}

+(NSValueTransformer *)provinceListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[JPAddressNode class]];
}

@end
