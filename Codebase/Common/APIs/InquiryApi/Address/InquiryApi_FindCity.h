//
//  InquiryApi_FindCity.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/15.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

@interface InquiryApi_FindCity : DymRequest
@property (nonatomic, strong) NSNumber  *parentID;
@end


@interface InquiryApi_FindCity_Result : DymBaseRespModel
@property (nonatomic, copy) NSArray  *list;
@end
