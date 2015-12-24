//
//  DealerApi_AddDealer.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/11.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DealerApi_AddDealer.h"

@implementation DealerApi_AddDealer

-(NSString *)requestUrl {
    return PATH_dealerApi_addDealer;
}

-(NSDictionary *)paramToPropertyMap {
    
    NSMutableDictionary *params =
            @{@"info": _info ? : @""
              , @"categoryId": _categoryId ? : @""
              , @"contact": _contact ? : @""
              , @"telphone": _telphone ? : @""
              , @"runYears": _runYears ? : @""
              , @"personNum": _personNum ? : @""
              , @"makesId": _makesId ? : @""
              , @"introduction": _introduction ? : @""
              , @"address": _address ? : @""
              , @"mdPhoto": _mdPhoto ? : @""
              , @"concept": _concept ? : @""
              , @"advent": _advent ? : @""}.mutableCopy;
    
    if (_uid.length > 0) {
        [params setObject:_uid forKey:@"uid"];
    }
    
    return params;
}


-(Class)responseModelClass {
    return [DealerApi_AddDealer_Result class];
}

@end


@implementation DealerApi_AddDealer_Result
+(NSDictionary *) jsonMap {
    return @{
             @"dealerId": @"body.dealerId"
             };
}
@end
