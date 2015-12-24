//
//  InquiryApi_FindState.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/15.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "InquiryApi_FindState.h"

@implementation InquiryApi_FindState

-(NSString *)requestUrl {
    return PATH_inquiryApi_findState;
}

-(Class)responseModelClass {
    return [InquiryApi_FindState_Result class];
}

- (NSInteger)cacheTimeInSeconds {
    return kJPTimeSecondsWeek; // 1 week
}

@end

@implementation InquiryApi_FindState_Result

+(NSDictionary *) jsonMap {
    return @{
             @"list": @"body.list"
             };
}

@end
