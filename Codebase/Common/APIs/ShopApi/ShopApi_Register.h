//
//  TestApi.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/25.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"


/// 修理厂注册API
@interface ShopApi_Register : DymRequest
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *repassword;
@property (nonatomic, copy) NSString *authCode;
@property (nonatomic, copy) NSString *fromActiveCode;
@end


/// 修理厂注册API结果
@interface ShopApi_Register_Result : DymBaseRespModel
@property (copy, nonatomic, readonly) NSNumber * userId;
@end


/* 返回值
 1. 成功
 {"header":{"code":"200","success":true,"msg":"操作成功"},"body":{"user":{"id":715}}}
 
 2. 失败
 {"header":{"code":"400","success":false,"msg":"该手机号已注册,请登录"},"body":{}}
 */
