//
//  InquiryApi_FindCity.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/15.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "InquiryApi_FindCity.h"

@implementation InquiryApi_FindCity

-(NSString *)requestUrl {
    return PATH_inquiryApi_findCity;
}

-(NSDictionary *)paramToPropertyMap {
    
    return @{@"parentID":  [JPUtils stringValueSafe:_parentID]};
    
}

-(Class)responseModelClass {
    return [InquiryApi_FindCity_Result class];
}

- (NSInteger)cacheTimeInSeconds {
    return kJPTimeSecondsWeek; // 1 week
}

@end



@implementation InquiryApi_FindCity_Result

+(NSDictionary *) jsonMap {
    return @{
             @"list": @"body.list"
             };
}

@end
