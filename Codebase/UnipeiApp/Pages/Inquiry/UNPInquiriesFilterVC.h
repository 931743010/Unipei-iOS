//
//  UNPInquiriesFilterVC.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseTableVC.h"
#import "InquiryApi_InquiryList.h"


/// 询价单筛选
@interface UNPInquiriesFilterVC : DymBaseTableVC

@property (nonatomic, weak) InquiryApi_InquiryList  *filterData;

@end
