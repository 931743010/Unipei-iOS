//
//  InquiryApi_FindGcategoryGrandchild.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "InquiryApi_FindGcategoryGrandchild.h"

@implementation InquiryApi_FindGcategoryGrandchild

-(NSString *)requestUrl {
    return PATH_inquiryApi_findGcategoryGrandchild;
}

-(NSDictionary *)paramToPropertyMap {
    return @{@"parentID" : _parentID ? : @0};
}

-(Class)responseModelClass {
    return [InquiryApi_FindGcategoryGrandchild_Result class];
}

- (NSInteger)cacheTimeInSeconds {
    return kJPTimeSecondsWeek; // 1 week
}

@end


@implementation InquiryApi_FindGcategoryGrandchild_Result

+(NSDictionary *) jsonMap {
    return @{
             @"list": @"body.list"
             };
}
@end