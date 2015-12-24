//
//  CommonApi_GetArea.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/9.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"
#import "JPAddressNode.h"

@interface CommonApi_GetArea : DymRequest
@property (nonatomic, strong) NSNumber  *parentId;
@end




@interface CommonApi_GetArea_Result : DymBaseRespModel

@property (nonatomic, copy) NSArray  *areaList;

@end