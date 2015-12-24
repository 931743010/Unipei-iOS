//
//  InquiryApi_FindGcategoryGrandchild.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

@interface InquiryApi_FindGcategoryGrandchild : DymRequest
@property (nonatomic, copy)NSNumber     *parentID;
@end

@interface InquiryApi_FindGcategoryGrandchild_Result : DymBaseRespModel
@property (nonatomic, copy) NSArray  *list;
@end
