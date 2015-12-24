//
//  CommonApi_GetCity.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/9.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"
#import "JPAddressNode.h"

@interface CommonApi_GetCity : DymRequest

@property (nonatomic, strong) NSNumber  *parentId;

@end



/// 获取城市列表API结果
@interface CommonApi_GetCity_Result : DymBaseRespModel

@property (nonatomic, copy) NSArray  *cityList;

@end
