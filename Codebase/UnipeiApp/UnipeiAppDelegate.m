//
//  AppDelegate.m
//  UnipeiApp
//
//  Created by Dong Yiming on 15/9/14.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UnipeiAppDelegate.h"
#import "JPAppStatus.h"
#import "DymStoryboard.h"
#import "CommonApi_FindVersionInfo.h"
#import "DymRequest+Helper.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "JPNeverDismissAlertView.h"
#import "UnipeiAppDelegate+APNS.h"
#import "UnipeiAppDelegate+JLRoutes.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <UnipeiApp-Swift.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "UNPIntroVC.h"
#import "DymStoryboard.h"
#import "JPDesignSpec.h"
#import "DymNavigationController.h"
#import "JPDefines.h"

static const DDLogLevel ddLogLevel = DDLogLevelVerbose;

@interface UnipeiAppDelegate () <UIAlertViewDelegate> {
    BOOL            _hasAppEverBeenActivated;
}

@end

@implementation UnipeiAppDelegate

//debug
void uncaughtExceptionHandler(NSException *exception) {
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    // Internal error reporting
}


-(void)applicationDidBecomeActive:(UIApplication *)application {
    
    if (!_hasAppEverBeenActivated) {
        _hasAppEverBeenActivated = YES;
    } else { // 如果以前activate过，即不是刚启动，则根据badgeNumber更新messageStatus
        [self updateMessageStatusByAppBadgeNumber];
    }
    
    //角标清0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    DDLogDebug(@"App启动");
     NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler); //debug
    [super application:application didFinishLaunchingWithOptions:launchOptions];
    
    [self addRoutes];
    
    
    // 登录检测...
    @weakify(self)
    if (![JPAppStatus haveSeenIntroBefore]) {
        [JPAppStatus setHaveSeenIntroBefore:YES];
        @strongify(self)
        UNPIntroVC *vc = [UNPIntroVC new];
        self.window.rootViewController = vc;
        
        @weakify(self)
        vc.dismissedBlock = ^(void) {
            @strongify(self)
            self.window.rootViewController = [[DymStoryboard unipeiMain_Storyboard] instantiateViewControllerWithIdentifier:@"UnipeiTabbarVC"];
            [self checkLoginEnsured:YES];
        };
        
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self checkLoginEnsured:YES];
        });
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkLogin) name:JP_NOTIFICATION_LOGOUT object:nil];
    // 检查版本更新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNewVersion) name:JP_NOTIFICATION_USER_LOGGED_IN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportChannelIdToServer) name:JP_NOTIFICATION_USER_LOGGED_IN object:nil];
    
    
    DDLogDebug(@"App注册百度云推送");
    [self application:application registerBPush:launchOptions];
    
    return YES;
}


-(void)checkNewVersion {
#warning 暂时使用，需要删除
    return;
    if (_didCheckNewVersion) {
        return;
    }
    
    @weakify(self)
    CommonApi_FindVersionInfo *versionApi = [CommonApi_FindVersionInfo new];
    versionApi.osType = @1;
    versionApi.apptype = @"0";
    [[DymRequest commonApiSignal:versionApi queue:nil] subscribeNext:^(CommonApi_FindVersionInfo_Result *result) {
        @strongify(self)
        self->_didCheckNewVersion = YES;
        
        if (result == nil) {
            
            [[JLToast makeText:@"[请DB配置苹果端更新数据]:jpdVersionInfo返回值为空，请配置相关数据后再测这个功能"] show];
        }
        
        if ([result isKindOfClass:[CommonApi_FindVersionInfo_Result class]] && result.success) {
            NSString *currentVersionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
            BOOL forced = [result.isforce boolValue];
            NSString *message = result.desc ? : @"";
            message = [JPUtils stringByConvertReturnTagFromHTMLString:message];
            
            if (forced) {
                
                JPNeverDismissAlertView *alertView = [[JPNeverDismissAlertView alloc] initWithTitle:@"需要更新到新版本哦" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确认升级", nil];
                
                UILabel *lblMessage = [self labelWithMessage:message];
                [alertView setValue:lblMessage forKey:@"accessoryView"];
                alertView.tag = 100;
                [alertView show];
                
            } else {
            
                @weakify(self)
                if ([currentVersionStr longLongValue] < [result.versioncode longLongValue]) {
                    NSString *title = @"当前有新版本是否更新？";
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
                    
                    NSAttributedString *attrMessage = [self attrStringWithMessage:[NSString stringWithFormat:@"\n%@", message]];
                    [alertVC setValue:attrMessage forKey:@"attributedMessage"];
                    
                    [alertVC addAction:[UIAlertAction actionWithTitle:@"暂不升级" style:UIAlertActionStyleDefault handler:nil]];
                    
                    [alertVC addAction:[UIAlertAction actionWithTitle:@"确认升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        @strongify(self)
                        [self openInAppStore];
                    }]];
                    
                    
                    [self.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
                }
                
            }
        }
    }];
}

-(NSAttributedString *)attrStringWithMessage:(NSString *)message {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    paragraphStyle.paragraphSpacing = 2.0f;
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.headIndent = 20.0;
    paragraphStyle.firstLineHeadIndent = 20.0;
    paragraphStyle.tailIndent = -20.0;
    
    NSMutableAttributedString *attribString = [[NSMutableAttributedString alloc]initWithString:message];
    [attribString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [message length])];
    [attribString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f] range:NSMakeRange(0, [message length])];
    
    return attribString;
}

