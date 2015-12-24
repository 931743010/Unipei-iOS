//
//  InquiryApi_GetScheme.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/29.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"
#import "JPQuatationItem.h"

@interface InquiryApi_GetScheme : DymRequest

@property (nonatomic, copy) NSNumber    *inquiryid;
@property (nonatomic, copy) NSNumber    *quoid;

@end



@interface InquiryApi_GetScheme_Result : DymBaseRespModel
@property (nonatomic, copy) NSArray     *schemes;
@property (nonatomic, copy) id          QuoStatus;
@end