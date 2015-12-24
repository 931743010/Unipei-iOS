//
//  InquiryApi_InquiryEditState.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/24.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "InquiryApi_InquiryEditState.h"

@implementation InquiryApi_InquiryEditState

-(NSString *)requestUrl {
    return PATH_inquiryApi_inquiryEditState;
}

-(NSDictionary *)paramToPropertyMap {
    
    return @{@"inquiryid": _inquiryid ? : @0};
}


@end
