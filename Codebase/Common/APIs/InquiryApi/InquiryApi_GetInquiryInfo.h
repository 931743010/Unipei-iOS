//
//  InquiryApi_GetInquiryInfo.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/28.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"
#import "JPInquiry.h"

@interface InquiryApi_GetInquiryInfo : DymRequest

@property (nonatomic, copy) NSNumber    *inquiryid;

@end

/// 询价单详情API - 结果
@interface InquiryApi_GetInquiryInfo_Result : DymBaseRespModel

@property (nonatomic, copy) JPInquiry       *inquiryInfo;

@end
