//
//  UnipeiAppDelegate+APNS.h
//  DymIOSApp
//
//  Created by xujun on 15/11/11.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UnipeiAppDelegate.h"

@interface UnipeiAppDelegate (APNS)

-(void)application:(UIApplication *)application registerBPush : (NSDictionary *)launchOptions;

-(void)reportChannelIdToServer;

-(void)updateMessageStatusByAppBadgeNumber;

@end
