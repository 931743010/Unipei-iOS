//
//  TestApi.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/25.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "ShopApi_Register.h"


@implementation ShopApi_Register


-(NSString *)requestUrl {
    return PATH_userApi_registXLC;
}

-(NSDictionary *)paramToPropertyMap {
    return @{@"username": _username ? : @""
             , @"phone" : _phone ? : @""
             , @"passWord": _password ? : @""
             , @"rePassWord" : _repassword ? : @""
             , @"authCode": _authCode ? : @""};
}

-(id)requestArgument {
    NSMutableDictionary *param = [self paramToPropertyMap].mutableCopy;
    if (_fromActiveCode.length > 0) {
        [param setObject:_fromActiveCode forKey:@"fromActiveCode"];
    }
    
    NSString *value = [self jsonFromData:param];
//    value = @"{\"token\":\"J91S672TGJVEMVM89B721IFKWPOPMA\",\"categoryId\":\"1\"}";
    return @{@"param": value};
//    return @{@"param": [self encryptUsing3DES:value]};
}


-(Class)responseModelClass {
    return [ShopApi_Register_Result class];
}

@end




/////////////////////////////////
@implementation ShopApi_Register_Result

+(NSDictionary *) jsonMap {
    return @{
             @"userId": @"body.user.id"
             };
}

@end