- (UILabel *)labelWithMessage:(NSString *)message {
    
    NSAttributedString *attrStr = [self attrStringWithMessage:message];
    
    UILabel *label = [[UILabel alloc] init];
    [label setAttributedText:attrStr];
    [label setNumberOfLines:0];
    [label sizeToFit];
    return label;
}

-(void)openInAppStore {
    //https://itunes.apple.com/us/app/you-ni-pei-qi-pei-jiao-yi/id1054581130?l=zh&ls=1&mt=8
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/you-ni-pei-qi-pei-jiao-yi/id1054581130?l=zh&ls=1&mt=8"]];
    [JPAppStatus logoutQuitely];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        
        [self openInAppStore];
        
    }else{
        if (buttonIndex == 1) {
            UNPHomepageVC *skipCtr = [[UNPHomepageVC alloc]init];
            // 根视图是nav 用push 方式跳转
            [_tabBarCtr.selectedViewController pushViewController:skipCtr animated:YES];
        }
    }
}

-(void)checkLogin {
    [self checkLoginEnsured:NO];
}

/// 如果ensured为YES，即使已经登录，也会调用SimpleLogin接口，更新token
-(void)checkLoginEnsured:(BOOL)ensured {
    
    if (![JPAppStatus isLoggedIn]) {
//        [JPUtils routeToPath:JP_ROUTE_PATH_LOGIN paramString:nil];  // Route is too slow....
        [self showLoginVC];
        
        [JPUtils closeGodMode];
    } else {
        
        if (ensured && [JPAppStatus loginInfo].loginUsername) {
            DymCommonApi *api = [DymCommonApi new];
            api.relativePath = @"userApi/simpleLogin.do";
            api.params = @{@"username": [JPAppStatus loginInfo].loginUsername
                           , @"token": [JPAppStatus loginInfo].token};
            api.custom_responseModelClass = [ShopApi_Login_Result class];
            
            [[DymRequest commonApiSignal:api queue:nil] subscribeNext:^(ShopApi_Login_Result *result) {
                if (result.success) {
                    
                    ShopApi_Login_Result *loginInfo = [JPAppStatus loginInfo];
                    loginInfo.token = result.token;
                    loginInfo.code = result.code;
                    [JPAppStatus archiveShopLoginResult:loginInfo];
                    [[NSNotificationCenter defaultCenter] postNotificationName:JP_NOTIFICATION_USER_LOGGED_IN object:nil];
                    
                    [self checkNewVersion];
                    
                    [self reportChannelIdToServer];
                }
            }];
            
        } else {
            [self checkNewVersion];
        }
    }
}


-(void)presentNaviEmbededVC:(UIViewController *)vc {
    DymNavigationController *nc = [[DymNavigationController alloc] initWithRootViewController:vc];
    
    UIBarButtonItem *btnClose = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:nil action:NULL];
    btnClose.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [nc.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        
        return [RACSignal empty];
    }];
    vc.navigationItem.rightBarButtonItem = btnClose;
    
    [self.window.rootViewController presentViewController:nc animated:YES completion:nil];
}

@end
