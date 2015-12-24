//
//  UnipeiAppDelegate+APNS.m
//  DymIOSApp
//
//  Created by xujun on 15/11/11.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//
// NOTE: PAP测试服务器地址: 173.23.6.2 登录名:kaiying 密码:123456
// 后台: http://172.23.6.2/customservice/usystem/remind/index 登录名:pengw 密码:123456

// IOS cant get all push notifications if not launched by a notification bar
// http://stackoverflow.com/questions/11290661/how-to-catch-all-ios-push-notifications-with-different-user-actions-including-ta

#import "UnipeiAppDelegate+APNS.h"
#import "JPAppStatus.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "UNPSystemMessageDetailVC.h"
#import "UNPOrderDetailVC.h"
#import "UNPMyInquiryVC.h"
#import "DymNavigationController.h"
#import "JPAppStatus.h"
#import "JPDefines.h"


static const DDLogLevel ddLogLevel = DDLogLevelVerbose;


////////////////////////////////////////////////////////////////////////////
@interface JPApnsMessage : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy, readonly) id alert;
@property (nonatomic, copy, readonly) id sound;

@property (nonatomic, copy, readonly) id msgID;
@property (nonatomic, copy, readonly) id batchID;
@property (nonatomic, copy, readonly) id msgType;
@property (nonatomic, copy, readonly) id organID;
@property (nonatomic, copy, readonly) id sendTime;
@property (nonatomic, copy, readonly) id type;

@property (nonatomic, copy) id originalData;

@end

@implementation JPApnsMessage

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"alert": @"aps.alert",
             @"sound": @"aps.sound",
             @"msgID": @"msgID",
             @"batchID": @"batchID",
             @"msgType": @"msgType",
             @"organID": @"organID",
             @"sendTime": @"sendTime",
             @"type": @"type"
             };
}

@end


////////////////////////////////////////////////////////////////////////////
@implementation UnipeiAppDelegate (APNS)

-(void)application:(UIApplication *)application registerBPush : (NSDictionary *)launchOptions {
    
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    
    DDLogDebug(@"正在注册百度云推送Channel...");
    
    BOOL isDebug = NO;
#if DEBUG
    isDebug = YES;
#endif
    
    [BPush registerChannel:launchOptions apiKey:@"l95ubj2w6c3VK6WxUAkycR0o"
                  pushMode:(isDebug ? BPushModeDevelopment : BPushModeProduction)
           withFirstAction:nil withSecondAction:nil
              withCategory:nil isDebug:isDebug];
    
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        DDLogDebug(@"从APNS启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    } else {
        [self updateMessageStatusByAppBadgeNumber];
    }
    
#if TARGET_IPHONE_SIMULATOR
    Byte dt[32] = {0xc6, 0x1e, 0x5a, 0x13, 0x2d, 0x04, 0x83, 0x82, 0x12, 0x4c, 0x26, 0xcd, 0x0c, 0x16, 0xf6, 0x7c, 0x74, 0x78, 0xb3, 0x5f, 0x6b, 0x37, 0x0a, 0x42, 0x4f, 0xe7, 0x97, 0xdc, 0x9f, 0x3a, 0x54, 0x10};
    [self application:application didRegisterForRemoteNotificationsWithDeviceToken:[NSData dataWithBytes:dt length:32]];
#endif
    
}

-(void)updateMessageStatusByAppBadgeNumber {
    NSInteger badgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (badgeNumber > 0) {
        [JPAppStatus setHasNewMessage:YES];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    [self application:application handleRemoteNotificationInfo:userInfo];
    
     completionHandler(UIBackgroundFetchResultNewData);
}

// 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    DDLogDebug(@"获得APNS deviceToken:%@",deviceToken);
    DDLogDebug(@"注册百度推送");
    
    [BPush registerDeviceToken:deviceToken];
    
    __weak typeof (self) weakSelf = self;
    DDLogDebug(@"绑定ChannelID到百度...");
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        DDLogDebug(@"绑定ChannelID到百度...结果...error:%@", error);
        weakSelf.pushChannelInfo = result;
        [self reportChannelIdToServer];
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    DDLogDebug(@"DeviceToken 获取失败，原因：%@",error);
}

#pragma mark - actions
-(void)application:(UIApplication *)application handleRemoteNotificationInfo:(NSDictionary *)remoteInfo {
    
    DDLogDebug(@"App state:%@\nApns message:%@", @(application.applicationState), remoteInfo);
    
    JPApnsMessage *message = [MTLJSONAdapter modelOfClass:[JPApnsMessage class] fromJSONDictionary:remoteInfo error:nil];
    message.originalData = remoteInfo;
    
    
    /// 设置红点
    [JPAppStatus setHasNewMessage:YES];
    BOOL isSystemMessage = [message.type integerValue] == kJPPushTypeSystem;
    if (isSystemMessage) {
        [JPAppStatus setHasNewSystemMessage:YES];
    } else {
        [JPAppStatus setHasNewBusinessMessage:YES];
    }
    
    
    if (application.applicationState != UIApplicationStateInactive) {
        // 模拟本地通知
        [self fireLocalNotificationByApnsMessage:message];
    } else {
        // 根据不同消息类型跳界面
        [self routeByApnsMessage:message];
    }
}

