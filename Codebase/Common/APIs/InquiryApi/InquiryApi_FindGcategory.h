//
//  InquiryApi_FindGcategory.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

@interface InquiryApi_FindGcategory : DymRequest

@end



@interface InquiryApi_FindGcategory_Result : DymBaseRespModel
@property (nonatomic, copy) NSArray  *list;
@end