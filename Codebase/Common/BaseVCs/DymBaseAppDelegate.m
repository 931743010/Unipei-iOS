//
//  DymBaseAppDelegate.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/28.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseAppDelegate.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "JPDesignSpec.h"
#import <YTKNetwork/YTKNetworkConfig.h>
#import <YTKNetwork/YTKRequest.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "JPServerApiURL.h"
#import "JPUtils.h"

static CGFloat  tickInterval = 0.1;

@interface DymBaseAppDelegate () {
    NSTimer     *_globalTimer;
}

@end

@implementation DymBaseAppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.godModeWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.godModeWindow.backgroundColor = [UIColor clearColor];
    
    [self initLumberJack];
    
    /// Awesome solution for back button
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    [YTKNetworkConfig sharedInstance].baseUrl = [JPServerApiURL baseURL];
    
    [SVProgressHUD setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:0.9]];
    [SVProgressHUD setForegroundColor:[UIColor colorWithWhite:0 alpha:1]];
//    [[SVProgressHUD appearance] setHudBackgroundColor:[UIColor colorWithWhite:0.95 alpha:0.5]];
//    [[SVProgressHUD appearance] setHudForegroundColor:[UIColor colorWithWhite:0 alpha:1]];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.keyboardDistanceFromTextField = 50;
    
    /// global timer start ticking
    _globalTimer = [NSTimer scheduledTimerWithTimeInterval:tickInterval target:self selector:@selector(globalTick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_globalTimer forMode:NSRunLoopCommonModes];
    
    return YES;
}

-(void)globalTick:(NSTimer *)timer {
    [[NSNotificationCenter defaultCenter] postNotificationName:JP_NOTIFICATION_GLOBAL_TIME_TICK object:@(tickInterval)];
}

-(void)initLumberJack {
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    
    [DDLog addLogger:fileLogger];
    
//    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
}

@end
