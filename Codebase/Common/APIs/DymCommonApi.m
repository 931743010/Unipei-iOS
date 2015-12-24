//
//  DymCommonApi.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/29.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "DymCommonApi.h"

@implementation DymCommonApi

-(NSString *)requestUrl {
    return _relativePath;
}

-(NSDictionary *)paramToPropertyMap {
    return _params;
}

-(NSString *)organIdParamKey {
    if (_custom_organIdKey) {
        return _custom_organIdKey;
    }
    
    return [super organIdParamKey];
}

-(Class)organIdParamClass {
    if (_custom_organIdClass) {
        return _custom_organIdClass;
    }
    
    return [super organIdParamClass];
}

-(Class)responseModelClass {
    if (_custom_responseModelClass) {
        return _custom_responseModelClass;
    }

    return [super responseModelClass];
}

-(NSString *)apiVersionString {
    
    if (_apiVersion.length > 0) {
        return _apiVersion;
    }
    
    return [super apiVersionString];
}

@end