-(void)routeByApnsMessage:(JPApnsMessage *)apnsMessage {
    
    [JPAppStatus setHasNewMessage:NO];
    
    EJPPushType pushType = [apnsMessage.type integerValue];

    if (pushType == kJPPushTypeSystem) { // 系统消息
        
        NSString *paramString = apnsMessage.batchID; //[NSString stringWithFormat:@"messageID=%@", apnsMessage.batchID];
        
//        [JPUtils routeToPath:JP_ROUTE_PATH_SYS_MSG_DETAIL paramString:paramString];
        
        UNPSystemMessageDetailVC *vc = [UNPSystemMessageDetailVC newFromStoryboard];
        vc.batchID = paramString; //parameters[@"messageID"];
        
        [self presentNaviEmbededVC:vc];
        
        
        [JPAppStatus setHasNewSystemMessage:NO];
        
    } else if (pushType == kJPPushTypeBusiness) { // 业务消息
        
        if ([apnsMessage.organID longLongValue] != [[JPAppStatus loginInfo].organID longLongValue]) {
            // Not the same guy
            return;
        }
        
//        NSString *paramString = [NSString stringWithFormat:@"messageID=%@", apnsMessage.msgID];
        
        EJPPushMessageType pushMessageType = [apnsMessage.msgType integerValue];
        switch (pushMessageType) {
            case kJPPushMessageTypeOrder: {
//                [JPUtils routeToPath:JP_ROUTE_PATH_ORDER_DETAIL paramString:paramString];
                
                UNPOrderDetailVC *vc = [UNPOrderDetailVC newFromStoryboard];
                vc.orderID = apnsMessage.msgID; //@([parameters[@"messageID"] longLongValue]);
                
                [self presentNaviEmbededVC:vc];
                
                [JPAppStatus setHasNewBusinessMessage:NO];
            }
                break;
                
            case kJPPushMessageTypeQuatationDealer:
//                [JPUtils routeToPath:JP_ROUTE_PATH_DEALER_QUATATION_DETAIL paramString:paramString];
            {
                UNPMyInquiryVC *vc = [UNPMyInquiryVC newFromStoryboard];
                vc.inquiryID = apnsMessage.msgID; //@([parameters[@"messageID"] longLongValue]);
                vc.inquiryType = kJPInquiryTypeNoInquiry;
                
                [self presentNaviEmbededVC:vc];
                
                [JPAppStatus setHasNewBusinessMessage:NO];
            }
                break;
                
            case kJPPushMessageTypeQuatationInquiry:
//                [JPUtils routeToPath:JP_ROUTE_PATH_INQUIRY_QUATATION_DETAIL paramString:paramString];
            {
                UNPMyInquiryVC *vc = [UNPMyInquiryVC newFromStoryboard];
                vc.inquiryID = apnsMessage.msgID; //@([parameters[@"messageID"] longLongValue]);
                vc.inquiryType = kJPInquiryTypeInquiry;
                
                [self presentNaviEmbededVC:vc];
                
                [JPAppStatus setHasNewBusinessMessage:NO];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)fireLocalNotificationByApnsMessage:(JPApnsMessage *)apnsMessage {

    NSString *alertTitle = ([apnsMessage.type integerValue] == kJPPushTypeSystem ? @"系统消息" : @"业务消息");
    
    UIAlertController *alertVC = [JPUtils alert:alertTitle message:apnsMessage.alert comfirmBlock:^(UIAlertAction *action) {
        
        [self routeByApnsMessage:apnsMessage];
        
    } confirmTitle:@"查看" cancelBlock:^(UIAlertAction *action) {
        
    } cancelTitle:@"关闭"];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
}


#pragma mark - report channelID to Jiaparts Server
-(void)reportChannelIdToServer {
    
    NSString *channelID = self.pushChannelInfo[@"channel_id"];
    
    if (![JPAppStatus isLoggedIn]
        || channelID == nil
        || [JPAppStatus loginInfo].userID == nil) {
        return;
    }
    
    DymCommonApi *api = [DymCommonApi new];
    api.relativePath = PATH_userApi_bindChannelID;
    api.params = @{@"userID": [JPAppStatus loginInfo].userID
                   , @"channelID": channelID};
    [[DymRequest commonApiSignal:api queue:nil] subscribeNext:^(DymBaseRespModel *result) {
        if (result.success) {
            DDLogDebug(@"report channelID OK!");
            ShopApi_Login_Result *loginInfo = [JPAppStatus loginInfo];
            loginInfo.channelID = channelID;
            
            [JPAppStatus archiveShopLoginResult:loginInfo];
        }
    }];
    

#if 0
    NSString *message = [NSString stringWithFormat:@"注册百度推送成功！\n\nChannelID:\n%@", channelID];
    
    DDLogDebug(@"%@", message);
    
    [JPUtils showAlert:@"绑定ChannelID" message:message];
    
    [UIPasteboard generalPasteboard].string = channelID;
#endif
    
}

@end
