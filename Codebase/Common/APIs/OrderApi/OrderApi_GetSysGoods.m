//
//  OrderApi_GetSysGoods.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/28.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "OrderApi_GetSysGoods.h"

@implementation OrderApi_GetSysGoods


-(NSString *)requestUrl {
    return PATH_orderApi_getSysGoods;
}

-(NSDictionary *)paramToPropertyMap {
    
    return @{@"id": [JPUtils stringValueSafe:_goodsID]};
}

@end
