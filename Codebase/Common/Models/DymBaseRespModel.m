//
//  DymBaseRespModel.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/27.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseRespModel.h"

@implementation DymBaseRespModel

+(NSDictionary *) baseJSONKeyPathsByPropertyKey {
    
    return @{
             @"code": @"header.code"
             , @"msg": @"header.msg"
             , @"success": @"header.success"
             , @"body": @"body"
             };
    
}

@end
