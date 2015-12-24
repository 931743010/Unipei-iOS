//
//  InquiryApi_FindDistrict.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/15.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

@interface InquiryApi_FindDistrict : DymRequest
@property (nonatomic, strong) NSNumber  *parentID;
@end


@interface InquiryApi_FindDistrict_Result : DymBaseRespModel
@property (nonatomic, copy) NSArray  *list;
@end
