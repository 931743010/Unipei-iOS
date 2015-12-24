//
//  ShopApi_GetAuthCode.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/27.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"


/// 验证码类型
typedef NS_ENUM(NSInteger, EAuthCodeType) {
    kAuthCodeManRegister            = 1     // 技师注册
    , kAuthCodeManFindPassword      = 2     // 技师找回密码
    , kAuthCodeShopRegister         = 3     // 修理厂注册
    , kAuthCodeShopRegisterNotice   = 4     // 修理厂注册成功通知
    , kAuthCodeShopFindPassword     = 5     // 修理厂密码找回
    , kAuthCodeImportOKNotice       = 6     // 运营人员导入及添加的经销商和修理厂成功后发送短信通知
    , kAuthCodeContactShop          = 7     // 待联系修理厂清单中点击发送邀请短信
    , kAuthCodeQueryShop            = 8     // 向修理厂发起询价的经销商发送短信通知
    , kAuthCodeShopToDealerConfirm  = 9     // 修理厂确认报价后向确认的经销商发送确认通知
    , kAuthCodeDealerToShopConfirm  = 10    // 经销商发送报价后向修理厂发送短信通知
};



/// 获取验证码API
@interface CommonApi_GetAuthCode : DymRequest

@property (nonatomic, copy) NSString    *msgTitle;  // 短信内容	type为7，8，9，10时必传
@property (nonatomic, copy) NSString    *phone;
@property (nonatomic, assign) NSNumber  *type;

@end



/// 获取验证码API结果
@interface JPAuthCode : DymBaseRespModel

@property (copy, nonatomic, readonly) NSString *authCode;
@property (copy, nonatomic, readonly) NSNumber * sendTime;

@end


/* 返回值
 1. 成功
 {"header":{"code":"200","success":true,"msg":"成功发送手机验证码"},"body":{"authCode":"0000","sendTime":1440653561}}
 
 2. 失败
 {"header":{"code":"400","success":false,"msg":"当日短信验证数超过6次"},"body":{}}
 */
