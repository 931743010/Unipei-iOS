//
//  AppDelegate.h
//  UnipeiApp
//
//  Created by Dong Yiming on 15/9/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymBaseAppDelegate.h"
#import "BPush.h"
#import "UnipeiTabbarVC.h"
#import "UNPHomepageVC.h"

@interface UnipeiAppDelegate : DymBaseAppDelegate {
    /// 是否正在弹出LoginVC
    BOOL                _isTransitingToLoginVC;
    BOOL                _didCheckNewVersion;
    
}

@property (nonatomic, strong) UnipeiTabbarVC      *tabBarCtr;

@property (nonatomic, strong) id                  pushChannelInfo;

-(void)presentNaviEmbededVC:(UIViewController *)vc;

@end

