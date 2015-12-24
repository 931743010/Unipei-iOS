//
//  InquiryApi_FindQuotation.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/28.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

@interface InquiryApi_FindQuotation : DymRequest

@property (nonatomic, copy) NSNumber    *inquiryid;
@property (nonatomic, copy) NSNumber    *quoid;

@end
