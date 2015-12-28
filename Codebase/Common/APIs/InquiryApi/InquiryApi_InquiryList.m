//
//  InquiryApi_InquiryList.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/24.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "InquiryApi_InquiryList.h"
#import "JPDesignSpec.h"

@implementation InquiryApi_InquiryList

/// equality comparation ignores pageIndex & pageSize
-(BOOL)conditionChanged:(InquiryApi_InquiryList *)identifiedObject {
    
    BOOL b11 = (identifiedObject.inquirysn.length != self.inquirysn.length);
    BOOL b12 = identifiedObject.inquirysn != nil && ![identifiedObject.inquirysn isEqualToString:self.inquirysn];
    
    BOOL b2 = [identifiedObject.startSearchTime longLongValue] != [self.startSearchTime longLongValue];
    BOOL b3 = [identifiedObject.endSearchTime longLongValue] != [self.endSearchTime longLongValue];
    
    BOOL b41 =  self.status != identifiedObject.status && (identifiedObject.status == nil || self.status == nil);
    BOOL b42 = [identifiedObject.status integerValue] != [self.status integerValue];
    
    BOOL b5 = [identifiedObject.listType integerValue] != [self.listType integerValue];
    
    if (b11 || b12 || b2 || b3 || b41 || b42 || b5) {
        
        return YES;
    }
    
    return NO;
}

- (id)copyWithZone:(NSZone *)zone {
    InquiryApi_InquiryList *copy = [[[self class] allocWithZone:zone] init];
    
    copy.pageIndex = [self.pageIndex copyWithZone:zone];
    copy.pageSize = [self.pageSize copyWithZone:zone];
    copy.inquirysn = [self.inquirysn copyWithZone:zone];
    copy.startSearchTime = [self.startSearchTime copyWithZone:zone];
    copy.endSearchTime = [self.endSearchTime copyWithZone:zone];
    copy.status = [self.status copyWithZone:zone];
    copy.listType = [self.listType copyWithZone:zone];
    
    return copy;
}

-(NSString *)requestUrl {
    return PATH_inquiryApi_inquiryList;
}

-(NSDictionary *)paramToPropertyMap {
    
    NSMutableDictionary *map = @{
             @"pageIndex": _pageIndex ? : @0
             , @"pageSize": _pageSize ? : @0
             }.mutableCopy;
    
    if (_inquirysn.length > 0) {
        [map setObject:_inquirysn forKey:@"inquirysn"];
    }
    
    if (_startSearchTime != nil) {
        [map setObject:_startSearchTime forKey:@"startSearchTime"];
    }
    
    if (_endSearchTime != nil) {
        [map setObject:_endSearchTime forKey:@"endSearchTime"];
    }
    
    if (_status != nil && [_status integerValue] != kJPInquiryStatusAll) {
        [map setObject:_status forKey:@"status"];
    }
    
    [map setObjectSafe:[JPUtils numberValueSafe:_listType] forKey:@"listType"];
    
    return map;
}

-(Class)responseModelClass {
    return [InquiryApi_InquiryList_Result class];
}

+(NSString *)stringWithInquiryStatus:(EJPInquiryStatus)status {
    if (status == kJPInquiryStatusWaitingQuatation) {
        return @"待报价";
    } else if (status == kJPInquiryStatusWaitingConfirmation) {
        return @"已报价待确认";
    } else if (status == kJPInquiryStatusConformed) {
        return @"已确认";
    } else if (status == kJPInquiryStatusCancelled) {
        return @"已撤消";
    } else if (status == kJPInquiryStatusRefused) {
        return @"已拒绝";
    } else if (status == kJPInquiryStatusInvalidated) {
        return @"已失效";
    } else if (status == kJPInquiryStatusHandling) {
        return @"正在处理中";
    }
    
    return nil;
}

+(UIColor *)colorWithInquiryStatus:(EJPInquiryStatus)status {
    if (status == kJPInquiryStatusWaitingQuatation) {
        return [UIColor blackColor];
    } else if (status == kJPInquiryStatusWaitingConfirmation) {
        return [JPDesignSpec colorMajor];
    } else if (status == kJPInquiryStatusConformed) {
        return [JPDesignSpec colorMinor];
    } else if (status == kJPInquiryStatusCancelled) {
        return [JPDesignSpec colorGray];
    } else if (status == kJPInquiryStatusRefused) {
        return [JPDesignSpec colorGray];
    } else if (status == kJPInquiryStatusInvalidated) {
        return [JPDesignSpec colorGray];
    }
    
    return [UIColor blackColor];
}

@end



@implementation InquiryApi_InquiryList_Result

+(NSDictionary *) jsonMap {
    return @{
             @"list": @"body.list"
             };
}

@end