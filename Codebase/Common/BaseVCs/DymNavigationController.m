//
//  DymNavigationController.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/8/31.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymNavigationController.h"
#import "JPDesignSpec.h"
#import "UIViewController+BasicBehavior.h"
#import "UIImage+ImageWithColor.h"

@interface DymNavigationController ()

@end



@implementation DymNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.barTintColor = [JPDesignSpec colorMajor];
    self.navigationBar.translucent = NO;
    self.navigationBar.barStyle = UIBarStyleBlackOpaque;
    self.navigationBar.tintColor = [JPDesignSpec colorWhite];
    
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    
    [self.navigationBar setShadowImage:[UIImage new]];
}


#pragma mark - orientations
- (BOOL)shouldAutorotate
{
    return [self _shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self _supportedInterfaceOrientations];
}


@end
