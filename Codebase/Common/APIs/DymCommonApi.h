//
//  DymCommonApi.h
//  DymIOSApp
//
//  Created by Dong Yiming on 15/10/29.
//  Copyright © 2015年 Dong Yiming. All rights reserved.
//

#import "DymRequest.h"

@interface DymCommonApi : DymRequest

@property (nonatomic, strong) NSDictionary  *params;
@property (nonatomic, strong) NSString      *relativePath;
@property (nonatomic, strong) NSString      *apiVersion;

@property (nonatomic, strong) NSString      *custom_organIdKey;
/// organID的类型，默认是NSNumber,可以重新
@property (nonatomic, strong) Class         custom_organIdClass;
@property (nonatomic, strong) Class         custom_responseModelClass;

@end
