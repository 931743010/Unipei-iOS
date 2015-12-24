//
//  DymUrlArgumentsFilter.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/9/7.
//  Copyright (c) 2015年 Dong Yiming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YTKNetwork/YTKNetworkConfig.h>

@interface DymUrlArgumentsFilter : NSObject <YTKUrlFilterProtocol>
+ (DymUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments;

@end
