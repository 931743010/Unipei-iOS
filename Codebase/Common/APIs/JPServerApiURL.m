//
//  ServerApiURL.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/12.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "JPServerApiURL.h"
#import "JPAppStatus.h"
#import <YTKNetwork/YTKNetworkConfig.h>

static NSString *def_key_server_env = @"def_key_server_env";
static BOOL has_loaded_env = NO;

#if DEBUG
    static EJPServerEnv g_serverEnv = kJPServerEnvTestWuhan;
#else
    static EJPServerEnv g_serverEnv = kJPServerEnvProduction;
#endif


@implementation JPServerApiURL

+(EJPServerEnv)serverEnv {

    if ([JPAppStatus showServerList] && !has_loaded_env) {
        has_loaded_env = YES;
        g_serverEnv = [[NSUserDefaults standardUserDefaults] integerForKey:def_key_server_env];
    }
    
    return g_serverEnv;
}

+(void)setServerEnvironment:(EJPServerEnv)serverEnv {
    
    g_serverEnv = serverEnv;
    
    [YTKNetworkConfig sharedInstance].baseUrl = [JPServerApiURL baseURL];
    
    [[NSUserDefaults standardUserDefaults] setInteger:serverEnv forKey:def_key_server_env];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSArray *)serverURLs {
    return @[
             @"http://172.23.3.111:8080"
             , @"http://59.172.62.234:20004"
             , @"http://papi.unipei.com:8080"
             , @"http://172.23.6.1:8080"
             , @"http://101.251.214.180:9090"
             
             , @"http://172.23.2.61:9080"
             , @"http://172.23.2.57:9080"
             , @"http://172.23.3.47:8080"
             , @"http://172.23.2.67:8080"
             , @"http://172.23.2.35:8088"
             , @"http://172.23.2.73:8090"
             ];
}

+(NSArray *)serverNames {
    return @[
             @"测试环境111"
             , @"测试环境-外网"
             , @"生产环境"
             , @"测试部服务器"
             , @"北京服务器"
             
             , @"樊甲"
             , @"鄢青"
             , @"47测试服"
             , @"李伟"
             , @"朱珩"
             , @"叶新亮"
             ];
}

+(NSArray *)fileServerURLs {
    return @[
             @"http://172.23.16.80/"
             , @"http://img1.unipei.com/"
             , @"http://172.23.6.9/"
             , @"http://101.251.214.180:8080/"
             ];
}


+(NSString *)descriptionForEnv:(EJPServerEnv)serverEnv {
    NSString *name = [self serverNames][serverEnv];
    NSString *url = (NSString *)[self serverURLs][serverEnv];
    
    return [NSString stringWithFormat:@"[%@] %@", name, url];
}

+(NSString *)baseURL {
    
    NSArray *URLs = [self serverURLs];
    
    EJPServerEnv serverEnv = [self serverEnv];
    NSString *url = URLs[serverEnv];
    if (url == nil) {
        url = URLs.firstObject;
    }
    return [url stringByAppendingString:@"/commonApi/"];
}

+(NSString *)fileServerURL {
    
    NSArray *fileServerURLs = [self fileServerURLs];
    
    EJPServerEnv serverEnv = [self serverEnv];
    switch (serverEnv) {
            
        case kJPServerEnvProduction:
            return fileServerURLs[kJPFileServerEnvProduction];
            
        case kJPServerEnvTestDepartment:
            return fileServerURLs[kJPFileServerEnvTestDepartment];
            
        case kJPServerEnvTestBeijing:
            return fileServerURLs[kJPFileServerEnvTestBeijing];
            
        default:
            return fileServerURLs[kJPFileServerEnvTest];
    }
    
    return nil;
}

@end
