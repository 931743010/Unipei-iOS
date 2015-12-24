//
//  InquiryApi_FindGcategory.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "InquiryApi_FindGcategory.h"

@implementation InquiryApi_FindGcategory

-(NSString *)requestUrl {
    return PATH_inquiryApi_findGcategory;
}

-(Class)responseModelClass {
    return [InquiryApi_FindGcategory_Result class];
}

- (NSInteger)cacheTimeInSeconds {
    return kJPTimeSecondsWeek; // 1 week
}

@end


@implementation InquiryApi_FindGcategory_Result

+(NSDictionary *) jsonMap {
    return @{
             @"list": @"body.list"
             };
}

@end
