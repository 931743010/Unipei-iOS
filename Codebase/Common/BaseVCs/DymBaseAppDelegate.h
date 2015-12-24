//
//  DymBaseAppDelegate.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/28.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

@interface DymBaseAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UIWindow  *godModeWindow;

/// 初始化CocoaLumberJack
-(void)initLumberJack;

@end
