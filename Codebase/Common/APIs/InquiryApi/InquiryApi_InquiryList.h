//
//  InquiryApi_InquiryList.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/24.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

@class UIColor;


typedef NS_ENUM(NSInteger, EJPInquiryStatus) {
    kJPInquiryStatusWaitingQuatation        = 0
    , kJPInquiryStatusWaitingConfirmation    = 1
    , kJPInquiryStatusConformed             = 2
    , kJPInquiryStatusCancelled             = 3
    , kJPInquiryStatusRefused               = 4
    , kJPInquiryStatusInvalidated           = 5
    , kJPInquiryStatusHandling              = 20   // 正在处理中
    
    , kJPInquiryStatusAll                   = 999
};

typedef NS_ENUM(NSInteger, EJPInquiryType) {
    kJPInquiryTypeAll               = 0         // 全部
    , kJPInquiryTypeInquiry         = 1         // 询价
    , kJPInquiryTypeNoInquiry       = 2         // 报价
};

@interface InquiryApi_InquiryList : DymRequest <NSCopying>

@property (nonatomic, copy) NSNumber   *pageIndex;
@property (nonatomic, copy) NSNumber   *pageSize;

@property (nonatomic, copy) NSString   *inquirysn;
@property (nonatomic, copy) NSNumber   *startSearchTime;
@property (nonatomic, copy) NSNumber   *endSearchTime;
@property (nonatomic, copy) NSNumber   *status;
@property (nonatomic, copy) NSNumber   *listType;

//@property (nonatomic, copy) NSNumber   *organid;


+(NSString *)stringWithInquiryStatus:(EJPInquiryStatus)status;
+(UIColor *)colorWithInquiryStatus:(EJPInquiryStatus)status;

/// 过滤条件是否改变
-(BOOL)conditionChanged:(InquiryApi_InquiryList *)object;

@end


@interface InquiryApi_InquiryList_Result : DymBaseRespModel
@property (nonatomic, copy) NSArray     *list;
@end

