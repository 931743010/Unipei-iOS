//
//  InquiryApi_FindGcategoryChild.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

@interface InquiryApi_FindGcategoryChild : DymRequest
@property (nonatomic, copy)NSNumber     *parentID;
@end

@interface InquiryApi_FindGcategoryChild_Result : DymBaseRespModel
@property (nonatomic, copy) NSArray  *list;
@end
