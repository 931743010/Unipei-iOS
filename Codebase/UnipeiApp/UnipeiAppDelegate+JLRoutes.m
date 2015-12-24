//
//  UnipeiAppDelegate+JLRoutes.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/11/20.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "UnipeiAppDelegate+JLRoutes.h"
#import <JLRoutes/JLRoutes.h>
#import "UNPSystemMessageDetailVC.h"
#import "UNPOrderDetailVC.h"
#import "UNPMyInquiryVC.h"
#import "DymNavigationController.h"
#import "JPAppStatus.h"

@implementation UnipeiAppDelegate (JLRoutes)

-(BOOL)showLoginVC {
    if (_isTransitingToLoginVC) {
        return YES;
    }
    
    _isTransitingToLoginVC = YES;
    UIViewController *vc = [DymStoryboard unipeiMainLoginNC];
    
    if (self.window.rootViewController.presentedViewController) {
        [self.window.rootViewController dismissViewControllerAnimated:NO completion:^{
            [self.window.rootViewController presentViewController:vc animated:YES completion:^{
                _isTransitingToLoginVC = NO;
            }];
        }];
    } else {
        [self.window.rootViewController presentViewController:vc animated:YES completion:^{
            _isTransitingToLoginVC = NO;
        }];
        
    }
    
    return YES;
}

-(void)addRoutes {
    //
    [JLRoutes addRoute:JP_ROUTE_PATH_LOGIN handler:^BOOL(NSDictionary *parameters) {
        //NSString *username = parameters[@"username"];
        return [self showLoginVC];
    }];
    
    // 系统消息详情-跳转
//    [JLRoutes addRoute:JP_ROUTE_PATH_SYS_MSG_DETAIL handler:^BOOL(NSDictionary *parameters) {
//        
//        UNPSystemMessageDetailVC *vc = [UNPSystemMessageDetailVC newFromStoryboard];
//        vc.batchID = parameters[@"messageID"];
//        
//        [self presentNaviEmbededVC:vc];
//        
//        
//        [JPAppStatus setHasNewSystemMessage:NO];
//        
//        return YES;
//    }];
    
    // 订单详情-跳转
//    [JLRoutes addRoute:JP_ROUTE_PATH_ORDER_DETAIL handler:^BOOL(NSDictionary *parameters) {
//        
//        UNPOrderDetailVC *vc = [UNPOrderDetailVC newFromStoryboard];
//        vc.orderID = @([parameters[@"messageID"] longLongValue]);
//        
//        [self presentNaviEmbededVC:vc];
//        
//        [JPAppStatus setHasNewBusinessMessage:NO];
//        
//        return YES;
//    }];
    
    // 询报价详情
//    [JLRoutes addRoute:JP_ROUTE_PATH_INQUIRY_QUATATION_DETAIL handler:^BOOL(NSDictionary *parameters) {
//        
//        UNPMyInquiryVC *vc = [UNPMyInquiryVC newFromStoryboard];
//        vc.inquiryID = @([parameters[@"messageID"] longLongValue]);
//        vc.inquiryType = kJPInquiryTypeInquiry;
//        
//        [self presentNaviEmbededVC:vc];
//        
//        [JPAppStatus setHasNewBusinessMessage:NO];
//        
//        return YES;
//    }];
    
    // 经销商主动报价详情
//    [JLRoutes addRoute:JP_ROUTE_PATH_DEALER_QUATATION_DETAIL handler:^BOOL(NSDictionary *parameters) {
//        
//        UNPMyInquiryVC *vc = [UNPMyInquiryVC newFromStoryboard];
//        vc.inquiryID = @([parameters[@"messageID"] longLongValue]);
//        vc.inquiryType = kJPInquiryTypeNoInquiry;
//        
//        [self presentNaviEmbededVC:vc];
//        
//        [JPAppStatus setHasNewBusinessMessage:NO];
//        
//        return YES;
//    }];
    
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [JLRoutes routeURL:url];
}

@end
