//
//  UNPInquiryDetailVC.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseVC.h"
#import "InquiryApi_InquiryList.h"

/// 我的询价单/询价单详情, 作为三个子VC的parentVC
@interface UNPMyInquiryVC : DymBaseVC

@property (nonatomic, copy) NSNumber            *inquiryID;
@property (nonatomic, assign) EJPInquiryType    inquiryType;

@property (nonatomic, strong) id                inquiry;

@end
