//
//  InquiryApi_FindReceiveAddress.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/12.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"
#import "JPInquiryAddress.h"

@interface InquiryApi_FindReceiveAddress : DymRequest

@end



@interface InquiryApi_FindReceiveAddress_Result : DymBaseRespModel
@property (nonatomic, copy) NSArray    *addressList;
@end
