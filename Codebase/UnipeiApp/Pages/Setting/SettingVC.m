//
//  SettingVC.m
//  DymIOSApp
//
//  Created by xujun on 15/10/22.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "SettingVC.h"
#import <Masonry/Masonry.h>
#import "JPUnSecretUnlockView.h"
#import "JPAppStatus.h"

#define LOGO_RADIUS     (30)

@interface SettingVC () {
    JPUnSecretUnlockView       *_unlockView;
}
@property (weak, nonatomic) IBOutlet UILabel *lblCopyright;
@property (weak, nonatomic) IBOutlet UILabel *lblBarCode;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;

@end

@implementation SettingVC


+(instancetype)newFromStoryboard {
    return [[DymStoryboard common_Storyboard] instantiateViewControllerWithIdentifier:@"SettingVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"关于";
    
    _unlockView = [JPUnSecretUnlockView new];
    [self.view addSubview:_unlockView];
    [_unlockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    _unlockView.unlockBlock = ^(BOOL unlock) {
        if (unlock && ![JPAppStatus showServerList]) {
            [JPAppStatus setShowServerList:YES];
            [JPAppStatus logout];
        }
    };
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    NSString *versionStr;
    
    if ([JPAppStatus showServerList]) {
        NSString *appVBuild = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        versionStr = [NSString stringWithFormat:@"For iOS V%@ build %@", appVersion, appVBuild];
    } else {
        versionStr = [NSString stringWithFormat:@"For iOS V%@", appVersion];
    }

    _lblVersion.text = versionStr;
    
    _lblCopyright.text = @"Copyright © 2015\n北京嘉配unipei.com版权所有";
    
}



@end
