//
//  InquiryApi_FindState.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/15.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

@interface InquiryApi_FindState : DymRequest

@end


@interface InquiryApi_FindState_Result : DymBaseRespModel
@property (nonatomic, copy) NSArray  *list;
@end
