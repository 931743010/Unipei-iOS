//
//  CommonApi_GetCity.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/9.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "CommonApi_GetCity.h"

@implementation CommonApi_GetCity

-(NSString *)requestUrl {
    return PATH_commonApi_getCity;
}

-(NSDictionary *)paramToPropertyMap {
    
    return @{@"parentId": _parentId ? : @""};
    
}


-(Class)responseModelClass {
    return [CommonApi_GetCity_Result class];
}

- (NSInteger)cacheTimeInSeconds {
    return kJPTimeSecondsWeek; // 1 week
}

@end




@implementation CommonApi_GetCity_Result

+(NSDictionary *) jsonMap {
    return @{
             @"cityList": @"body.cityList"
             };
}

+(NSValueTransformer *)cityListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[JPAddressNode class]];
}

@end