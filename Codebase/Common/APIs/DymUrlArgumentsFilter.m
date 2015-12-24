//
//  DymUrlArgumentsFilter.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/7.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "DymUrlArgumentsFilter.h"
#import <YTKNetwork/YTKNetworkPrivate.h>

@implementation DymUrlArgumentsFilter {
    NSDictionary *_arguments;
}

+ (DymUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments {
    return [[self alloc] initWithArguments:arguments];
}

- (id)initWithArguments:(NSDictionary *)arguments {
    self = [super init];
    if (self) {
        _arguments = arguments;
    }
    return self;
}

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request {
    return [YTKNetworkPrivate urlStringWithOriginUrlString:originUrl appendParameters:_arguments];
}

@end
