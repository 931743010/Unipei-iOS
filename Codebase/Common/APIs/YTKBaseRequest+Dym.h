//
//  YTKBaseRequest+Dym.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/11.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import "YTKBaseRequest.h"

#define REQUEST_ERROR_CODE_TIMEOUT       (-999)

@interface YTKBaseRequest (Dym)

-(NSError *)timeoutError;
+(NSError *)createTimeoutError:(NSDictionary *)userInfo;

@end
