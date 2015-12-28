//
//  ShopApi_Login.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/27.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "ShopApi_Login.h"
#import "NSString+GGAddOn.h"

@implementation ShopApi_Login

-(NSString *)requestUrl {
    return PATH_userApi_login;
}

-(NSDictionary *)paramToPropertyMap {
    return @{@"username" : _phone ? : @""
              , @"password": _password ? _password.md5Str : @""};
}

-(Class)responseModelClass {
    return [ShopApi_Login_Result class];
}

-(NSString *)apiVersionString {
    return @"V2.2";
}

@end





//////////////////////////////////////////////

@implementation ShopApi_Login_Result

+(NSDictionary *) jsonMap {
    return @{
             @"blPoto": @"body.blPoto"
             , @"phone": @"body.phone"
             , @"token": @"body.token"
             , @"organName": @"body.organName"
             , @"organID": @"body.organID"
             , @"userID": @"body.userID"
             , @"logo": @"body.logo"
             , @"unionID": @"body.unionID"
             , @"isMain":@"body.isMain"
             , @"status": @"body.status"
             };
}


+(NSString *)keyForSaving:(NSString *)varName {
    static NSString *prefix = @"ShopApi_Login_Result_Key";
    return [prefix stringByAppendingFormat:@"_%@", varName];
}

-(void)save {
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    [def setBool:self.success forKey:[[self class] keyForSaving:@"success"]];
    [def setObject:self.code forKey:[[self class] keyForSaving:@"code"]];
    [def setObject:self.msg forKey:[[self class] keyForSaving:@"msg"]];
    [def setObject:self.body forKey:[[self class] keyForSaving:@"body"]];
    
    [def setObject:_loginUsername forKey:[[self class] keyForSaving:@"loginUsername"]];
    [def setObject:_loginPassword forKey:[[self class] keyForSaving:@"loginPassword"]];
    
    [def setObject:_userID forKey:[[self class] keyForSaving:@"userID"]];
    [def setObject:_logo forKey:[[self class] keyForSaving:@"logo"]];
    [def setObject:_unionID forKey:[[self class] keyForSaving:@"unionID"]];
    
    [def setObject:_organID forKey:[[self class] keyForSaving:@"organID"]];
    [def setObject:_organName forKey:[[self class] keyForSaving:@"organName"]];
    [def setObject:_token forKey:[[self class] keyForSaving:@"token"]];
    [def setObject:_phone forKey:[[self class] keyForSaving:@"phone"]];
    [def setObject:_blPoto forKey:[[self class] keyForSaving:@"blPoto"]];
    [def setObject:_email forKey:[[self class] keyForSaving:@"email"]];
    
    [def setObject:_qq forKey:[[self class] keyForSaving:@"qq"]];
    [def setObject:_fax forKey:[[self class] keyForSaving:@"fax"]];
    [def setObject:_isMain forKey:[[self class] keyForSaving:@"isMain"]];
    [def setObject:_channelID forKey:[[self class] keyForSaving:@"channelID"]];
    
    [def synchronize];
}


+(void)unsave {
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    [def setBool:NO forKey:[[self class] keyForSaving:@"success"]];
    [def setObject:nil forKey:[[self class] keyForSaving:@"code"]];
    [def setObject:nil forKey:[[self class] keyForSaving:@"msg"]];
    [def setObject:nil forKey:[[self class] keyForSaving:@"body"]];
    
    [def setObject:nil forKey:[[self class] keyForSaving:@"loginUsername"]];
    [def setObject:nil forKey:[[self class] keyForSaving:@"loginPassword"]];
    
    [def setObject:nil forKey:[[self class] keyForSaving:@"userID"]];
    [def setObject:nil forKey:[[self class] keyForSaving:@"logo"]];
    [def setObject:nil forKey:[[self class] keyForSaving:@"unionID"]];
    
    [def setObject:nil forKey:[[self class] keyForSaving:@"organID"]];
    [def setObject:nil forKey:[[self class] keyForSaving:@"organName"]];
    [def setObject:nil forKey:[[self class] keyForSaving:@"token"]];
    [def setObject:nil forKey:[[self class] keyForSaving:@"phone"]];
    [def setObject:nil forKey:[[self class] keyForSaving:@"blPoto"]];
    [def setObject:nil forKey:[[self class] keyForSaving:@"email"]];
    
    [def setObject:nil forKey:[[self class] keyForSaving:@"qq"]];
    [def setObject:nil forKey:[[self class] keyForSaving:@"fax"]];
    [def setObject:nil forKey:[[self class] keyForSaving:@"isMain"]];
    [def setObject:nil forKey:[[self class] keyForSaving:@"channelID"]];
    
    [def synchronize];
}

+(ShopApi_Login_Result *)load {
    
    ShopApi_Login_Result *result = [ShopApi_Login_Result new];
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    
    result.success = [def boolForKey:[self keyForSaving:@"success"]];
    result.code = [def objectForKey:[self keyForSaving:@"code"]];
    result.msg = [def objectForKey:[self keyForSaving:@"msg"]];
    result.body = [def objectForKey:[self keyForSaving:@"body"]];
    
    
    // self
    result.loginUsername = [def objectForKey:[self keyForSaving:@"loginUsername"]];
    result.loginPassword = [def objectForKey:[self keyForSaving:@"loginPassword"]];
    
    result.userID = [def objectForKey:[self keyForSaving:@"userID"]];
    result.logo = [def objectForKey:[self keyForSaving:@"logo"]];
    result.unionID = [def objectForKey:[self keyForSaving:@"unionID"]];
    
    result.organID = [def objectForKey:[self keyForSaving:@"organID"]];
    result.organName = [def objectForKey:[self keyForSaving:@"organName"]];
    result.token = [def objectForKey:[self keyForSaving:@"token"]];
    result.phone = [def objectForKey:[self keyForSaving:@"phone"]];
    result.blPoto = [def objectForKey:[self keyForSaving:@"blPoto"]];
    
    result.email = [def objectForKey:[self keyForSaving:@"email"]];
    result.qq = [def objectForKey:[self keyForSaving:@"qq"]];
    
    result.fax = [def objectForKey:[self keyForSaving:@"fax"]];
    result.isMain = [def objectForKey:[self keyForSaving:@"isMain"]];
    result.channelID = [def objectForKey:[self keyForSaving:@"channelID"]];
    
    return result;
}

@end

// {"header":{"code":"200","success":true,"msg":"操作成功"},"body":{"blpoto":null,"phone":"15725440755","token":"ZWC3NKDDF15IBZ38OIROV8OS4U8K1G","organname":"平原华达","organID":169342}}
