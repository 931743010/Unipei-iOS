//
//  CommonApi_GetArea.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/9.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "CommonApi_GetArea.h"

@implementation CommonApi_GetArea

-(NSString *)requestUrl {
    return PATH_commonApi_getArea;
}

-(NSDictionary *)paramToPropertyMap {
    
    return @{@"parentId": _parentId ? : @""};
    
}


-(Class)responseModelClass {
    return [CommonApi_GetArea_Result class];
}

- (NSInteger)cacheTimeInSeconds {
    return kJPTimeSecondsWeek; // 1 week
}

@end



@implementation CommonApi_GetArea_Result

+(NSDictionary *) jsonMap {
    return @{
             @"areaList": @"body.areaList"
             };
}


+(NSValueTransformer *)areaListJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[JPAddressNode class]];
}

@end