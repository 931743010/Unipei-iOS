//
//  JPCache.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/2.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPAppStatus.h"
#import "JPUtils.h"
#import "DymCommonApi.h"
#import "DymRequest+Helper.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

static ShopApi_Login_Result *loginInfo = nil;

static NSString *default_key_show_server_list = @"default_key_show_server_list";
static NSString *default_key_has_new_message = @"default_key_has_new_message";
static NSString *default_key_has_new_system_message = @"default_key_has_new_system_message";
static NSString *default_key_has_new_business_message = @"default_key_has_new_business_message";

static NSString *default_key_have_seen_intro_before = @"default_key_have_seen_intro_before";

#define ARCHIVE_KEY_ShopLoginResult     @"ARCHIVE_KEY_ShopLoginResult"


@implementation JPAppStatus

+(BOOL)haveSeenIntroBefore {
    return [[NSUserDefaults standardUserDefaults] boolForKey:default_key_have_seen_intro_before];
}

+(void)setHaveSeenIntroBefore:(BOOL)haveSeenIntroBefore {
    [[NSUserDefaults standardUserDefaults] setBool:haveSeenIntroBefore forKey:default_key_have_seen_intro_before];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)showServerList {
#if DEBUG
    return YES;
#else
    return [[NSUserDefaults standardUserDefaults] boolForKey:default_key_show_server_list];
#endif
}

+(void)setShowServerList:(BOOL)showServerList {
    [[NSUserDefaults standardUserDefaults] setBool:showServerList forKey:default_key_show_server_list];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)logout {
    [self logoutQuitely];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JP_NOTIFICATION_LOGOUT object:nil];
}

+(void)logoutQuitely {
    
    DymCommonApi *api = [DymCommonApi new];
    api.relativePath = PATH_userApi_unBindChannelID;
    
    NSString *channelID = [JPAppStatus loginInfo].channelID;
    NSNumber *userID = [JPAppStatus loginInfo].userID;
    if (userID && channelID) {
        api.params = @{@"userID":userID,@"channelID":channelID};
        
        [[DymRequest commonApiSignal:api queue:nil] subscribeNext:^(DymBaseRespModel *result) {
            if (result.success) {
                NSLog(@">>>>>unBindChannelID successed<<<<<<");
            }
        }];
    }
    
    NSString *token = [self loginInfo].token;

    if (token) {
        DymCommonApi *api = [DymCommonApi new];
        api.relativePath = @"userApi/logout.do";
        api.params = @{@"token" : token};
        [[DymRequest commonApiSignal:api queue:nil] subscribeNext:^(DymBaseRespModel *result) {
        }];
    }
    
    /// 不管成功与否，都清掉登录数据
    loginInfo = nil;
    
    [ShopApi_Login_Result unsave];
//    [[NSFileManager defaultManager] removeItemAtPath:[JPAppStatus archivePath:ARCHIVE_KEY_ShopLoginResult] error:nil];
}

+(BOOL)isLoggedIn {
    return [self loginInfo].success;
}

+(ShopApi_Login_Result *)loginInfo {
    if (loginInfo == nil) {
        loginInfo = [self unarchiveShopLoginResult];
    }
    
    return loginInfo;
}
//存入用户登录成功后的用户信息
+(void)archiveShopLoginResult:(ShopApi_Login_Result *)result {
    loginInfo = result;
    
    [loginInfo save];
    
//    NSString *filePath = [JPAppStatus archivePath:ARCHIVE_KEY_ShopLoginResult];
//    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
//    [NSKeyedArchiver archiveRootObject:result toFile:filePath];
}
//取出登录成功后的用户信息
+(ShopApi_Login_Result *)unarchiveShopLoginResult {
    
    return [ShopApi_Login_Result load];
//    return [NSKeyedUnarchiver unarchiveObjectWithFile:[JPAppStatus archivePath:ARCHIVE_KEY_ShopLoginResult]];
}

//存入路径
+(NSString *)archivePath:(NSString *)key {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:key];
}


#pragma mark - message center
+(BOOL)hasNewMessage {
    return [[NSUserDefaults standardUserDefaults] boolForKey:default_key_has_new_message];
}

+(BOOL)hasNewSystemMessage {
    return [[NSUserDefaults standardUserDefaults] boolForKey:default_key_has_new_system_message];
}

+(BOOL)hasNewBusinessMessage {
    return [[NSUserDefaults standardUserDefaults] boolForKey:default_key_has_new_business_message];
}

+(void)setHasNewMessage:(BOOL)hasNewMessage {
    [[NSUserDefaults standardUserDefaults] setBool:hasNewMessage forKey:default_key_has_new_message];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JP_NOTIFICATION_NEW_MESSAGE_STATE_CHANGED object:nil];
}

+(void)setHasNewSystemMessage:(BOOL)hasNewMessage {
    [[NSUserDefaults standardUserDefaults] setBool:hasNewMessage forKey:default_key_has_new_system_message];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JP_NOTIFICATION_NEW_MESSAGE_STATE_CHANGED object:nil];
}

+(void)setHasNewBusinessMessage:(BOOL)hasNewMessage {
    [[NSUserDefaults standardUserDefaults] setBool:hasNewMessage forKey:default_key_has_new_business_message];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:JP_NOTIFICATION_NEW_MESSAGE_STATE_CHANGED object:nil];
}

@end
