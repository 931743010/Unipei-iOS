//
//  CommonApi_GetProvince.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/7.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"
#import "JPAddressNode.h"
/// 获取省份列表API
@interface CommonApi_GetProvince : DymRequest

@end



/// 获取省份列表API结果
@interface CommonApi_GetProvince_Result : DymBaseRespModel

@property (nonatomic, copy) NSArray  *provinceList;

@end


