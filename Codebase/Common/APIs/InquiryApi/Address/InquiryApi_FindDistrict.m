//
//  InquiryApi_FindDistrict.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/15.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "InquiryApi_FindDistrict.h"

@implementation InquiryApi_FindDistrict

-(NSString *)requestUrl {
    return PATH_inquiryApi_findDistrict;
}

-(NSDictionary *)paramToPropertyMap {
    
    return @{@"parentID":  [JPUtils stringValueSafe:_parentID]};
    
}

-(Class)responseModelClass {
    return [InquiryApi_FindDistrict_Result class];
}

- (NSInteger)cacheTimeInSeconds {
    return kJPTimeSecondsWeek; // 1 week
}

@end



@implementation InquiryApi_FindDistrict_Result

+(NSDictionary *) jsonMap {
    return @{
             @"list": @"body.list"
             };
}

@end
