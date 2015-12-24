//
//  InquiryApi_DeleteReceiveAddressById.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/27.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

@interface InquiryApi_DeleteReceiveAddressById : DymRequest
@property (nonatomic, copy) NSNumber    *addressID;
@end
