//
//  YTKBaseRequest+Dym.m
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/11.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "YTKBaseRequest+Dym.h"

@implementation YTKBaseRequest (Dym)

-(NSError *)timeoutError {
    return [YTKBaseRequest createTimeoutError:self.userInfo];
}

+(NSError *)createTimeoutError:(NSDictionary *)userInfo {
    return [NSError errorWithDomain:@"网络好像有点问题哦，请稍候再试" code:REQUEST_ERROR_CODE_TIMEOUT userInfo:userInfo];
}


@end
