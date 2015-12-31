//
//  JPCache.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/2.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopApi_Login.h"
#import "JPUtils.h"


typedef NS_ENUM(NSInteger, EJPPushType) {
    kJPPushTypeSystem = 1
    , kJPPushTypeBusiness = 2
};

typedef NS_ENUM(NSInteger, EJPPushMessageType) {
    kJPPushMessageTypeOrder = 1
    , kJPPushMessageTypeQuatationInquiry = 2    // 被动报价，就是询价后报的价
    , kJPPushMessageTypeQuatationDealer = 3   // 主动报价，经销商主动报，没有询价
};


@interface JPAppStatus : NSObject

+(NSString *)recordedAppVersion;
+(void)setRecordedAppVersion:(NSString *)recordedAppVersion;

+(BOOL)haveSeenIntroBefore;
+(void)setHaveSeenIntroBefore:(BOOL)haveSeenIntroBefore;

+(BOOL)showServerList;
+(void)setShowServerList:(BOOL)showServerList;

+(void)logout;
+(void)logoutQuitely;

+(BOOL)isLoggedIn;
//+(void)checkAndLoginIfNeeded;

+(ShopApi_Login_Result *)loginInfo;
+(void)archiveShopLoginResult:(ShopApi_Login_Result *)result;
+(ShopApi_Login_Result *)unarchiveShopLoginResult;

#pragma mark - message center
+(BOOL)hasNewMessage;
+(BOOL)hasNewSystemMessage;
+(BOOL)hasNewBusinessMessage;

+(void)setHasNewMessage:(BOOL)hasNewMessage;
+(void)setHasNewSystemMessage:(BOOL)hasNewMessage;
+(void)setHasNewBusinessMessage:(BOOL)hasNewMessage;

@end
