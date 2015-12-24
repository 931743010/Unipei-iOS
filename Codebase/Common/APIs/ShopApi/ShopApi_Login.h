//
//  ShopApi_Login.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/27.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

static NSString  *JP_NOTIFICATION_USER_LOGGED_IN = @"JP_NOTIFICATION_USER_LOGGED_IN";

/// 修理厂登录API
@interface ShopApi_Login : DymRequest

@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *password;

@end




/// 修理厂登录API结果
@interface ShopApi_Login_Result : DymBaseRespModel

@property (copy, nonatomic) NSString * loginUsername;
@property (copy, nonatomic) NSString * loginPassword;

@property (copy, nonatomic) NSNumber * userID;
@property (copy, nonatomic) NSString * logo;
@property (copy, nonatomic) NSNumber * unionID;

@property (copy, nonatomic) NSNumber * organID;
@property (copy, nonatomic) NSString * organName;
@property (copy, nonatomic) NSString * token;
@property (copy, nonatomic) NSString * phone;
@property (copy, nonatomic) NSString * blPoto;
@property (copy, nonatomic) NSString * email;
@property (copy, nonatomic) NSString * qq;
@property (copy, nonatomic) NSString * fax;
@property (copy, nonatomic) NSString * isMain;
@property (nonatomic, copy) NSString *channelID;


-(void)save;
+(void)unsave;
+(ShopApi_Login_Result *)load;

@end