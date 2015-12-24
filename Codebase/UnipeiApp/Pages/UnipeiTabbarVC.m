//
//  UnipeiTabbarVC.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/25.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "UnipeiTabbarVC.h"
#import "JPDesignSpec.h"
#import "JPAppStatus.h"


@interface UnipeiTabbarVC () <UITabBarControllerDelegate>

@end

@implementation UnipeiTabbarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.barTintColor = [UIColor whiteColor];
    self.tabBar.translucent = NO;
    self.tabBar.tintColor = [JPDesignSpec colorMajor];
    self.delegate = self;
    
//    UIViewController *vc = self.viewControllers[0];
    NSMutableArray *tabbarItems = [NSMutableArray array];
    
    UITabBarItem *tabBarItem;
    tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
    [tabbarItems addObject:tabBarItem];
    
    tabBarItem = [[UITabBarItem alloc] initWithTitle:@"询报价" image:[UIImage imageNamed:@"tabbar_inquiry"] selectedImage:[UIImage imageNamed:@"tabbar_inquiry_selected"]];
    [tabbarItems addObject:tabBarItem];
    
    tabBarItem = [[UITabBarItem alloc] initWithTitle:@"经销商" image:[UIImage imageNamed:@"tabbar_dealer"] selectedImage:[UIImage imageNamed:@"tabbar_dealer_selected"]];
    [tabbarItems addObject:tabBarItem];
    
    tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"tabbar_me"] selectedImage:[UIImage imageNamed:@"tabbar_me_selected"]];
    [tabbarItems addObject:tabBarItem];
    
//    tabBarItem = [[UITabBarItem alloc] initWithTitle:@"需求" image:[UIImage imageNamed:@"tabbar_demand"] selectedImage:[UIImage imageNamed:@"tabbar_demand_selected"]];
//    [tabbarItems addObject:tabBarItem];
    
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        obj.tabBarItem = tabbarItems[idx];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLogin) name:JP_NOTIFICATION_USER_LOGGED_IN object:nil];
}

-(void)handleLogin {
    [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)obj popToRootViewControllerAnimated:NO];
        }
    }];
    
    self.selectedIndex = 0;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - tabbar controller delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    NSInteger shouldSelectIndex = [tabBarController.viewControllers indexOfObject:viewController];
    
    if (shouldSelectIndex != 0 && ![JPAppStatus isLoggedIn]) {
        [JPUtils routeToPath:JP_ROUTE_PATH_LOGIN paramString:nil];
        return NO;
    }
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}


#pragma mark - orientations
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
