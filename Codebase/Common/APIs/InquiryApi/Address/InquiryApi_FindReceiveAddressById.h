//
//  InquiryApi_FindReceiveAddressById.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/12.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"
#import "JPInquiryAddress.h"

@interface InquiryApi_FindReceiveAddressById : DymRequest
@property (nonatomic, copy) NSNumber    *addressID;
@end

@interface InquiryApi_FindReceiveAddressById_Result : DymBaseRespModel
@property (nonatomic, copy) JPInquiryAddress    *address;
@end