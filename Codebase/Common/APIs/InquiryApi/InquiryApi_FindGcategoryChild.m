//
//  InquiryApi_FindGcategoryChild.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "InquiryApi_FindGcategoryChild.h"

@implementation InquiryApi_FindGcategoryChild

-(NSString *)requestUrl {
    return PATH_inquiryApi_findGcategoryChild;
}

-(NSDictionary *)paramToPropertyMap {
    return @{@"parentID" : _parentID ? : @0};
}

-(Class)responseModelClass {
    return [InquiryApi_FindGcategoryChild_Result class];
}

- (NSInteger)cacheTimeInSeconds {
    return kJPTimeSecondsWeek; // 1 week
}

@end


@implementation InquiryApi_FindGcategoryChild_Result

+(NSDictionary *) jsonMap {
    return @{
             @"list": @"body.list"
             };
}

@end
